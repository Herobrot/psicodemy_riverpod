import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment_model.dart';
import '../exceptions/appointment_exception.dart';
import '../repositories/appointment_repository.dart';

/// Estado para la lista de citas
@immutable
class AppointmentListState {
  final List<AppointmentModel> appointments;
  final bool isLoading;
  final AppointmentException? error;
  final bool hasMore;
  final int currentPage;

  const AppointmentListState({
    this.appointments = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  AppointmentListState copyWith({
    List<AppointmentModel>? appointments,
    bool? isLoading,
    AppointmentException? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return AppointmentListState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentListState &&
        other.appointments == appointments &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.hasMore == hasMore &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode {
    return appointments.hashCode ^
        isLoading.hashCode ^
        error.hashCode ^
        hasMore.hashCode ^
        currentPage.hashCode;
  }
}

/// Notificador para la lista de citas
class AppointmentListNotifier extends StateNotifier<AppointmentListState> {
  final AppointmentRepository _repository;

  AppointmentListNotifier(this._repository) : super(const AppointmentListState());

  /// Cargar citas con filtros
  Future<void> loadAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = const AppointmentListState();
    }

    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appointments = await _repository.getAppointments(
        idTutor: idTutor,
        idAlumno: idAlumno,
        estadoCita: estadoCita,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: refresh ? 1 : state.currentPage,
        limit: 20,
      );

      final List<AppointmentModel> newAppointments = refresh
          ? appointments
          : [...state.appointments, ...appointments];

      state = state.copyWith(
        appointments: newAppointments,
        isLoading: false,
        hasMore: appointments.length == 20,
        currentPage: refresh ? 2 : state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppointmentException ? e : AppointmentException.unknown(e.toString()),
      );
    }
  }

  /// Cargar más citas (paginación)
  Future<void> loadMoreAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    if (!state.hasMore || state.isLoading) return;

    await loadAppointments(
      idTutor: idTutor,
      idAlumno: idAlumno,
      estadoCita: estadoCita,
      fechaDesde: fechaDesde,
      fechaHasta: fechaHasta,
    );
  }

  /// Refrescar lista
  Future<void> refresh({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    await loadAppointments(
      idTutor: idTutor,
      idAlumno: idAlumno,
      estadoCita: estadoCita,
      fechaDesde: fechaDesde,
      fechaHasta: fechaHasta,
      refresh: true,
    );
  }

  /// Actualizar una cita en la lista
  void updateAppointmentInList(AppointmentModel updatedAppointment) {
    final appointments = state.appointments.map((appointment) {
      return appointment.id == updatedAppointment.id
          ? updatedAppointment
          : appointment;
    }).toList();

    state = state.copyWith(appointments: appointments);
  }

  /// Eliminar una cita de la lista
  void removeAppointmentFromList(String appointmentId) {
    final appointments = state.appointments
        .where((appointment) => appointment.id != appointmentId)
        .toList();

    state = state.copyWith(appointments: appointments);
  }

  /// Agregar una nueva cita a la lista
  void addAppointmentToList(AppointmentModel newAppointment) {
    final appointments = [newAppointment, ...state.appointments];
    state = state.copyWith(appointments: appointments);
  }

  /// Limpiar estado
  void clear() {
    state = const AppointmentListState();
  }
}

/// Provider para la lista de citas
final appointmentListProvider = StateNotifierProvider<AppointmentListNotifier, AppointmentListState>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentListNotifier(repository);
});

/// Provider para las citas del tutor actual
final myAppointmentsAsTutorProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getMyAppointmentsAsTutor();
});

/// Provider para las citas del alumno actual
final myAppointmentsAsStudentProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getMyAppointmentsAsStudent();
});

/// Provider para obtener una cita específica
final appointmentByIdProvider = FutureProvider.family<AppointmentModel, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getAppointmentById(appointmentId);
});

/// Provider para estadísticas de citas
final appointmentStatsProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getAppointmentStats(
    tutorId: params['tutorId'],
    alumnoId: params['alumnoId'],
    fechaDesde: params['fechaDesde'],
    fechaHasta: params['fechaHasta'],
  );
});

/// Provider para verificar conflictos de horario
final scheduleConflictProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.hasScheduleConflict(
    params['tutorId'],
    params['fechaCita'],
    excludeAppointmentId: params['excludeAppointmentId'],
  );
});

/// Provider para obtener el próximo horario disponible
final nextAvailableSlotProvider = FutureProvider.family<DateTime?, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.getNextAvailableSlot(
    params['tutorId'],
    params['fechaPreferida'],
  );
});

/// Provider para el estado de salud del servicio
final appointmentServiceHealthProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.isServiceHealthy();
});

/// Provider para crear una cita
final createAppointmentProvider = FutureProvider.family<AppointmentModel, CreateAppointmentRequest>((ref, request) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.createAppointment(request);
});

/// Provider para actualizar una cita
final updateAppointmentProvider = FutureProvider.family<AppointmentModel, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.updateAppointment(
    params['id'],
    params['request'],
  );
});

/// Provider para actualizar estado de una cita
final updateAppointmentStatusProvider = FutureProvider.family<AppointmentModel, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.updateAppointmentStatus(
    params['id'],
    params['estado'],
  );
});

/// Provider para confirmar una cita
final confirmAppointmentProvider = FutureProvider.family<AppointmentModel, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.confirmAppointment(appointmentId);
});

/// Provider para cancelar una cita
final cancelAppointmentProvider = FutureProvider.family<AppointmentModel, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.cancelAppointment(appointmentId);
});

/// Provider para completar una cita
final completeAppointmentProvider = FutureProvider.family<AppointmentModel, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.completeAppointment(
    params['id'],
    finishToDo: params['finishToDo'],
  );
});

/// Provider para marcar como no asistida
final markAsNoShowProvider = FutureProvider.family<AppointmentModel, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.markAsNoShow(appointmentId);
});

/// Provider para eliminar una cita
final deleteAppointmentProvider = FutureProvider.family<bool, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return await repository.deleteAppointment(appointmentId);
}); 