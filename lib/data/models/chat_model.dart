import '../../domain/entities/chat_entity.dart';

class ChatModel {
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

  ChatModel({
    required this.id,
    required this.name,
    this.description,
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

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: ChatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatType.individual,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      participantIds: List<String>.from(json['participantIds'] as List),
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'unreadCount': unreadCount,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      name: name,
      description: description,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
      participantIds: participantIds,
      lastMessageId: lastMessageId,
      lastMessageAt: lastMessageAt,
      avatarUrl: avatarUrl,
      isActive: isActive,
      unreadCount: unreadCount,
    );
  }

  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      participantIds: entity.participantIds,
      lastMessageId: entity.lastMessageId,
      lastMessageAt: entity.lastMessageAt,
      avatarUrl: entity.avatarUrl,
      isActive: entity.isActive,
      unreadCount: entity.unreadCount,
    );
  }
}

class MessageModel {
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

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      replyToMessageId: json['replyToMessageId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      attachmentUrls: json['attachmentUrls'] != null
          ? List<String>.from(json['attachmentUrls'] as List)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'isRead': isRead,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'attachmentUrls': attachmentUrls,
      'metadata': metadata,
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
      replyToMessageId: replyToMessageId,
      isRead: isRead,
      isEdited: isEdited,
      isDeleted: isDeleted,
      attachmentUrls: attachmentUrls,
      metadata: metadata,
    );
  }

  static MessageModel fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      content: entity.content,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      replyToMessageId: entity.replyToMessageId,
      isRead: entity.isRead,
      isEdited: entity.isEdited,
      isDeleted: entity.isDeleted,
      attachmentUrls: entity.attachmentUrls,
      metadata: entity.metadata,
    );
  }
}
