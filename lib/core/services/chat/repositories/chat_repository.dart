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
  final SecureStorageRepository _secureStorage;
  final ApiService _apiService;

  ChatRepository({
    required SecureStorageRepository secureStorage,
    required ApiService apiService,
  }) : _secureStorage = secureStorage,
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
      final data = await _apiService.sendChatMessage(
        mensaje: mensaje,
        usuarioId: usuarioId,
        chatEstudianteId: chatEstudianteId,
        recipientId: recipientId,
        conversationId: conversationId,
      );
      return data;
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
      final data = await _apiService.getChatHistory(
        estudianteId: estudianteId,
        page: page,
        limit: limit,
      );
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
      final data = await _apiService.getChatMessages(
        estudianteId: estudianteId,
        page: page,
        limit: limit,
      );
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
      final data = await _apiService.registerChatAttempt(
        estudianteId: estudianteId,
      );
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
      final data = await _apiService.getChatAttempts(
        estudianteId: estudianteId,
      );
      final attempts = data['data'] as List;
      return attempts.map((json) => ChatAttemptModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getChatStatus() async {
    try {
      final data = await _apiService.getChatStatus();
      return data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getAiInfo() async {
    try {
      final data = await _apiService.getAiInfo();
      return data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> testAi({
    required String mensaje,
  }) async {
    try {
      final data = await _apiService.testAi(mensaje: mensaje);
      return data;
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
      final data = await _apiService.sendPrivateMessage(
        mensaje: mensaje,
        usuarioId: usuarioId,
        recipientId: recipientId,
        conversationId: conversationId,
      );
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
      final data = await _apiService.getUserConversations(
        usuarioId: usuarioId,
        page: page,
        limit: limit,
      );
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
      final data = await _apiService.getConversationMessages(
        conversationId: conversationId,
        usuarioId: usuarioId,
        page: page,
        limit: limit,
      );
      return data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getConversationsStatus() async {
    try {
      final data = await _apiService.getConversationsStatus();
      return data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getWebSocketInfo() async {
    try {
      final data = await _apiService.getWebSocketInfo();
      return data;
    } catch (e) {
      throw _handleError(e);
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