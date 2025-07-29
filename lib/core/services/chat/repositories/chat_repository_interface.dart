import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../models/chat_attempt_model.dart';

abstract class ChatRepositoryInterface {
  // Chat con IA
  Future<Map<String, dynamic>> sendChatMessage({
    required String mensaje,
    required String usuarioId,
    String? chatEstudianteId,
    String? recipientId,
    String? conversationId,
  });

  Future<List<ChatMessageModel>> getChatHistory({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  });

  Future<List<ChatMessageModel>> getChatMessages({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  });

  Future<ChatAttemptModel> registerChatAttempt({required String estudianteId});

  Future<List<ChatAttemptModel>> getChatAttempts({
    required String estudianteId,
  });

  Future<Map<String, dynamic>> getChatStatus();

  Future<Map<String, dynamic>> getAiInfo();

  Future<Map<String, dynamic>> testAi({required String mensaje});

  // Conversaciones 1 a 1
  Future<ChatMessageModel> sendPrivateMessage({
    required String mensaje,
    required String usuarioId,
    required String recipientId,
    String? conversationId,
  });

  Future<List<ConversationModel>> getUserConversations({
    required String usuarioId,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> getConversationMessages({
    required String conversationId,
    required String usuarioId,
    int page = 1,
    int limit = 50,
  });

  Future<Map<String, dynamic>> getConversationsStatus();

  // WebSocket
  Future<Map<String, dynamic>> getWebSocketInfo();
}
