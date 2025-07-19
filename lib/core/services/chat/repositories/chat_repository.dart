import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../models/chat_attempt_model.dart';
import '../exceptions/chat_exception.dart';
import '../repositories/chat_repository_interface.dart';
import '../../auth/repositories/secure_storage_repository.dart';
import '../../api_service.dart';
import '../../../constants/api_routes.dart';

class ChatRepository implements ChatRepositoryInterface {
  final http.Client _client;
  final SecureStorageRepository _secureStorage;
  final ApiService _apiService;

  ChatRepository({
    http.Client? client,
    required SecureStorageRepository secureStorage,
    required ApiService apiService,
  }) : _client = client ?? http.Client(),
       _secureStorage = secureStorage,
       _apiService = apiService;

  // Headers básicos para todas las requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers con autenticación
  Future<Map<String, String>> get _authHeaders async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw ChatUnauthorizedException('Usuario no autenticado');
    }
    final firebaseToken = await user.getIdToken();
    if (firebaseToken == null) {
      throw ChatUnauthorizedException('No se pudo obtener el token de Firebase');
    }
    
    // Obtener el userId del storage
    final userId = await _getCurrentUserId();
    if (userId == null) {
      throw ChatUnauthorizedException('No se pudo obtener el userId');
    }
    
    return {
      ..._baseHeaders,
      'Authorization': 'Bearer $firebaseToken',
      'X-User-ID': userId,
    };
  }

  Future<String?> _getCurrentUserId() async {
    try {
      print('🔍 === OBTENIENDO USER ID PARA CHAT ===');
      
      // Intentar obtener datos del usuario completo del storage
      final completeUserData = await _secureStorage.read('complete_user_data');
      print('🔍 ¿Hay datos completos del usuario?: ${completeUserData != null}');
      
      if (completeUserData != null) {
        print('🔍 Datos completos del usuario: $completeUserData');
        final userId = completeUserData['userId'] as String?;
        print('🔍 User ID obtenido del storage: $userId');
        
        if (userId != null && userId.isNotEmpty) {
          print('✅ User ID válido encontrado: $userId');
          return userId;
        } else {
          print('⚠️ User ID es null o vacío');
        }
      }
      
      // Fallback: intentar obtener del user_session
      print('🔍 Intentando obtener del user_session...');
      final userSession = await _secureStorage.getToken('user_session');
      print('🔍 User ID obtenido del user_session: $userSession');
      
      if (userSession != null && userSession.isNotEmpty) {
        print('✅ User ID válido encontrado en user_session: $userSession');
        return userSession;
      }
      
      print('❌ No se pudo obtener User ID de ninguna fuente');
      print('==========================================');
      return null;
    } catch (e) {
      print('❌ Error obteniendo userId: $e');
      print('==========================================');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> sendChatMessage({
    required String mensaje,
    required String usuarioId,
    String? chatEstudianteId,
    String? recipientId,
    String? conversationId,
  }) async {
    try {
      final requestBody = {
        'mensaje': mensaje,
        'usuario_id': usuarioId,
        if (chatEstudianteId != null) 'chat_estudiante_id': chatEstudianteId,
        if (recipientId != null) 'recipient_id': recipientId,
        if (conversationId != null) 'conversation_id': conversationId,
      };

      final response = await _client.post(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatMessage}'),
        headers: await _authHeaders,
        body: json.encode(requestBody),
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('https://api.psicodemy.com${ApiRoutes.chatHistory(estudianteId)}')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: await _authHeaders,
      );

      final data = await _handleResponse(response);
      final messages = data['data']['messages'] as List;
      
      return messages.map((json) => ChatMessageModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('https://api.psicodemy.com${ApiRoutes.chatHistoryMessages(estudianteId)}')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: await _authHeaders,
      );

      final data = await _handleResponse(response);
      final messages = data['data']['messages'] as List;
      
      return messages.map((json) => ChatMessageModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ChatAttemptModel> registerChatAttempt({
    required String estudianteId,
  }) async {
    try {
      final requestBody = {
        'estudiante_id': estudianteId,
      };

      final response = await _client.post(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatAttempt}'),
        headers: await _authHeaders,
        body: json.encode(requestBody),
      );

      final data = await _handleResponse(response);
      return ChatAttemptModel.fromJson(data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ChatAttemptModel>> getChatAttempts({
    required String estudianteId,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatAttempts(estudianteId)}'),
        headers: await _authHeaders,
      );

      final data = await _handleResponse(response);
      final attempts = data['data'] as List;
      
      return attempts.map((json) => ChatAttemptModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getChatStatus() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatStatus}'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getAiInfo() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatAiInfo}'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> testAi({
    required String mensaje,
  }) async {
    try {
      final requestBody = {
        'mensaje': mensaje,
      };

      final response = await _client.post(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.chatAiTest}'),
        headers: await _authHeaders,
        body: json.encode(requestBody),
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ChatMessageModel> sendPrivateMessage({
    required String mensaje,
    required String usuarioId,
    required String recipientId,
    String? conversationId,
  }) async {
    try {
      final requestBody = {
        'mensaje': mensaje,
        'usuario_id': usuarioId,
        'recipient_id': recipientId,
        if (conversationId != null) 'conversation_id': conversationId,
      };

      final response = await _client.post(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.conversationsMessage}'),
        headers: await _authHeaders,
        body: json.encode(requestBody),
      );

      final data = await _handleResponse(response);
      return ChatMessageModel.fromJson(data['data']['message']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ConversationModel>> getUserConversations({
    required String usuarioId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('https://api.psicodemy.com${ApiRoutes.userConversations(usuarioId)}')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: await _authHeaders,
      );

      final data = await _handleResponse(response);
      final conversations = data['data']['conversations'] as List;
      
      return conversations.map((json) => ConversationModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getConversationMessages({
    required String conversationId,
    required String usuarioId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = {
        'usuario_id': usuarioId,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('https://api.psicodemy.com${ApiRoutes.conversationMessages(conversationId)}')
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

  @override
  Future<Map<String, dynamic>> getConversationsStatus() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.conversationsStatus}'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getWebSocketInfo() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.psicodemy.com${ApiRoutes.wsInfo}'),
        headers: await _authHeaders,
      );

      return await _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw ChatApiException('Error al parsear la respuesta JSON', response.statusCode);
      }
    } else {
      throw _handleApiError(response);
    }
  }

  ChatException _handleApiError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      final message = errorData['message'] ?? 'Error desconocido';
      final code = errorData['error']?['code'];
      final details = errorData['error']?['details']?.cast<String>();

      switch (response.statusCode) {
        case 400:
          return ChatValidationException(message, code: code, details: details);
        case 401:
          return ChatUnauthorizedException(message, code: code, details: details);
        case 404:
          return ChatNotFoundException(message, code: code, details: details);
        default:
          return ChatApiException(message, response.statusCode, code: code, details: details);
      }
    } catch (e) {
      return ChatApiException('Error en la API', response.statusCode);
    }
  }

  ChatException _handleError(dynamic error) {
    if (error is ChatException) {
      return error;
    } else if (error is http.ClientException) {
      return ChatNetworkException('Error de conexión: ${error.message}');
    } else {
      return ChatApiException('Error inesperado: $error', 500);
    }
  }
} 