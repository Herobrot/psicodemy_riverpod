import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository_interface.dart';

class AppointmentUseCases {
  final AppointmentRepository _appointmentRepository;

  AppointmentUseCases(this._appointmentRepository);

  // Obtener todas las citas de un tutor
  Future<List<AppointmentEntity>> getTutorAppointments(String tutorId) async {
    return await _appointmentRepository.getTutorAppointments(tutorId);
  }

  // Obtener citas pendientes de un tutor
  Future<List<AppointmentEntity>> getPendingAppointments(String tutorId) async {
    return await _appointmentRepository.getPendingAppointments(tutorId);
  }

  // Obtener citas de hoy de un tutor
  Future<List<AppointmentEntity>> getTodayAppointments(String tutorId) async {
    return await _appointmentRepository.getTodayAppointments(tutorId);
  }

  // Obtener una cita específica
  Future<AppointmentEntity?> getAppointmentById(String appointmentId) async {
    return await _appointmentRepository.getAppointmentById(appointmentId);
  }

  // Crear una nueva cita
  Future<AppointmentEntity> createAppointment(
    AppointmentEntity appointment,
  ) async {
    return await _appointmentRepository.createAppointment(appointment);
  }

  // Actualizar el estado de una cita
  Future<AppointmentEntity> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    return await _appointmentRepository.updateAppointmentStatus(
      appointmentId,
      status,
    );
  }

  // Cancelar una cita
  Future<void> cancelAppointment(String appointmentId) async {
    await _appointmentRepository.cancelAppointment(appointmentId);
  }

  // Reprogramar una cita
  Future<AppointmentEntity> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  ) async {
    return await _appointmentRepository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTimeSlot,
    );
  }

  // Obtener estadísticas de citas
  Future<Map<String, int>> getAppointmentStats(String tutorId) async {
    return await _appointmentRepository.getAppointmentStats(tutorId);
  }

  // Stream de citas en tiempo real
  Stream<List<AppointmentEntity>> watchTutorAppointments(String tutorId) {
    return _appointmentRepository.watchTutorAppointments(tutorId);
  }

  // Obtener todas las citas de un alumno
  Future<List<AppointmentEntity>> getStudentAppointments(
    String studentId,
  ) async {
    return await _appointmentRepository.getStudentAppointments(studentId);
  }

  // Obtener citas de un alumno con filtros
  Future<List<AppointmentEntity>> getStudentAppointmentsFiltered({
    required String studentId,
    required AppointmentStatus estadoCita,
    required DateTime fechaDesde,
    int limit = 10,
  }) async {
    return await _appointmentRepository.getStudentAppointmentsFiltered(
      studentId: studentId,
      estadoCita: estadoCita,
      fechaDesde: fechaDesde,
      limit: limit,
    );
  }

  // Casos de uso específicos para la UI

  // Obtener citas agrupadas por fecha
  Future<Map<String, List<AppointmentEntity>>> getAppointmentsGroupedByDate(
    String tutorId,
  ) async {
    final appointments = await getTutorAppointments(tutorId);
    final grouped = <String, List<AppointmentEntity>>{};

    for (final appointment in appointments) {
      final dateKey =
          '${appointment.scheduledDate.year}-${appointment.scheduledDate.month.toString().padLeft(2, '0')}-${appointment.scheduledDate.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(dateKey, () => []).add(appointment);
    }

    return grouped;
  }

  // Obtener próximas citas (próximos 7 días)
  Future<List<AppointmentEntity>> getUpcomingAppointments(
    String tutorId,
  ) async {
    final appointments = await getTutorAppointments(tutorId);
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));

    return appointments.where((appointment) {
      return appointment.scheduledDate.isAfter(now) &&
          appointment.scheduledDate.isBefore(weekFromNow) &&
          appointment.status != AppointmentStatus.cancelled;
    }).toList()..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  // Obtener citas completadas del mes
  Future<List<AppointmentEntity>> getCompletedAppointmentsThisMonth(
    String tutorId,
  ) async {
    final appointments = await getTutorAppointments(tutorId);
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.completed &&
          appointment.scheduledDate.isAfter(startOfMonth);
    }).toList()..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }
}
