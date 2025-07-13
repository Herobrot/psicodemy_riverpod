import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth/exceptions/auth_failure.dart';
import '../types/tipo_usuario.dart';

class ApiService {
  static const String _baseUrl = 'https://api.rutasegura.xyz/auth';
  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  ApiService({
    http.Client? client,
    FlutterSecureStorage? secureStorage,
  }) : _client = client ?? http.Client(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Headers básicos para todas las requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers con token de autorización
  Future<Map<String, String>> get _authHeaders async {
    final token = await _secureStorage.read(key: 'auth_token');
    return {
      ..._baseHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Endpoint para validar código de institución
  Future<bool> validateTutorCode(String codigo) async {
    try {
      // Según la nueva API, solo "TUTOR" es válido para ser tutor
      return codigo.toUpperCase() == 'TUTOR';
    } catch (e) {
      // En caso de error, por seguridad, no otorgamos permisos de tutor
      return false;
    }
  }

  // Endpoint para autenticación con Firebase
  Future<Map<String, dynamic>> authenticateWithFirebase({
    required String firebaseToken,
    required String nombre,
    required String correo,
    String? codigoTutor,
  }) async {
    try {
      final requestBody = {
        'firebase_token': firebaseToken,
        'nombre': nombre,
        'correo': correo,
        if (codigoTutor != null && codigoTutor.isNotEmpty) 'codigo_institucion': codigoTutor,
      };

      // 🔍 DEBUG: Imprimir datos de la petición
      print('🌐 API REQUEST to $_baseUrl/auth/firebase:');
      print('Headers: $_baseHeaders');
      print('Body: ${json.encode(requestBody)}');
      print('Token (first 50 chars): ${firebaseToken.substring(0, firebaseToken.length > 50 ? 50 : firebaseToken.length)}...');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/firebase'),
        headers: _baseHeaders,
        body: json.encode(requestBody),
      );

      // 🔍 DEBUG: Imprimir respuesta del servidor
      print('📡 API RESPONSE:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('---');

      return await _handleResponse(response);
    } catch (e) {
      print('❌ API ERROR: $e');
      throw _handleError(e);
    }
  }

  // Endpoint para autenticación tradicional
  Future<Map<String, dynamic>> authenticateWithCredentials({
    required String correo,
    required String password,
    String? codigoTutor,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/validate'),
        headers: _baseHeaders,
        body: json.encode({
          'correo': correo,
          'contraseña': password,
          if (codigoTutor != null && codigoTutor.isNotEmpty) 'codigo_institucion': codigoTutor,
        }),
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint para obtener perfil del usuario
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint para recursos exclusivos de tutor
  Future<Map<String, dynamic>> getTutorOnlyResource() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/tutor-only'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint para recursos exclusivos de alumno
  Future<Map<String, dynamic>> getStudentOnlyResource() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/student-only'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Health check del servicio
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/health'),
        headers: _baseHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Manejo de respuestas HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    // Verificar si la respuesta está vacía
    if (response.body.isEmpty) {
      throw const AuthFailure.unknown('Respuesta vacía del servidor');
    }

    final Map<String, dynamic> responseData;
    
    try {
      final decoded = json.decode(response.body);
      if (decoded == null) {
        throw const AuthFailure.unknown('El servidor retornó null');
      }
      responseData = decoded as Map<String, dynamic>;
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure.unknown('Respuesta inválida del servidor: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        // Si hay token en la respuesta, lo guardamos
        if (responseData['token'] != null) {
          await _secureStorage.write(key: 'auth_token', value: responseData['token']);
        }
        return responseData;
      
      case 400:
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Datos de entrada inválidos'
        );
      
      case 401:
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Token de autorización requerido o inválido'
        );
      
      case 403:
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Permisos insuficientes'
        );
      
      case 404:
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Recurso no encontrado'
        );
      
      case 422:
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Datos de entrada inválidos'
        );
      
      case 500:
        throw AuthFailure.serverError(
          responseData['message'] ?? 'Error interno del servidor'
        );
      
      default:
        throw AuthFailure.unknown(
          'Error HTTP ${response.statusCode}: ${responseData['message'] ?? 'Error desconocido'}'
        );
    }
  }

  // Manejo de errores
  AuthFailure _handleError(dynamic error) {
    if (error is AuthFailure) return error;
    
    if (error is SocketException) {
      return const AuthFailure.network('Error de conexión a internet');
    }
    
    if (error is http.ClientException) {
      return const AuthFailure.network('Error de red');
    }
    
    return AuthFailure.unknown(error.toString());
  }

  // Limpieza de recursos
  void dispose() {
    _client.close();
  }
} 