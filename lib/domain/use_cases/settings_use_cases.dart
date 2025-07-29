import '../entities/settings_entity.dart';
import '../repositories/settings_repository_interface.dart';

class SettingsUseCases {
  final SettingsRepository _settingsRepository;

  SettingsUseCases(this._settingsRepository);

  // General settings use cases
  Future<SettingsEntity> getSettings() async {
    return await _settingsRepository.getSettings();
  }

  Future<SettingsEntity> updateSettings(SettingsEntity settings) async {
    return await _settingsRepository.updateSettings(settings);
  }

  Future<void> resetToDefaults() async {
    await _settingsRepository.resetToDefaults();
  }

  // Notification settings use cases
  Future<NotificationSettings> getNotificationSettings() async {
    return await _settingsRepository.getNotificationSettings();
  }

  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    await _settingsRepository.updateNotificationSettings(settings);
  }

  Future<void> togglePushNotifications(bool enabled) async {
    final current = await getNotificationSettings();
    final updated = current.copyWith(pushNotifications: enabled);
    await _settingsRepository.updateNotificationSettings(updated);
  }

  Future<void> toggleEmailNotifications(bool enabled) async {
    final current = await getNotificationSettings();
    final updated = current.copyWith(emailNotifications: enabled);
    await _settingsRepository.updateNotificationSettings(updated);
  }

  Future<void> setDailyQuoteTime(String time) async {
    final current = await getNotificationSettings();
    final updated = current.copyWith(dailyQuoteTime: time);
    await _settingsRepository.updateNotificationSettings(updated);
  }

  // Privacy settings use cases
  Future<PrivacySettings> getPrivacySettings() async {
    return await _settingsRepository.getPrivacySettings();
  }

  Future<void> updatePrivacySettings(PrivacySettings settings) async {
    await _settingsRepository.updatePrivacySettings(settings);
  }

  Future<void> setProfileVisibility(ProfileVisibility visibility) async {
    final current = await getPrivacySettings();
    final updated = current.copyWith(profileVisibility: visibility);
    await _settingsRepository.updatePrivacySettings(updated);
  }

  Future<void> blockUser(String userId) async {
    await _settingsRepository.blockUser(userId);
  }

  Future<void> unblockUser(String userId) async {
    await _settingsRepository.unblockUser(userId);
  }

  // Appearance settings use cases
  Future<AppearanceSettings> getAppearanceSettings() async {
    return await _settingsRepository.getAppearanceSettings();
  }

  Future<void> updateAppearanceSettings(AppearanceSettings settings) async {
    await _settingsRepository.updateAppearanceSettings(settings);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final current = await getAppearanceSettings();
    final updated = current.copyWith(themeMode: themeMode);
    await _settingsRepository.updateAppearanceSettings(updated);
  }

  Future<void> setFontSize(double fontSize) async {
    final current = await getAppearanceSettings();
    final updated = current.copyWith(fontSize: fontSize);
    await _settingsRepository.updateAppearanceSettings(updated);
  }

  Future<void> setLanguage(String language) async {
    final current = await getAppearanceSettings();
    final updated = current.copyWith(language: language);
    await _settingsRepository.updateAppearanceSettings(updated);
  }

  // Chat settings use cases
  Future<ChatSettings> getChatSettings() async {
    return await _settingsRepository.getChatSettings();
  }

  Future<void> updateChatSettings(ChatSettings settings) async {
    await _settingsRepository.updateChatSettings(settings);
  }

  Future<void> toggleReadReceipts(bool enabled) async {
    final current = await getChatSettings();
    final updated = current.copyWith(readReceipts: enabled);
    await _settingsRepository.updateChatSettings(updated);
  }

  Future<void> toggleTypingIndicators(bool enabled) async {
    final current = await getChatSettings();
    final updated = current.copyWith(typingIndicators: enabled);
    await _settingsRepository.updateChatSettings(updated);
  }

  // Forum settings use cases
  Future<ForumSettings> getForumSettings() async {
    return await _settingsRepository.getForumSettings();
  }

  Future<void> updateForumSettings(ForumSettings settings) async {
    await _settingsRepository.updateForumSettings(settings);
  }

  Future<void> subscribeToCategory(ForumCategory category) async {
    await _settingsRepository.subscribeToCategory(category);
  }

  Future<void> unsubscribeFromCategory(ForumCategory category) async {
    await _settingsRepository.unsubscribeFromCategory(category);
  }

  Future<void> setDefaultAnonymous(bool anonymous) async {
    final current = await getForumSettings();
    final updated = current.copyWith(defaultAnonymous: anonymous);
    await _settingsRepository.updateForumSettings(updated);
  }

  // Data management use cases
  Future<void> exportUserData() async {
    await _settingsRepository.exportUserData();
  }

  Future<void> deleteUserData() async {
    await _settingsRepository.deleteUserData();
  }

  Future<Map<String, dynamic>> getDataUsageStats() async {
    return await _settingsRepository.getDataUsageStats();
  }

  // Cache management use cases
  Future<void> clearCache() async {
    await _settingsRepository.clearCache();
  }

  Future<int> getCacheSize() async {
    return await _settingsRepository.getCacheSize();
  }

  // Real-time updates
  Stream<SettingsEntity> watchSettings() {
    return _settingsRepository.watchSettings();
  }
}
