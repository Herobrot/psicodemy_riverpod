import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_entity.freezed.dart';

@freezed
class ChatEntity with _$ChatEntity {
  const factory ChatEntity({
    required String id,
    required String name,
    required String? description,
    required ChatType type,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> participantIds,
    String? lastMessageId,
    DateTime? lastMessageAt,
    String? avatarUrl,
    @Default(false) bool isActive,
    @Default(0) int unreadCount,
  }) = _ChatEntity;
}

@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required MessageType type,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? replyToMessageId,
    @Default(false) bool isRead,
    @Default(false) bool isEdited,
    @Default(false) bool isDeleted,
    List<String>? attachmentUrls,
    Map<String, dynamic>? metadata,
  }) = _MessageEntity;
}

enum ChatType {
  individual,
  group,
  therapist,
  support,
}

enum MessageType {
  text,
  image,
  audio,
  video,
  file,
  system,
} 