import 'package:json_annotation/json_annotation.dart';

part 'forum_entity.g.dart';

@JsonSerializable()
class ForumPostEntity {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ForumCategory category;
  final List<String> tags;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final bool isLiked;
  final bool isPinned;
  final bool isAnonymous;
  final String? authorAvatarUrl;
  final List<String>? imageUrls;
  final PostStatus? status;

  const ForumPostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.updatedAt,
    required this.category,
    this.tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isPinned = false,
    this.isAnonymous = false,
    this.authorAvatarUrl,
    this.imageUrls,
    this.status,
  });

  factory ForumPostEntity.fromJson(Map<String, dynamic> json) => _$ForumPostEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ForumPostEntityToJson(this);
}

@JsonSerializable()
class ForumCommentEntity {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final bool isLiked;
  final bool isAnonymous;
  final String? authorAvatarUrl;
  final String? replyToCommentId;
  final List<ForumCommentEntity> replies;

  const ForumCommentEntity({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.isAnonymous = false,
    this.authorAvatarUrl,
    this.replyToCommentId,
    this.replies = const [],
  });

  factory ForumCommentEntity.fromJson(Map<String, dynamic> json) => _$ForumCommentEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ForumCommentEntityToJson(this);
}

enum ForumCategory {
  general,
  support,
  experiences,
  questions,
  resources,
  achievements,
}

enum PostStatus {
  draft,
  published,
  archived,
  reported,
} 