import '../entities/quote_entity.dart';

abstract class QuoteRepository {
  // Quote operations
  Future<List<QuoteEntity>> getQuotes({
    QuoteCategory? category,
    int limit = 20,
    String? lastQuoteId,
  });
  Future<QuoteEntity?> getQuoteById(String quoteId);
  Future<List<QuoteEntity>> getFavoriteQuotes();
  Future<QuoteEntity> getRandomQuote({QuoteCategory? category});
  
  // Daily quote operations
  Future<DailyQuoteEntity?> getDailyQuote(DateTime date);
  Future<DailyQuoteEntity> getTodayQuote();
  Future<List<DailyQuoteEntity>> getDailyQuoteHistory({int limit = 30});
  
  // User interactions
  Future<void> toggleFavorite(String quoteId);
  Future<void> likeQuote(String quoteId);
  Future<void> shareQuote(String quoteId);
  Future<void> saveUserReflection(String dailyQuoteId, String reflection);
  
  // Search and filter
  Future<List<QuoteEntity>> searchQuotes(String query);
  Future<List<QuoteEntity>> getQuotesByCategory(QuoteCategory category);
  Future<List<QuoteEntity>> getQuotesByAuthor(String author);
  Future<List<QuoteEntity>> getTrendingQuotes();
  
  // Cache management
  Future<void> cacheQuotesForOffline();
  Future<List<QuoteEntity>> getCachedQuotes();
  
  // Real-time updates
  Stream<QuoteEntity> watchFeaturedQuote();
  Stream<DailyQuoteEntity> watchDailyQuote();
} 