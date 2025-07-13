// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostEntity _$ForumPostEntityFromJson(Map<String, dynamic> json) =>
    ForumPostEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      category: $enumDecode(_$ForumCategoryEnumMap, json['category']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$PostStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ForumPostEntityToJson(ForumPostEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'category': _$ForumCategoryEnumMap[instance.category]!,
      'tags': instance.tags,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'viewsCount': instance.viewsCount,
      'isLiked': instance.isLiked,
      'isPinned': instance.isPinned,
      'isAnonymous': instance.isAnonymous,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'imageUrls': instance.imageUrls,
      'status': _$PostStatusEnumMap[instance.status],
    };

const _$ForumCategoryEnumMap = {
  ForumCategory.general: 'general',
  ForumCategory.support: 'support',
  ForumCategory.experiences: 'experiences',
  ForumCategory.questions: 'questions',
  ForumCategory.resources: 'resources',
  ForumCategory.achievements: 'achievements',
};

const _$PostStatusEnumMap = {
  PostStatus.draft: 'draft',
  PostStatus.published: 'published',
  PostStatus.archived: 'archived',
  PostStatus.reported: 'reported',
};

ForumCommentEntity _$ForumCommentEntityFromJson(Map<String, dynamic> json) =>
    ForumCommentEntity(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      replyToCommentId: json['replyToCommentId'] as String?,
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map(
                (e) => ForumCommentEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ForumCommentEntityToJson(ForumCommentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'content': instance.content,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'isAnonymous': instance.isAnonymous,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'replyToCommentId': instance.replyToCommentId,
      'replies': instance.replies,
    };
