import 'package:json_annotation/json_annotation.dart';

part 'chat_entity.g.dart';

@JsonSerializable()
class ChatEntity {
  final String id;
  final String name;
  final String? description;
  final ChatType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> participantIds;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final String? avatarUrl;
  final bool isActive;
  final int unreadCount;

  const ChatEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageAt,
    this.avatarUrl,
    this.isActive = false,
    this.unreadCount = 0,
  });

  factory ChatEntity.fromJson(Map<String, dynamic> json) => _$ChatEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ChatEntityToJson(this);
}

@JsonSerializable()
class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? replyToMessageId;
  final bool isRead;
  final bool isEdited;
  final bool isDeleted;
  final List<String>? attachmentUrls;
  final Map<String, dynamic>? metadata;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.replyToMessageId,
    this.isRead = false,
    this.isEdited = false,
    this.isDeleted = false,
    this.attachmentUrls,
    this.metadata,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
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