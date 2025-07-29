import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_service.dart';
import 'models/appointment_model.dart';
import 'exceptions/appointment_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service_provider.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AppointmentService(apiService);
});

class AppointmentService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AppointmentService(this._apiService);

  Future<AppointmentModel> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    try {
      final data = await _apiService.createAppointment(request.toJson());
      final citaJson = data['data'] ?? data;
      return AppointmentModel.fromJson(citaJson);
    } catch (_) {
      throw AppointmentException.simple('Error al crear la cita');
    }
  }

  Future<String?> _getCurrentUserTutorId() async {
    try {
      final completeUserData = await _secureStorage.read(
        key: 'complete_user_data',
      );

      if (completeUserData != null) {
        final userJson = json.decode(completeUserData);        
        final userId = userJson['userId'] as String?;
        final tipoUsuario = userJson['tipoUsuario'] as String?;                
        if (userId != null && tipoUsuario?.toLowerCase() == 'tutor') {          
          return userId;
        }
        return userId;
      }
      
      return null;
    } catch (_) {      
      return null;
    }
  }

  Future<List<AppointmentModel>> getAppointments({
    String? idTutor,
    String? idAlumno,
    EstadoCita? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final data = await _apiService.getAppointments(
        idTutor: await _getCurrentUserTutorId(),
        idAlumno: idAlumno,
        estadoCita: estadoCita?.name,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
      return data
          .map<AppointmentModel>((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (_) {
      throw AppointmentException.simple('Error al actualizar la cita');
    }
  }

  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final data = await _apiService.getAppointmentById(id);
      return AppointmentModel.fromJson(data);
    } catch (_) {
      throw AppointmentException.simple('Error al actualizar el estado de la cita');
    }
  }

  Future<AppointmentModel> updateAppointment(
    String id,
    UpdateAppointmentRequest request,
  ) async {
    try {
      final data = await _apiService.updateAppointment(id, request.toJson());
      return AppointmentModel.fromJson(data);
    } catch (_) {
      throw AppointmentException.simple('Error al actualizar la cita');
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(
    String id,
    UpdateStatusRequest request,
  ) async {
    try {
      final data = await _apiService.updateAppointmentStatus(
        id,
        request.toJson(),
      );
      return AppointmentModel.fromJson(data);
    } catch (_) {
      throw AppointmentException.simple('Error al actualizar el estado de la cita');
    }
  }

  Future<bool> deleteAppointment(String id) async {
    try {
      await _apiService.deleteAppointment(id);
      return true;
    } catch (_) {
      throw AppointmentException.simple('Error al eliminar la cita');
    }
  }

  Future<Map<String, dynamic>> healthCheck() async {
    try {
      return await _apiService.healthCheck();
    } catch (_) {
      throw AppointmentException.simple('Error de salud');
    }
  }

  Future<Map<String, dynamic>> detailedHealthCheck() async {
    try {
      return await _apiService.detailedHealthCheck();
    } catch (_) {
      throw AppointmentException.simple('Error de salud detallado');
    }
  }

  Future<bool> hasScheduleConflict(
    String tutorId,
    DateTime fechaCita, {
    String? excludeAppointmentId,
  }) async {
    final fechaInicio = fechaCita.subtract(const Duration(hours: 1));
    final fechaFin = fechaCita.add(const Duration(hours: 1));
    final appointments = await getAppointments(
      idTutor: tutorId,
      fechaDesde: fechaInicio,
      fechaHasta: fechaFin,
      estadoCita: EstadoCita.confirmada,
      limit: 100,
    );

    final activeAppointments = appointments.where((appointment) {
      if (excludeAppointmentId != null &&
          appointment.id == excludeAppointmentId) {
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
  }
}
