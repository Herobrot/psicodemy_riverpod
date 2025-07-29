import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  // Obtener todas las citas de un tutor
  Future<List<AppointmentEntity>> getTutorAppointments(String tutorId);

  // Obtener citas pendientes de un tutor
  Future<List<AppointmentEntity>> getPendingAppointments(String tutorId);

  // Obtener citas de hoy de un tutor
  Future<List<AppointmentEntity>> getTodayAppointments(String tutorId);

  // Obtener una cita específica
  Future<AppointmentEntity?> getAppointmentById(String appointmentId);

  // Crear una nueva cita
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment);

  // Actualizar el estado de una cita
  Future<AppointmentEntity> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );

  // Cancelar una cita
  Future<void> cancelAppointment(String appointmentId);

  // Reprogramar una cita
  Future<AppointmentEntity> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  );

  // Obtener estadísticas de citas
  Future<Map<String, int>> getAppointmentStats(String tutorId);

  // Stream de citas en tiempo real
  Stream<List<AppointmentEntity>> watchTutorAppointments(String tutorId);

  // Obtener todas las citas de un alumno
  Future<List<AppointmentEntity>> getStudentAppointments(String studentId);

  // Obtener citas de un alumno con filtros
  Future<List<AppointmentEntity>> getStudentAppointmentsFiltered({
    required String studentId,
    required AppointmentStatus estadoCita,
    required DateTime fechaDesde,
    int limit = 10,
  });
}
