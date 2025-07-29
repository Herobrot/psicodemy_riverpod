import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/chat_repository.dart';
import 'models/chat_message_model.dart';
import 'models/conversation_model.dart';
import 'models/chat_attempt_model.dart';
import 'providers/chat_providers.dart';

class ChatService {
  final ChatRepository _chatRepository;

  ChatService(this._chatRepository);

  // Chat con IA
  Future<Map<String, dynamic>> sendChatMessage({
    required String mensaje,
    required String usuarioId,
    String? chatEstudianteId,
    String? recipientId,
    String? conversationId,
  }) async {
    return await _chatRepository.sendChatMessage(
      mensaje: mensaje,
      usuarioId: usuarioId,
      chatEstudianteId: chatEstudianteId,
      recipientId: recipientId,
      conversationId: conversationId,
    );
  }

  Future<List<ChatMessageModel>> getChatHistory({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    return await _chatRepository.getChatHistory(
      estudianteId: estudianteId,
      page: page,
      limit: limit,
    );
  }

  Future<List<ChatMessageModel>> getChatMessages({
    required String estudianteId,
    int page = 1,
    int limit = 20,
  }) async {
    return await _chatRepository.getChatMessages(
      estudianteId: estudianteId,
      page: page,
      limit: limit,
    );
  }

  Future<ChatAttemptModel> registerChatAttempt({
    required String estudianteId,
  }) async {
    return await _chatRepository.registerChatAttempt(
      estudianteId: estudianteId,
    );
  }

  Future<List<ChatAttemptModel>> getChatAttempts({
    required String estudianteId,
  }) async {
    return await _chatRepository.getChatAttempts(estudianteId: estudianteId);
  }

  Future<Map<String, dynamic>> getChatStatus() async {
    return await _chatRepository.getChatStatus();
  }

  Future<Map<String, dynamic>> getAiInfo() async {
    return await _chatRepository.getAiInfo();
  }

  Future<Map<String, dynamic>> testAi({required String mensaje}) async {
    return await _chatRepository.testAi(mensaje: mensaje);
  }

  // Conversaciones 1 a 1
  Future<ChatMessageModel> sendPrivateMessage({
    required String mensaje,
    required String usuarioId,
    required String recipientId,
    String? conversationId,
  }) async {
    return await _chatRepository.sendPrivateMessage(
      mensaje: mensaje,
      usuarioId: usuarioId,
      recipientId: recipientId,
      conversationId: conversationId,
    );
  }

  Future<List<ConversationModel>> getUserConversations({
    required String usuarioId,
    int page = 1,
    int limit = 20,
  }) async {
    return await _chatRepository.getUserConversations(
      usuarioId: usuarioId,
      page: page,
      limit: limit,
    );
  }

  Future<Map<String, dynamic>> getConversationMessages({
    required String conversationId,
    required String usuarioId,
    int page = 1,
    int limit = 50,
  }) async {
    return await _chatRepository.getConversationMessages(
      conversationId: conversationId,
      usuarioId: usuarioId,
      page: page,
      limit: limit,
    );
  }

  Future<Map<String, dynamic>> getConversationsStatus() async {
    return await _chatRepository.getConversationsStatus();
  }

  // WebSocket
  Future<Map<String, dynamic>> getWebSocketInfo() async {
    return await _chatRepository.getWebSocketInfo();
  }
}

final chatServiceProvider = Provider<ChatService>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatService(chatRepository);
});
