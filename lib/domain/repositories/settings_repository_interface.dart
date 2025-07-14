import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  // Settings operations
  Future<SettingsEntity> getSettings();
  Future<SettingsEntity> updateSettings(SettingsEntity settings);
  Future<void> resetToDefaults();
  
  // Notification settings
  Future<NotificationSettings> getNotificationSettings();
  Future<NotificationSettings> updateNotificationSettings(NotificationSettings settings);
  
  // Privacy settings
  Future<PrivacySettings> getPrivacySettings();
  Future<PrivacySettings> updatePrivacySettings(PrivacySettings settings);
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);
  
  // Appearance settings
  Future<AppearanceSettings> getAppearanceSettings();
  Future<AppearanceSettings> updateAppearanceSettings(AppearanceSettings settings);
  
  // Chat settings
  Future<ChatSettings> getChatSettings();
  Future<ChatSettings> updateChatSettings(ChatSettings settings);
  
  // Forum settings
  Future<ForumSettings> getForumSettings();
  Future<ForumSettings> updateForumSettings(ForumSettings settings);
  Future<void> subscribeToCategory(ForumCategory category);
  Future<void> unsubscribeFromCategory(ForumCategory category);
  
  // Data management
  Future<void> exportUserData();
  Future<void> deleteUserData();
  Future<Map<String, dynamic>> getDataUsageStats();
  
  // Cache management
  Future<void> clearCache();
  Future<int> getCacheSize();
  
  // Real-time updates
  Stream<SettingsEntity> watchSettings();
}

 