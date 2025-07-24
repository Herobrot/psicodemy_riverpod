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

  AppointmentService(this._apiService);

  Future<AppointmentModel> createAppointment(CreateAppointmentRequest request) async {
    try {
      final data = await _apiService.createAppointment(request.toJson());
      final citaJson = data['data'] ?? data; // Soporta ambos casos
      return AppointmentModel.fromJson(citaJson);
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

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
      final data = await _apiService.getAppointments(
        idTutor: idTutor,
        idAlumno: idAlumno,
        estadoCita: estadoCita?.name,
        fechaDesde: fechaDesde,
        fechaHasta: fechaHasta,
        page: page,
        limit: limit,
      );
      // data ya es una lista de mapas
      return data.map<AppointmentModel>((json) => AppointmentModel.fromJson(json)).toList();
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final data = await _apiService.getAppointmentById(id);
      return AppointmentModel.fromJson(data);
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<AppointmentModel> updateAppointment(String id, UpdateAppointmentRequest request) async {
    try {
      final data = await _apiService.updateAppointment(id, request.toJson());
      return AppointmentModel.fromJson(data);
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(String id, UpdateStatusRequest request) async {
    try {
      final data = await _apiService.updateAppointmentStatus(id, request.toJson());
      return AppointmentModel.fromJson(data);
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<bool> deleteAppointment(String id) async {
    try {
      await _apiService.deleteAppointment(id);
      return true;
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<Map<String, dynamic>> healthCheck() async {
    try {
      return await _apiService.healthCheck();
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<Map<String, dynamic>> detailedHealthCheck() async {
    try {
      return await _apiService.detailedHealthCheck();
    } catch (e) {
      throw AppointmentException.simple(e.toString());
    }
  }

  Future<bool> hasScheduleConflict(
    String tutorId,
    DateTime fechaCita, {
    String? excludeAppointmentId,
  }) async {
    // Buscar citas del tutor en un rango de ±1 hora
    final fechaInicio = fechaCita.subtract(const Duration(hours: 1));
    final fechaFin = fechaCita.add(const Duration(hours: 1));
    final appointments = await getAppointments(
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
  }
} 