import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../appointment_service.dart';
import '../models/appointment_model.dart';
import '../exceptions/appointment_exception.dart';
import 'appointment_repository_interface.dart';
import '../../auth/auth_service.dart';
import '../../auth/models/complete_user_model.dart';

/// Implementación del repositorio de citas
class AppointmentRepository implements AppointmentRepositoryInterface {
  final AppointmentService _appointmentService;
  final AuthService _authService;

  AppointmentRepository(this._appointmentService, this._authService);

  @override
  Future<AppointmentModel> createAppointment(CreateAppointmentRequest request) async {
    try {
      return await _appointmentService.createAppointment(request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _appointmentService.getAppointments(
        idTutor: idTutor,
        idAlumno: idAlumno,
        estadoCita: estadoCita,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      return await _appointmentService.getAppointmentById(id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getMyAppointmentsAsTutor({
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        throw AppointmentException.unauthorized('Usuario no autenticado');
      }

      return await _appointmentService.getAppointments(
        idTutor: user.userId,
        estadoCita: estadoCita,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getMyAppointmentsAsStudent({
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        throw AppointmentException.unauthorized('Usuario no autenticado');
      }

      return await _appointmentService.getAppointments(
        idAlumno: user.userId,
        estadoCita: estadoCita,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByStatus(
    EstadoCita estado, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _appointmentService.getAppointments(
        estadoCita: estado,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime fecha, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final fechaInicio = DateTime(fecha.year, fecha.month, fecha.day);
      final fechaFin = fechaInicio.add(const Duration(days: 1));

      return await _appointmentService.getAppointments(
        fechaDesde: fechaInicio,
        fechaHasta: fechaFin,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDateRange(
    DateTime fechaInicio,
    DateTime fechaFin, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _appointmentService.getAppointments(
        fechaDesde: fechaInicio,
        fechaHasta: fechaFin,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AppointmentModel> updateAppointment(String id, UpdateAppointmentRequest request) async {
    try {
      return await _appointmentService.updateAppointment(id, request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(String id, EstadoCita estado) async {
    try {
      final request = UpdateStatusRequest(estadoCita: estado);
      return await _appointmentService.updateAppointmentStatus(id, request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AppointmentModel> confirmAppointment(String id) async {
    return await updateAppointmentStatus(id, EstadoCita.confirmada);
  }

  @override
  Future<AppointmentModel> cancelAppointment(String id) async {
    return await updateAppointmentStatus(id, EstadoCita.cancelada);
  }

  @override
  Future<AppointmentModel> completeAppointment(String id, {String? finishToDo}) async {
    try {
      final request = UpdateAppointmentRequest(
        estadoCita: EstadoCita.completada,
        finishToDo: finishToDo,
      );
      return await _appointmentService.updateAppointment(id, request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AppointmentModel> markAsNoShow(String id) async {
    return await updateAppointmentStatus(id, EstadoCita.no_asistio);
  }

  @override
  Future<bool> deleteAppointment(String id) async {
    try {
      return await _appointmentService.deleteAppointment(id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> hasScheduleConflict(
    String tutorId,
    DateTime fechaCita, {
    String? excludeAppointmentId,
  }) async {
    try {
      // Buscar citas del tutor en un rango de ±1 hora
      final fechaInicio = fechaCita.subtract(const Duration(hours: 1));
      final fechaFin = fechaCita.add(const Duration(hours: 1));
      
      final appointments = await _appointmentService.getAppointments(
        idTutor: tutorId,
        fechaDesde: fechaInicio,
        fechaHasta: fechaFin,
        estadoCita: EstadoCita.confirmada,
        limit: 100,
      );

      // Filtrar citas que no estén canceladas y no sea la cita a excluir
      final activeAppointments = appointments.where((appointment) {
        if (excludeAppointmentId != null && appointment.id == excludeAppointmentId) {
          return false;
        }
        return appointment.estadoCita != EstadoCita.cancelada;
      }).toList();

      // Verificar si hay solapamiento de horarios
      for (final appointment in activeAppointments) {
        final difference = appointment.fechaCita.difference(fechaCita).abs();
        if (difference.inMinutes < 60) {
          return true;
        }
      }

      return false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<DateTime?> getNextAvailableSlot(
    String tutorId,
    DateTime fechaPreferida,
  ) async {
    try {
      DateTime fechaActual = fechaPreferida;
      
      // Buscar en los próximos 30 días
      for (int i = 0; i < 30; i++) {
        // Verificar horarios típicos de trabajo (9 AM - 6 PM)
        for (int hora = 9; hora < 18; hora++) {
          final fechaTest = DateTime(
            fechaActual.year,
            fechaActual.month,
            fechaActual.day,
            hora,
          );
          
          final hasConflict = await hasScheduleConflict(tutorId, fechaTest);
          if (!hasConflict) {
            return fechaTest;
          }
        }
        
        fechaActual = fechaActual.add(const Duration(days: 1));
      }

      return null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getAppointmentStats({
    String? tutorId,
    String? alumnoId,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    try {
      final appointments = await _appointmentService.getAppointments(
        idTutor: tutorId,
        idAlumno: alumnoId,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        limit: 1000,
      );

      final stats = <String, dynamic>{};
      
      // Estadísticas generales
      stats['total'] = appointments.length;
      
      // Estadísticas por estado
      for (final estado in EstadoCita.values) {
        final count = appointments.where((a) => a.estadoCita == estado).length;
        stats[estado.name] = count;
      }
      
      // Porcentajes
      if (appointments.isNotEmpty) {
        for (final estado in EstadoCita.values) {
          final percentage = (stats[estado.name] as int) / appointments.length * 100;
          stats['${estado.name}_percentage'] = percentage.toStringAsFixed(1);
        }
      }

      return stats;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> isServiceHealthy() async {
    try {
      await _appointmentService.healthCheck();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getServiceHealth() async {
    try {
      return await _appointmentService.detailedHealthCheck();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Manejo de errores
  AppointmentException _handleError(dynamic error) {
    if (error is AppointmentException) {
      return error;
    } else {
      return AppointmentException.unknown(error.toString());
    }
  }
}

/// Provider para el repositorio de citas
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final appointmentService = ref.watch(appointmentServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return AppointmentRepository(appointmentService, authService);
});

/// Provider para el servicio de citas
final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService();
}); 