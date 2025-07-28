import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/exceptions/auth_failure.dart';
import '../constants/api_routes.dart';
import '../constants/timeout_config.dart';
import '../constants/enums/tipo_usuario.dart';
import 'appointments/models/appointment_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.psicodemy.com';
  static const Duration _timeout = TimeoutConfig.apiCall;
  
  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  ApiService({
    http.Client? client,
    required FlutterSecureStorage secureStorage,
  }) : _client = client ?? http.Client(),
       _secureStorage = secureStorage;

  // Headers básicos para todas las requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers con token de autorización (siempre token de Firebase y userID de la API)
  Future<Map<String, String>> get _authHeaders async {
    // Obtener token de Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ No hay usuario de Firebase logueado');
      throw AuthFailure.apiError('Usuario no autenticado');
    }
    final firebaseToken = await user.getIdToken();
    if (firebaseToken == null) {
      throw AuthFailure.apiError('No se pudo obtener el token de Firebase');
    }
    // Obtener el userId del tutor desde el storage
    final tutorId = await _getCurrentUserTutorId();
    if (tutorId == null) {
      print('❌ No se pudo obtener el userId del tutor para el header');
      throw AuthFailure.apiError('No se pudo obtener el userId del tutor');
    }
    return {
      ..._baseHeaders,
      'Authorization': 'Bearer $firebaseToken',
      'userID': tutorId,
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

      // 🔍 DEBUG: Imprimir datos de la petición /auth/firebase:
      print('🌐 API REQUEST to $_baseUrl${ApiRoutes.authFirebase}');
      print('Headers: $_baseHeaders');
      print('Body: ${json.encode(requestBody)}');
      print('Token (first 50 chars): ${firebaseToken.substring(0, firebaseToken.length > 50 ? 50 : firebaseToken.length)}...');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl${ApiRoutes.authFirebase}'),
        headers: _baseHeaders,
        body: json.encode(requestBody),
      ).timeout(_timeout);

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
      print('🌐 ApiService: Iniciando autenticación con credenciales');
      print('📧 Correo: $correo');
      print('🔑 Código tutor: $codigoTutor');
      
      final requestBody = {
        'correo': correo,
        'contraseña': password,
        if (codigoTutor != null && codigoTutor.isNotEmpty) 'codigo_institucion': codigoTutor,
      };
      
      // 🔍 DEBUG: Imprimir datos de la petición /auth/validate:
      print('📤 ApiService: Enviando petición a $_baseUrl${ApiRoutes.authValidate}');
      print('📤 Request body: ${json.encode(requestBody)}');
      
      final response = await _client.post(
        Uri.parse('$_baseUrl${ApiRoutes.authValidate}'),
        headers: _baseHeaders,
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('📡 ApiService: Respuesta recibida');
      print('📡 Status code: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      return await _handleResponse(response);
    } catch (e) {
      print('❌ ApiService: Error en authenticateWithCredentials');
      print('❌ Error tipo: ${e.runtimeType}');
      print('❌ Error mensaje: $e');
      throw _handleError(e);
    }
  }

  // Endpoint para obtener perfil del usuario
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl${ApiRoutes.authProfileUser(userId)}'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Endpoint para obtener lista de usuarios
  Future<Map<String, dynamic>> getUsersList({
    int page = 1,
    int limit = 100,
    String? userType,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (userType != null) 'userType': userType,
      };

      final uri = Uri.parse('$_baseUrl/auth/users')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
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
        Uri.parse('$_baseUrl${ApiRoutes.authHealth}'),
        headers: _baseHeaders,
      );

      final responseS1 = await _client.get(
        Uri.parse('$_baseUrl${ApiRoutes.healthS1}'),
        headers: _baseHeaders,
      );

      return {
        'auth': await _handleResponse(response),
        's1': await _handleResponse(responseS1),
      };
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Crear una nueva cita
  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl${ApiRoutes.baseAppointments}'),
        headers: await _authHeaders,
        body: json.encode(request),
      );
      final data = await _handleResponse(response);
      return data['data']; // SOLO data['data']
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener citas con filtros y paginación
  Future<List<dynamic>> getAppointments({
    String? idTutor,
    String? idAlumno,
    String? estadoCita,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
            // Obtener datos del usuario autenticado para verificar si es tutor
      final completeUserData = await _secureStorage.read(key: 'complete_user_data');
      String? tutorId;
      String? alumnoId;
      String? userId;
      
      if (completeUserData != null) {
        final userJson = json.decode(completeUserData);
        final tipoUsuario = userJson['tipoUsuario'] as String?;
        userId = userJson['userId'] as String?;
        // Solo agregar id_tutor si el usuario es tutor
        if (tipoUsuario?.toLowerCase() == 'tutor') {
          queryParams['id_tutor'] = userId ?? idTutor ?? '';
        }
        else {
          if (idAlumno != null) {
            queryParams['id_alumno'] = userId ?? idAlumno ?? '';
          }
        }
      }
      
      // Si no se agregó id_alumno en el bloque anterior y se proporciona idAlumno, agregarlo
      if (!queryParams.containsKey('id_alumno') && idAlumno != null) {
        queryParams['id_alumno'] = idAlumno;
      }
      if (estadoCita != null) queryParams['estado_cita'] = estadoCita;


      final uri = Uri.parse('$_baseUrl${ApiRoutes.baseAppointments}').replace(queryParameters: queryParams);
      print('uri de citas: $uri');
      final response = await _client.get(uri, headers: await _authHeaders);
      final data = await _handleResponse(response);
      print('data de citas recibida: $data');
      if (data['data'] is Map && data['data']['data'] is List) {
        return data['data']['data'] as List<dynamic>;
      } else if (data['data'] is List) {
        return data['data'] as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener una cita por ID
  Future<Map<String, dynamic>> getAppointmentById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl${ApiRoutes.appointmentId(id)}'),
        headers: await _authHeaders,
      );
      final data = await _handleResponse(response);
      return data['data']; // SOLO data['data']
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Actualizar una cita completa
  Future<Map<String, dynamic>> updateAppointment(String id, Map<String, dynamic> request) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl${ApiRoutes.appointmentId(id)}'),
        headers: await _authHeaders,
        body: json.encode(request),
      );
      final data = await _handleResponse(response);
      
      // La API devuelve directamente el objeto de la cita, no envuelto en 'data'
      // Verificar si está envuelto en 'data' o es directo
      if (data.containsKey('data')) {
        return data['data'] as Map<String, dynamic>;
      } else {
        // Si no tiene 'data', asumir que es la respuesta directa
        return data;
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Actualizar solo el estado de una cita
  Future<Map<String, dynamic>> updateAppointmentStatus(String id, Map<String, dynamic> request) async {
    try {
      final headers = await _authHeaders;
      
      // 🔄 Obtener ID del tutor del usuario autenticado
      final tutorId = await _getCurrentUserTutorId();
      
      // Agregar ID del tutor a la request si no está presente o es null
      final enrichedRequest = {
        ...request,
        'userId': tutorId,
      };
      
      // 🔄 DEBUG: Información esencial de la request
      print('🔄 Actualizando estado de cita:');
      print('   Appointment ID: $id');
      print('   Tutor ID: $tutorId');
      print('   Has Auth Token: ${headers.containsKey('Authorization')}');
      print('   Request: ${json.encode(enrichedRequest)}');
      
      final response = await _client.put(
        Uri.parse('$_baseUrl${ApiRoutes.appointmentId(id)}'),
        headers: headers,
        body: json.encode(enrichedRequest),
      );
      final data = await _handleResponse(response);
      
      // La API devuelve directamente el objeto de la cita, no envuelto en 'data'
      // Verificar si está envuelto en 'data' o es directo
      if (data.containsKey('data')) {
        return data['data'] as Map<String, dynamic>;
      } else {
        // Si no tiene 'data', asumir que es la respuesta directa
        return data;
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Eliminar una cita (soft delete)
  Future<void> deleteAppointment(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl${ApiRoutes.appointmentId(id)}'),
        headers: await _authHeaders,
      );
      await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Verificar el estado detallado del servicio
  Future<Map<String, dynamic>> detailedHealthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/health/detailed'),
        headers: _baseHeaders,
      );
      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Manejo de respuestas HTTP
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    print('🔍 ApiService: Procesando respuesta HTTP');
    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body length: ${response.body.length}');
    print('🔍 Response body: ${response.body}');
    
    // Verificar si la respuesta está vacía
    if (response.body.isEmpty) {
      print('❌ ApiService: Respuesta vacía del servidor');
      throw AuthFailure.unknown('Respuesta vacía del servidor');
    }

    final Map<String, dynamic> responseData;
    
    try {
      print('🔍 ApiService: Intentando decodificar JSON');
      final decoded = json.decode(response.body);
      print('🔍 [DEBUG] Objeto crudo recibido de la API:');
      print(decoded);
      if (decoded == null) {
        print('❌ ApiService: El servidor retornó null');
        throw AuthFailure.unknown('El servidor retornó null');
      }
      responseData = decoded as Map<String, dynamic>;
      print('✅ ApiService: JSON decodificado exitosamente');
      print('🔍 Response data keys: ${responseData.keys.toList()}');
    } catch (e) {
      print('❌ ApiService: Error decodificando JSON: $e');
      if (e is AuthFailure) rethrow;
      throw AuthFailure.unknown('Respuesta inválida del servidor: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        print('✅ ApiService: Respuesta exitosa (${response.statusCode})');
        // Si hay token en la respuesta, lo guardamos
        if (responseData['token'] != null) {
          print('🔑 ApiService: Guardando token de autenticación');
          await _secureStorage.write(key: 'auth_token', value: responseData['token']);
        }
        // Normalizar data['data'] si está anidado
        if (responseData['data'] is Map && responseData['data']['data'] != null) {
          responseData['data'] = responseData['data']['data'];
        }
        return responseData;
      
      case 400:
        print('❌ ApiService: Error 400 - Datos de entrada inválidos');
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Datos de entrada inválidos'
        );
      
      case 401:
        print('❌ ApiService: Error 401 - No autorizado');
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Token de autorización requerido o inválido'
        );
      
      case 403:
        print('❌ ApiService: Error 403 - Permisos insuficientes');
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Permisos insuficientes'
        );
      
      case 404:
        print('❌ ApiService: Error 404 - Recurso no encontrado');
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Recurso no encontrado'
        );
      
      case 422:
        print('❌ ApiService: Error 422 - Datos de entrada inválidos');
        throw AuthFailure.apiError(
          responseData['message'] ?? 'Datos de entrada inválidos'
        );
      
      case 500:
        print('❌ ApiService: Error 500 - Error interno del servidor');
        throw AuthFailure.serverError(
          responseData['message'] ?? 'Error interno del servidor'
        );
      
      default:
        print('❌ ApiService: Error HTTP ${response.statusCode}');
        throw AuthFailure.unknown(
          'Error HTTP ${response.statusCode}: ${responseData['message'] ?? 'Error desconocido'}'
        );
    }
  }

  // Obtener ID del tutor del usuario autenticado
  Future<String?> _getCurrentUserTutorId() async {
    try {
      // Intentar obtener datos del usuario completo del storage
      final completeUserData = await _secureStorage.read(key: 'complete_user_data');
      
      if (completeUserData != null) {
        final userJson = json.decode(completeUserData);
        print('🔍 User JSON: $userJson');
        final userId = userJson['userId'] as String?;
        final tipoUsuario = userJson['tipoUsuario'] as String?;
        print('🔍 Tipo de usuario: $tipoUsuario');
        print('🔍 User ID: $userId');
        if (userId != null && tipoUsuario?.toLowerCase() == 'tutor') {
          print('📋 ID del tutor obtenido del storage: $userId');
          return userId;
        }
        return userId;
      }
      
      print('⚠️  No se pudo obtener ID del tutor del storage');
      return null;
    } catch (e) {
      print('❌ Error obteniendo ID del tutor: $e');
      return null;
    }
  }

  // Manejo de errores
  AuthFailure _handleError(dynamic error) {
    if (error is AuthFailure) return error;
    
    if (error is SocketException) {
      return AuthFailure.network('Error de conexión a internet');
    }
    
    if (error is http.ClientException) {
      return AuthFailure.network('Error de red');
    }
    
    return AuthFailure.unknown(error.toString());
  }

  // Limpieza de recursos
  void dispose() {
    _client.close();
  }

  // Obtener la lista de tutores desde la API
  Future<List<dynamic>> getTutorsFromApi() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/tutors'),
        headers: await _authHeaders,
      );
      final data = await _handleResponse(response);
      return data['data']['tutors'] as List<dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ================= MÉTODOS DE CHAT (S3) =================

  // Enviar mensaje de chat
  Future<Map<String, dynamic>> sendChatMessage({
    required String mensaje,
    required String usuarioId,
    String? chatEstudianteId,
    String? recipientId,
    String? conversationId,
  }) async {
    final requestBody = {
      'mensaje': mensaje,
      'usuario_id': usuarioId,
      if (chatEstudianteId != null) 'chat_estudiante_id': chatEstudianteId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (conversationId != null) 'conversation_id': conversationId,
    };
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiRoutes.chatMessage}'),
      headers: await _authHeaders,
      body: json.encode(requestBody),
    );
    return await _handleResponse(response);
  }

  // Obtener historial de chat
  Future<Map<String, dynamic>> getChatHistory({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl${ApiRoutes.chatHistory(estudianteId)}')
        .replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener mensajes de chat
  Future<Map<String, dynamic>> getChatMessages({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl${ApiRoutes.chatHistoryMessages(estudianteId)}')
        .replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Registrar intento de chat
  Future<Map<String, dynamic>> registerChatAttempt({
    required String estudianteId,
  }) async {
    final requestBody = {
      'estudiante_id': estudianteId,
    };
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiRoutes.chatAttempt}'),
      headers: await _authHeaders,
      body: json.encode(requestBody),
    );
    return await _handleResponse(response);
  }

  // Obtener intentos de chat
  Future<Map<String, dynamic>> getChatAttempts({
    required String estudianteId,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiRoutes.chatAttempts(estudianteId)}'),
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener estado del chat
  Future<Map<String, dynamic>> getChatStatus() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiRoutes.chatStatus}'),
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener info de la IA
  Future<Map<String, dynamic>> getAiInfo() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiRoutes.chatAiInfo}'),
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Probar IA
  Future<Map<String, dynamic>> testAi({
    required String mensaje,
  }) async {
    final requestBody = {
      'mensaje': mensaje,
    };
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiRoutes.chatAiTest}'),
      headers: await _authHeaders,
      body: json.encode(requestBody),
    );
    return await _handleResponse(response);
  }

  // Enviar mensaje privado (conversaciones)
  Future<Map<String, dynamic>> sendPrivateMessage({
    required String mensaje,
    required String usuarioId,
    required String recipientId,
    String? conversationId,
  }) async {
    final requestBody = {
      'mensaje': mensaje,
      'usuario_id': usuarioId,
      'recipient_id': recipientId,
      if (conversationId != null) 'conversation_id': conversationId,
    };
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiRoutes.conversationsMessage}'),
      headers: await _authHeaders,
      body: json.encode(requestBody),
    );
    return await _handleResponse(response);
  }

  // Obtener conversaciones de usuario
  Future<Map<String, dynamic>> getUserConversations({
    required String usuarioId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl${ApiRoutes.userConversations(usuarioId)}')
        .replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener mensajes de una conversación
  Future<Map<String, dynamic>> getConversationMessages({
    required String conversationId,
    required String usuarioId,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {
      'usuario_id': usuarioId,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl${ApiRoutes.conversationMessages(conversationId)}')
        .replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener estado de las conversaciones
  Future<Map<String, dynamic>> getConversationsStatus() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiRoutes.conversationsStatus}'),
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }

  // Obtener info de WebSocket
  Future<Map<String, dynamic>> getWebSocketInfo() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiRoutes.wsInfo}'),
      headers: await _authHeaders,
    );
    return await _handleResponse(response);
  }
} 