import 'package:json_annotation/json_annotation.dart';

part 'quote_entity.g.dart';

@JsonSerializable()
class QuoteEntity {
  final String id;
  final String text;
  final String author;
  final QuoteCategory category;
  final DateTime createdAt;
  final bool isFavorite;
  final int likesCount;
  final int sharesCount;
  final String? sourceUrl;
  final String? imageUrl;
  final List<String>? tags;
  final bool isDaily;
  final DateTime? featuredAt;

  const QuoteEntity({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    required this.createdAt,
    this.isFavorite = false,
    this.likesCount = 0,
    this.sharesCount = 0,
    this.sourceUrl,
    this.imageUrl,
    this.tags,
    this.isDaily = false,
    this.featuredAt,
  });

  factory QuoteEntity.fromJson(Map<String, dynamic> json) =>
      _$QuoteEntityFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteEntityToJson(this);
}

@JsonSerializable()
class DailyQuoteEntity {
  final String id;
  final QuoteEntity quote;
  final DateTime date;
  final bool isRead;
  final bool isShared;
  final String? userReflection;

  const DailyQuoteEntity({
    required this.id,
    required this.quote,
    required this.date,
    this.isRead = false,
    this.isShared = false,
    this.userReflection,
  });

  factory DailyQuoteEntity.fromJson(Map<String, dynamic> json) =>
      _$DailyQuoteEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DailyQuoteEntityToJson(this);
}

enum QuoteCategory {
  motivation,
  healing,
  selfCare,
  relationships,
  mindfulness,
  growth,
  resilience,
  hope,
}
