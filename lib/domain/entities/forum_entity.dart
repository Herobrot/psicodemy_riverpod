import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_entity.freezed.dart';

@freezed
class ForumPostEntity with _$ForumPostEntity {
  const factory ForumPostEntity({
    required String id,
    required String title,
    required String content,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required ForumCategory category,
    @Default([]) List<String> tags,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int viewsCount,
    @Default(false) bool isLiked,
    @Default(false) bool isPinned,
    @Default(false) bool isAnonymous,
    String? authorAvatarUrl,
    List<String>? imageUrls,
    PostStatus? status,
  }) = _ForumPostEntity;
}

@freezed
class ForumCommentEntity with _$ForumCommentEntity {
  const factory ForumCommentEntity({
    required String id,
    required String postId,
    required String content,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(0) int likesCount,
    @Default(false) bool isLiked,
    @Default(false) bool isAnonymous,
    String? authorAvatarUrl,
    String? replyToCommentId,
    @Default([]) List<ForumCommentEntity> replies,
  }) = _ForumCommentEntity;
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