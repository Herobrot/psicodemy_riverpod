import '../entities/chat_entity.dart';

abstract class ChatRepository {
  // Chat operations
  Future<List<ChatEntity>> getChats();
  Future<ChatEntity?> getChatById(String chatId);
  Future<ChatEntity> createChat(ChatEntity chat);
  Future<ChatEntity> updateChat(ChatEntity chat);
  Future<void> deleteChat(String chatId);
  
  // Message operations
  Future<List<MessageEntity>> getMessages(String chatId, {int limit = 50, String? lastMessageId});
  Future<MessageEntity> sendMessage(MessageEntity message);
  Future<MessageEntity> updateMessage(MessageEntity message);
  Future<void> deleteMessage(String messageId);
  
  // Real-time operations
  Stream<List<ChatEntity>> watchChats();
  Stream<List<MessageEntity>> watchMessages(String chatId);
  Stream<MessageEntity> watchNewMessages(String chatId);
  
  // Chat management
  Future<void> markMessageAsRead(String messageId);
  Future<void> markChatAsRead(String chatId);
  Future<void> joinChat(String chatId, String userId);
  Future<void> leaveChat(String chatId, String userId);
  
  // Search
  Future<List<MessageEntity>> searchMessages(String query, {String? chatId});
  Future<List<ChatEntity>> searchChats(String query);
} 