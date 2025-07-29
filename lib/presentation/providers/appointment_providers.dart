import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/use_cases/appointment_use_cases.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../core/services/appointments/appointment_service.dart';

// Provider para el repositorio de citas
final appointmentRepositoryProvider = Provider<AppointmentRepositoryImpl>((ref) {
  final appointmentService = ref.watch(appointmentServiceProvider);
  return AppointmentRepositoryImpl(appointmentService);
});

// Provider para los casos de uso de citas
final appointmentUseCasesProvider = Provider<AppointmentUseCases>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return AppointmentUseCases(repository);
});

// Provider para las citas de un tutor
final tutorAppointmentsProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getTutorAppointments(tutorId);
});

// Provider para las citas pendientes de un tutor
final pendingAppointmentsProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getPendingAppointments(tutorId);
});

// Provider para las citas de hoy de un tutor
final todayAppointmentsProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getTodayAppointments(tutorId);
});

// Provider para las estadísticas de citas de un tutor
final appointmentStatsProvider = FutureProvider.family<Map<String, int>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getAppointmentStats(tutorId);
});

// Provider para las próximas citas de un tutor
final upcomingAppointmentsProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getUpcomingAppointments(tutorId);
});

// Provider para las citas completadas del mes
final completedAppointmentsThisMonthProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, tutorId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getCompletedAppointmentsThisMonth(tutorId);
});

// Stream provider para citas en tiempo real
final tutorAppointmentsStreamProvider = StreamProvider.family<List<AppointmentEntity>, String>((ref, tutorId) {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return useCases.watchTutorAppointments(tutorId);
});

// Provider para una cita específica
final appointmentByIdProvider = FutureProvider.family<AppointmentEntity?, String>((ref, appointmentId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  return await useCases.getAppointmentById(appointmentId);
});

// Provider para acciones de citas
final appointmentActionsProvider = Provider((ref) => AppointmentActions(ref));

// Provider para la próxima cita del alumno (usuario actual)
final nextStudentAppointmentProvider = FutureProvider.family<AppointmentEntity?, String>((ref, studentId) async {
  final useCases = ref.watch(appointmentUseCasesProvider);
  final ahora = DateTime.now();
  // Traer citas pendientes
  final pendientes = await useCases.getStudentAppointmentsFiltered(
    studentId: studentId,
    estadoCita: AppointmentStatus.pending,
    fechaDesde: ahora,
    limit: 5,
  );
  // Traer citas confirmadas
  final confirmadas = await useCases.getStudentAppointmentsFiltered(
    studentId: studentId,
    estadoCita: AppointmentStatus.confirmed,
    fechaDesde: ahora,
    limit: 5,
  );
  // Combinar y ordenar
  final todas = [...pendientes, ...confirmadas];
  print('CITAS pendientes: ' + pendientes.toString());
  print('CITAS confirmadas: ' + confirmadas.toString());
  print('CITAS todas (combinadas): ' + todas.toString());
  todas.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  return todas.isNotEmpty ? todas.first : null;
});

class AppointmentActions {
  final Ref _ref;
  
  AppointmentActions(this._ref);
  
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    final useCases = _ref.read(appointmentUseCasesProvider);
    await useCases.updateAppointmentStatus(appointmentId, status);
    // Invalidar providers relacionados
    _ref.invalidate(tutorAppointmentsProvider);
    _ref.invalidate(pendingAppointmentsProvider);
    _ref.invalidate(todayAppointmentsProvider);
    _ref.invalidate(appointmentStatsProvider);
    _ref.invalidate(nextStudentAppointmentProvider);
  }
  
  Future<void> cancelAppointment(String appointmentId) async {
    final useCases = _ref.read(appointmentUseCasesProvider);
    await useCases.cancelAppointment(appointmentId);
    // Invalidar providers relacionados
    _ref.invalidate(tutorAppointmentsProvider);
    _ref.invalidate(pendingAppointmentsProvider);
    _ref.invalidate(todayAppointmentsProvider);
    _ref.invalidate(appointmentStatsProvider);
    _ref.invalidate(nextStudentAppointmentProvider);
  }
  
  Future<void> rescheduleAppointment(String appointmentId, DateTime newDate, String newTimeSlot) async {
    final useCases = _ref.read(appointmentUseCasesProvider);
    await useCases.rescheduleAppointment(appointmentId, newDate, newTimeSlot);
    // Invalidar providers relacionados
    _ref.invalidate(tutorAppointmentsProvider);
    _ref.invalidate(pendingAppointmentsProvider);
    _ref.invalidate(todayAppointmentsProvider);
    _ref.invalidate(appointmentStatsProvider);
  }
} 