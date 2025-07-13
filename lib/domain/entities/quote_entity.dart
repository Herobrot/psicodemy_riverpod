import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_entity.freezed.dart';

@freezed
class QuoteEntity with _$QuoteEntity {
  const factory QuoteEntity({
    required String id,
    required String text,
    required String author,
    required QuoteCategory category,
    required DateTime createdAt,
    @Default(false) bool isFavorite,
    @Default(0) int likesCount,
    @Default(0) int sharesCount,
    String? sourceUrl,
    String? imageUrl,
    List<String>? tags,
    @Default(false) bool isDaily,
    DateTime? featuredAt,
  }) = _QuoteEntity;
}

@freezed
class DailyQuoteEntity with _$DailyQuoteEntity {
  const factory DailyQuoteEntity({
    required String id,
    required QuoteEntity quote,
    required DateTime date,
    @Default(false) bool isRead,
    @Default(false) bool isShared,
    String? userReflection,
  }) = _DailyQuoteEntity;
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