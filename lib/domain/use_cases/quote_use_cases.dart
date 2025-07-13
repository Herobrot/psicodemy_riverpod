import '../entities/quote_entity.dart';
import '../repositories/quote_repository_interface.dart';

class QuoteUseCases {
  final QuoteRepository _quoteRepository;

  QuoteUseCases(this._quoteRepository);

  // Quote management use cases
  Future<List<QuoteEntity>> getQuotes({
    QuoteCategory? category,
    int limit = 20,
  }) async {
    return await _quoteRepository.getQuotes(category: category, limit: limit);
  }

  Future<QuoteEntity?> getQuoteById(String quoteId) async {
    return await _quoteRepository.getQuoteById(quoteId);
  }

  Future<QuoteEntity> getRandomQuote({QuoteCategory? category}) async {
    return await _quoteRepository.getRandomQuote(category: category);
  }

  Future<List<QuoteEntity>> getFavoriteQuotes() async {
    return await _quoteRepository.getFavoriteQuotes();
  }

  // Daily quote use cases
  Future<DailyQuoteEntity> getTodayQuote() async {
    return await _quoteRepository.getTodayQuote();
  }

  Future<DailyQuoteEntity?> getDailyQuote(DateTime date) async {
    return await _quoteRepository.getDailyQuote(date);
  }

  Future<List<DailyQuoteEntity>> getDailyQuoteHistory({int limit = 30}) async {
    return await _quoteRepository.getDailyQuoteHistory(limit: limit);
  }

  Future<void> saveReflection(String dailyQuoteId, String reflection) async {
    await _quoteRepository.saveUserReflection(dailyQuoteId, reflection);
  }

  // User interaction use cases
  Future<void> toggleFavorite(String quoteId) async {
    await _quoteRepository.toggleFavorite(quoteId);
  }

  Future<void> likeQuote(String quoteId) async {
    await _quoteRepository.likeQuote(quoteId);
  }

  Future<void> shareQuote(String quoteId) async {
    await _quoteRepository.shareQuote(quoteId);
  }

  // Search and filter use cases
  Future<List<QuoteEntity>> searchQuotes(String query) async {
    return await _quoteRepository.searchQuotes(query);
  }

  Future<List<QuoteEntity>> getQuotesByCategory(QuoteCategory category) async {
    return await _quoteRepository.getQuotesByCategory(category);
  }

  Future<List<QuoteEntity>> getQuotesByAuthor(String author) async {
    return await _quoteRepository.getQuotesByAuthor(author);
  }

  Future<List<QuoteEntity>> getTrendingQuotes() async {
    return await _quoteRepository.getTrendingQuotes();
  }

  // Inspiration use cases
  Future<QuoteEntity> getMotivationalQuote() async {
    return await _quoteRepository.getRandomQuote(category: QuoteCategory.motivation);
  }

  Future<QuoteEntity> getHealingQuote() async {
    return await _quoteRepository.getRandomQuote(category: QuoteCategory.healing);
  }

  Future<QuoteEntity> getSelfCareQuote() async {
    return await _quoteRepository.getRandomQuote(category: QuoteCategory.selfCare);
  }

  // Offline support use cases
  Future<void> cacheQuotesForOffline() async {
    await _quoteRepository.cacheQuotesForOffline();
  }

  Future<List<QuoteEntity>> getCachedQuotes() async {
    return await _quoteRepository.getCachedQuotes();
  }

  // Real-time streams
  Stream<QuoteEntity> watchFeaturedQuote() {
    return _quoteRepository.watchFeaturedQuote();
  }

  Stream<DailyQuoteEntity> watchDailyQuote() {
    return _quoteRepository.watchDailyQuote();
  }
} 