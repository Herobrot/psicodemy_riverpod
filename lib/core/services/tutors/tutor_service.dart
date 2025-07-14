import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/tutor_model.dart';
import 'exceptions/tutor_exception.dart';

/// Servicio para gestionar tutores
class TutorService {
  static const String _baseUrl = 'https://api.rutasegura.xyz/s1';
  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  TutorService({
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

  /// Obtener la lista de tutores
  Future<List<TutorModel>> getTutors() async {
    try {
      final headers = await _authHeaders;
      
      print('🔍 Obteniendo tutores...');
      print('URL: https://api.rutasegura.xyz/auth/users/tutor');
      
      final response = await _client.get(
        Uri.parse('https://api.rutasegura.xyz/auth/auth/users/tutor'),
        headers: headers,
      );

      print('📡 Respuesta: ${response.statusCode}');
      print('Body: ${response.body}');

      final result = await _handleResponse(response);
      
      if (result['data'] == null) {
        throw TutorException.emptyResponse('No se recibieron datos de tutores');
      }

      final tutorListResponse = TutorListResponse.fromJson(result);
      
      if (!tutorListResponse.isSuccess) {
        throw TutorException.serverError(tutorListResponse.message);
      }

      return tutorListResponse.tutores;
    } catch (e) {
      print('❌ Error al obtener tutores: $e');
      throw _handleError(e);
    }
  }

  /// Obtener información específica de un tutor por ID
  Future<TutorModel?> getTutorById(String id) async {
    try {
      final tutors = await getTutors();
      
      // Buscar tutor por ID
      final tutor = tutors.where((t) => t.id == id).firstOrNull;
      
      if (tutor == null) {
        throw TutorException.notFound('No se encontró un tutor con el ID: $id');
      }

      return tutor;
    } catch (e) {
      print('❌ Error al obtener tutor por ID: $e');
      throw _handleError(e);
    }
  }

  /// Obtener información específica de un tutor por email
  Future<TutorModel?> getTutorByEmail(String email) async {
    try {
      final tutors = await getTutors();
      
      // Buscar tutor por email
      final tutor = tutors.where((t) => t.correo == email).firstOrNull;
      
      if (tutor == null) {
        throw TutorException.notFound('No se encontró un tutor con el email: $email');
      }

      return tutor;
    } catch (e) {
      print('❌ Error al obtener tutor por email: $e');
      throw _handleError(e);
    }
  }

  /// Buscar tutores por nombre
  Future<List<TutorModel>> searchTutorsByName(String name) async {
    try {
      final tutors = await getTutors();
      
      // Filtrar tutores por nombre (case insensitive)
      final filteredTutors = tutors.where((tutor) =>
          tutor.nombre.toLowerCase().contains(name.toLowerCase())
      ).toList();

      return filteredTutors;
    } catch (e) {
      print('❌ Error al buscar tutores por nombre: $e');
      throw _handleError(e);
    }
  }

  /// Obtener el total de tutores
  Future<int> getTutorCount() async {
    try {
      final tutors = await getTutors();
      return tutors.length;
    } catch (e) {
      print('❌ Error al obtener el total de tutores: $e');
      throw _handleError(e);
    }
  }

  /// Verificar si un email pertenece a un tutor
  Future<bool> isEmailTutor(String email) async {
    try {
      final tutor = await getTutorByEmail(email);
      return tutor != null;
    } catch (e) {
      // Si no se encuentra el tutor, retornamos false
      return false;
    }
  }

  /// Manejo de respuestas HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      final Map<String, dynamic> data = json.decode(response.body);
      
      switch (response.statusCode) {
        case 200:
          if (data['status'] == 'success') {
            return data;
          } else {
            throw TutorException.serverError(data['message'] ?? 'Error desconocido');
          }
        case 400:
          throw TutorException.serverError(data['message'] ?? 'Solicitud inválida');
        case 401:
          throw TutorException.unauthorized(data['message'] ?? 'No autorizado');
        case 404:
          throw TutorException.notFound(data['message'] ?? 'Tutores no encontrados');
        case 500:
          throw TutorException.serverError(data['message'] ?? 'Error interno del servidor');
        default:
          throw TutorException.serverError(
            'Error HTTP ${response.statusCode}: ${data['message'] ?? 'Error desconocido'}',
          );
      }
    } catch (e) {
      if (e is TutorException) {
        rethrow;
      } else {
        throw TutorException.parseError('Error al procesar la respuesta: $e');
      }
    }
  }

  /// Manejo de errores
  TutorException _handleError(dynamic error) {
    if (error is TutorException) {
      return error;
    } else if (error is SocketException) {
      return TutorException.networkError('Sin conexión a internet');
    } else if (error is FormatException) {
      return TutorException.parseError('Error al procesar la respuesta');
    } else {
      return TutorException.unknown(error.toString());
    }
  }

  /// Cerrar el cliente HTTP
  void dispose() {
    _client.close();
  }
}

/// Extensión para obtener el primer elemento o null
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
} 