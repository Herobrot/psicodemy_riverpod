import '../models/appointment_model.dart';

/// Interfaz para el repositorio de citas
abstract class AppointmentRepositoryInterface {
  /// Crear una nueva cita
  Future<AppointmentModel> createAppointment(CreateAppointmentRequest request);

  /// Obtener todas las citas con filtros opcionales
  Future<List<AppointmentModel>> getAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  });

  /// Obtener una cita específica por ID
  Future<AppointmentModel> getAppointmentById(String id);

  /// Obtener citas del tutor actual
  Future<List<AppointmentModel>> getMyAppointmentsAsTutor({
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  });

  /// Obtener citas del alumno actual
  Future<List<AppointmentModel>> getMyAppointmentsAsStudent({
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  });

  /// Obtener citas por estado
  Future<List<AppointmentModel>> getAppointmentsByStatus(
    EstadoCita estado, {
    int page = 1,
    int limit = 10,
  });

  /// Obtener citas para una fecha específica
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime fecha, {
    int page = 1,
    int limit = 10,
  });

  /// Obtener citas en un rango de fechas
  Future<List<AppointmentModel>> getAppointmentsByDateRange(
    DateTime fechaInicio,
    DateTime fechaFin, {
    int page = 1,
    int limit = 10,
  });

  /// Actualizar una cita completa
  Future<AppointmentModel> updateAppointment(String id, UpdateAppointmentRequest request);

  /// Actualizar solo el estado de una cita
  Future<AppointmentModel> updateAppointmentStatus(String id, EstadoCita estado);

  /// Confirmar una cita
  Future<AppointmentModel> confirmAppointment(String id);

  /// Cancelar una cita
  Future<AppointmentModel> cancelAppointment(String id);

  /// Completar una cita
  Future<AppointmentModel> completeAppointment(String id, {String? finishToDo});

  /// Marcar como no asistida
  Future<AppointmentModel> markAsNoShow(String id);

  /// Eliminar una cita (soft delete)
  Future<bool> deleteAppointment(String id);

  /// Verificar si hay conflictos de horario
  Future<bool> hasScheduleConflict(
    String tutorId,
    DateTime fechaCita, {
    String? excludeAppointmentId,
  });

  /// Obtener el próximo horario disponible
  Future<DateTime?> getNextAvailableSlot(
    String tutorId,
    DateTime fechaPreferida,
  );

  /// Obtener estadísticas de citas
  Future<Map<String, dynamic>> getAppointmentStats({
    String? tutorId,
    String? alumnoId,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  });

  /// Verificar el estado del servicio
  Future<bool> isServiceHealthy();

  /// Obtener información detallada del servicio
  Future<Map<String, dynamic>> getServiceHealth();
} 