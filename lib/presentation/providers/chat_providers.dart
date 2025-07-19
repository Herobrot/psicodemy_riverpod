import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/chat/chat_service.dart' as chat_service;
import '../../core/services/chat/models/chat_message_model.dart';
import '../../core/services/chat/models/conversation_model.dart';
import '../../core/services/chat/models/chat_attempt_model.dart';
import '../../core/services/tutors/tutor_service.dart';
import '../../core/services/tutors/models/tutor_model.dart';

// Provider para obtener todos los tutores
final tutorsProvider = FutureProvider<List<TutorModel>>((ref) async {
  final tutorService = ref.watch(tutorServiceProvider);
  return await tutorService.getTutors();
});

// Provider para el servicio de chat
final chatServiceProvider = chat_service.chatServiceProvider;

// Provider para el estado de carga de tutores
final tutorsLoadingProvider = StateProvider<bool>((ref) => false);

// Provider para el estado de error de tutores
final tutorsErrorProvider = StateProvider<String?>((ref) => null);

// Provider para las conversaciones del usuario
final userConversationsProvider = FutureProvider.family<List<ConversationModel>, String>((ref, usuarioId) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getUserConversations(usuarioId: usuarioId);
});

// Provider para los mensajes de una conversación específica
final conversationMessagesProvider = FutureProvider.family<Map<String, dynamic>, Map<String, String>>((ref, params) async {
  final chatService = ref.watch(chatServiceProvider);
  final conversationId = params['conversationId']!;
  final usuarioId = params['usuarioId']!;
  
  return await chatService.getConversationMessages(
    conversationId: conversationId,
    usuarioId: usuarioId,
  );
});

// Provider para el historial de chat con IA
final chatHistoryProvider = FutureProvider.family<List<ChatMessageModel>, String>((ref, estudianteId) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getChatMessages(estudianteId: estudianteId);
});

// Provider para los intentos de chat
final chatAttemptsProvider = FutureProvider.family<List<ChatAttemptModel>, String>((ref, estudianteId) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getChatAttempts(estudianteId: estudianteId);
});

// Provider para el estado del servicio de chat
final chatStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getChatStatus();
});

// Provider para la información de IA
final aiInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getAiInfo();
});

// Provider para el estado de envío de mensajes
final messageSendingProvider = StateProvider<bool>((ref) => false);

// Provider para el estado de error en envío de mensajes
final messageErrorProvider = StateProvider<String?>((ref) => null);

// Provider para el estado de éxito en envío de mensajes
final messageSuccessProvider = StateProvider<bool>((ref) => false);

// Provider para el mensaje actual siendo editado
final currentMessageProvider = StateProvider<String>((ref) => '');

// Provider para el destinatario seleccionado
final selectedRecipientProvider = StateProvider<String?>((ref) => null);

// Provider para la conversación actual
final currentConversationProvider = StateProvider<String?>((ref) => null);

// Provider para el estado de conexión WebSocket
final websocketConnectionProvider = StateProvider<bool>((ref) => false);

// Provider para el estado de información de WebSocket
final websocketInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final chatService = ref.watch(chatServiceProvider);
  return await chatService.getWebSocketInfo();
}); 