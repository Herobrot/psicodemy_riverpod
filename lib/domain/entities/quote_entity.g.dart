// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteEntity _$QuoteEntityFromJson(Map<String, dynamic> json) => QuoteEntity(
  id: json['id'] as String,
  text: json['text'] as String,
  author: json['author'] as String,
  category: $enumDecode(_$QuoteCategoryEnumMap, json['category']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isFavorite: json['isFavorite'] as bool? ?? false,
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
  sourceUrl: json['sourceUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isDaily: json['isDaily'] as bool? ?? false,
  featuredAt: json['featuredAt'] == null
      ? null
      : DateTime.parse(json['featuredAt'] as String),
);

Map<String, dynamic> _$QuoteEntityToJson(QuoteEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'author': instance.author,
      'category': _$QuoteCategoryEnumMap[instance.category]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'likesCount': instance.likesCount,
      'sharesCount': instance.sharesCount,
      'sourceUrl': instance.sourceUrl,
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'isDaily': instance.isDaily,
      'featuredAt': instance.featuredAt?.toIso8601String(),
    };

const _$QuoteCategoryEnumMap = {
  QuoteCategory.motivation: 'motivation',
  QuoteCategory.healing: 'healing',
  QuoteCategory.selfCare: 'selfCare',
  QuoteCategory.relationships: 'relationships',
  QuoteCategory.mindfulness: 'mindfulness',
  QuoteCategory.growth: 'growth',
  QuoteCategory.resilience: 'resilience',
  QuoteCategory.hope: 'hope',
};

DailyQuoteEntity _$DailyQuoteEntityFromJson(Map<String, dynamic> json) =>
    DailyQuoteEntity(
      id: json['id'] as String,
      quote: QuoteEntity.fromJson(json['quote'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isShared: json['isShared'] as bool? ?? false,
      userReflection: json['userReflection'] as String?,
    );

Map<String, dynamic> _$DailyQuoteEntityToJson(DailyQuoteEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote': instance.quote,
      'date': instance.date.toIso8601String(),
      'isRead': instance.isRead,
      'isShared': instance.isShared,
      'userReflection': instance.userReflection,
    };
