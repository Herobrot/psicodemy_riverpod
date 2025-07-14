import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../appointment_service.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/appointment_repository_interface.dart';
import '../models/appointment_model.dart';
import '../exceptions/appointment_exception.dart';
import '../../auth/auth_service.dart';
import '../../api_service_provider.dart';

/// Estado para la lista de citas
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
}

/// StateNotifier para gestionar el estado de la lista de citas
class AppointmentListNotifier extends StateNotifier<AppointmentListState> {
  final AppointmentRepository _repository;

  AppointmentListNotifier(this._repository) : super(const AppointmentListState());

  /// Obtener citas
  Future<void> getAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final appointments = await _repository.getAppointments(
        idTutor: idTutor,
        idAlumno: idAlumno,
        estadoCita: estadoCita,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
      
      state = state.copyWith(
        appointments: appointments,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppointmentException ? e : AppointmentException.simple(e.toString()),
      );
    }
  }

  /// Crear nueva cita
  Future<void> createAppointment({
    required String idTutor,
    required String idAlumno,
    required DateTime fechaHora,
    required String descripcion,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Crear un objeto simple para la cita
      final newAppointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idTutor: idTutor,
        idAlumno: idAlumno,
        fechaCita: fechaHora,
        toDo: descripcion,
        estadoCita: EstadoCita.pendiente,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      state = state.copyWith(
        appointments: [...state.appointments, newAppointment],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppointmentException ? e : AppointmentException.simple(e.toString()),
      );
    }
  }

  /// Actualizar cita
  Future<void> updateAppointment({
    required String appointmentId,
    DateTime? fechaHora,
    String? descripcion,
    EstadoCita? estadoCita,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedAppointments = state.appointments.map<AppointmentModel>((appointment) {
        if (appointment.id == appointmentId) {
          return AppointmentModel(
            id: appointment.id,
            idTutor: appointment.idTutor,
            idAlumno: appointment.idAlumno,
            fechaCita: fechaHora ?? appointment.fechaCita,
            toDo: descripcion ?? appointment.toDo,
            estadoCita: estadoCita ?? appointment.estadoCita,
            createdAt: appointment.createdAt,
            updatedAt: DateTime.now(),
            deletedAt: appointment.deletedAt,
            finishToDo: appointment.finishToDo,
          );
        }
        return appointment;
      }).toList();
      
      state = state.copyWith(
        appointments: updatedAppointments,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppointmentException ? e : AppointmentException.simple(e.toString()),
      );
    }
  }

  /// Eliminar cita
  Future<void> deleteAppointment(String appointmentId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedAppointments = state.appointments
        .where((appointment) => appointment.id != appointmentId)
        .toList();
      
      state = state.copyWith(
        appointments: updatedAppointments,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is AppointmentException ? e : AppointmentException.simple(e.toString()),
      );
    }
  }

  /// Limpiar estado
  void clear() {
    state = const AppointmentListState();
  }

  /// Método de compatibilidad para loadAppointments
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
    return getAppointments(
      idTutor: idTutor,
      idAlumno: idAlumno,
      estadoCita: estadoCita,
      fechaDesde: fechaDesde,
      fechaHasta: fechaHasta,
    );
  }

  /// Método de compatibilidad para refresh
  Future<void> refresh({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    return loadAppointments(
      idTutor: idTutor,
      idAlumno: idAlumno,
      estadoCita: estadoCita,
      fechaDesde: fechaDesde,
      fechaHasta: fechaHasta,
      refresh: true,
    );
  }

  /// Método de compatibilidad para addAppointmentToList
  void addAppointmentToList(AppointmentModel newAppointment) {
    final appointments = [newAppointment, ...state.appointments];
    state = state.copyWith(appointments: appointments);
  }
}

/// Provider para la lista de citas
final appointmentListProvider = StateNotifierProvider<AppointmentListNotifier, AppointmentListState>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentListNotifier(repository as AppointmentRepository);
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

// Provider para AppointmentService
final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final authService = ref.watch(authServiceProvider);
  
  return AppointmentService(
    baseUrl: 'https://api.rutasegura.xyz/s1',
    apiService: apiService,
    authService: authService,
  );
});

// Provider para AppointmentRepository
final appointmentRepositoryProvider = Provider<AppointmentRepositoryInterface>((ref) {
  final appointmentService = ref.watch(appointmentServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return AppointmentRepository(appointmentService, authService);
}); 

// Provider para AppointmentListNotifier
final appointmentListNotifierProvider = StateNotifierProvider<AppointmentListNotifier, AppointmentListState>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentListNotifier(repository as AppointmentRepository);
}); 