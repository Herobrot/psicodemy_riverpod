import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/appointment_model.dart';
import 'exceptions/appointment_exception.dart';

/// Servicio para gestionar citas
class AppointmentService {
  static const String _baseUrl = 'https://api.rutasegura.xyz/s1';
  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  AppointmentService({
    http.Client? client,
    FlutterSecureStorage? secureStorage,
  }) : _client = client ?? http.Client(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Headers básicos para todas las requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers con token de autorización
  Future<Map<String, String>> get _authHeaders async {
    final token = await _secureStorage.read(key: 'auth_token');
    return {
      ..._baseHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Crear una nueva cita
  Future<AppointmentModel> createAppointment(CreateAppointmentRequest request) async {
    try {
      final headers = await _authHeaders;
      
      print('🔄 Creando cita...');
      print('URL: $_baseUrl/appointments');
      print('Body: ${json.encode(request.toJson())}');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/appointments'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      return AppointmentModel.fromJson(result['data']);
    } catch (e) {
      print('❌ Error al crear cita: $e');
      throw _handleError(e);
    }
  }

  /// Obtener citas con filtros y paginación
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
      final headers = await _authHeaders;
      
      // Construir query parameters
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (idTutor != null) queryParams['id_tutor'] = idTutor;
      if (idAlumno != null) queryParams['id_alumno'] = idAlumno;
      if (estadoCita != null) queryParams['estado_cita'] = estadoCita.name;
      if (fechaDesde != null) queryParams['fecha_desde'] = fechaDesde.toIso8601String();
      if (fechaHasta != null) queryParams['fecha_hasta'] = fechaHasta.toIso8601String();

      final uri = Uri.parse('$_baseUrl/appointments').replace(
        queryParameters: queryParams,
      );

      print('🔍 Obteniendo citas...');
      print('URL: $uri');
      
      final response = await _client.get(uri, headers: headers);
      
      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      
      final List<dynamic> appointmentsData = result['data'];
      return appointmentsData
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error al obtener citas: $e');
      throw _handleError(e);
    }
  }

  /// Obtener una cita por ID
  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final headers = await _authHeaders;
      
      print('🔍 Obteniendo cita por ID: $id');
      
      final response = await _client.get(
        Uri.parse('$_baseUrl/appointments/$id'),
        headers: headers,
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      return AppointmentModel.fromJson(result['data']);
    } catch (e) {
      print('❌ Error al obtener cita: $e');
      throw _handleError(e);
    }
  }

  /// Actualizar una cita completa
  Future<AppointmentModel> updateAppointment(String id, UpdateAppointmentRequest request) async {
    try {
      final headers = await _authHeaders;
      
      print('🔄 Actualizando cita: $id');
      print('Body: ${json.encode(request.toJson())}');
      
      final response = await _client.put(
        Uri.parse('$_baseUrl/appointments/$id'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      return AppointmentModel.fromJson(result['data']);
    } catch (e) {
      print('❌ Error al actualizar cita: $e');
      throw _handleError(e);
    }
  }

  /// Actualizar solo el estado de una cita
  Future<AppointmentModel> updateAppointmentStatus(String id, UpdateStatusRequest request) async {
    try {
      final headers = await _authHeaders;
      
      print('🔄 Actualizando estado de cita: $id');
      print('Body: ${json.encode(request.toJson())}');
      
      final response = await _client.put(
        Uri.parse('$_baseUrl/appointments/$id/status'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      return AppointmentModel.fromJson(result['data']);
    } catch (e) {
      print('❌ Error al actualizar estado: $e');
      throw _handleError(e);
    }
  }

  /// Eliminar una cita (soft delete)
  Future<bool> deleteAppointment(String id) async {
    try {
      final headers = await _authHeaders;
      
      print('🗑️ Eliminando cita: $id');
      
      final response = await _client.delete(
        Uri.parse('$_baseUrl/appointments/$id'),
        headers: headers,
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      await _handleResponse(response);
      return true;
    } catch (e) {
      print('❌ Error al eliminar cita: $e');
      throw _handleError(e);
    }
  }

  /// Verificar el estado del servicio
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/health'),
        headers: _baseHeaders,
      );

      print('🏥 Health check: ${response.statusCode}');
      print('Body: ${response.body}');

      return await _handleResponse(response);
    } catch (e) {
      print('❌ Error en health check: $e');
      throw _handleError(e);
    }
  }

  /// Verificar el estado detallado del servicio
  Future<Map<String, dynamic>> detailedHealthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/health/detailed'),
        headers: _baseHeaders,
      );

      print('🏥 Detailed health check: ${response.statusCode}');
      print('Body: ${response.body}');

      return await _handleResponse(response);
    } catch (e) {
      print('❌ Error en detailed health check: $e');
      throw _handleError(e);
    }
  }

  /// Manejo de respuestas HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = json.decode(response.body);
    
    switch (response.statusCode) {
      case 200:
      case 201:
        if (data['status'] == 'success') {
          return data;
        } else {
          throw AppointmentException.serverError(data['message'] ?? 'Error desconocido');
        }
      case 400:
        throw AppointmentException.validationError(data['message'] ?? 'Error de validación');
      case 401:
        throw AppointmentException.unauthorized(data['message'] ?? 'No autorizado');
      case 404:
        throw AppointmentException.notFound(data['message'] ?? 'Recurso no encontrado');
      case 409:
        throw AppointmentException.conflictError(data['message'] ?? 'Conflicto de horario');
      case 429:
        throw AppointmentException.rateLimitExceeded(data['message'] ?? 'Demasiadas peticiones');
      case 500:
        throw AppointmentException.serverError(data['message'] ?? 'Error interno del servidor');
      default:
        throw AppointmentException.serverError(
          'Error HTTP ${response.statusCode}: ${data['message'] ?? 'Error desconocido'}',
        );
    }
  }

  /// Manejo de errores
  AppointmentException _handleError(dynamic error) {
    if (error is AppointmentException) {
      return error;
    } else if (error is SocketException) {
      return AppointmentException.networkError('Sin conexión a internet');
    } else if (error is FormatException) {
      return AppointmentException.unknown('Error al procesar la respuesta');
    } else {
      return AppointmentException.unknown(error.toString());
    }
  }

  /// Cerrar el cliente HTTP
  void dispose() {
    _client.close();
  }
} 