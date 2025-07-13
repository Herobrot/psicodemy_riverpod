import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    required String userId,
    required NotificationSettings notifications,
    required PrivacySettings privacy,
    required AppearanceSettings appearance,
    required ChatSettings chat,
    required ForumSettings forum,
    DateTime? lastUpdated,
  }) = _SettingsEntity;
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool pushNotifications,
    @Default(true) bool emailNotifications,
    @Default(true) bool chatNotifications,
    @Default(true) bool forumNotifications,
    @Default(true) bool dailyQuotes,
    @Default(true) bool reminders,
    @Default(true) bool systemUpdates,
    @Default('08:00') String dailyQuoteTime,
    @Default([]) List<String> mutedUsers,
  }) = _NotificationSettings;
}

@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    @Default(ProfileVisibility.public) ProfileVisibility profileVisibility,
    @Default(true) bool showOnlineStatus,
    @Default(false) bool allowDirectMessages,
    @Default(true) bool showInSearch,
    @Default(false) bool dataCollection,
    @Default([]) List<String> blockedUsers,
  }) = _PrivacySettings;
}

@freezed
class AppearanceSettings with _$AppearanceSettings {
  const factory AppearanceSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default('system') String language,
    @Default(16.0) double fontSize,
    @Default(false) bool highContrast,
    @Default(false) bool reduceAnimations,
  }) = _AppearanceSettings;
}

@freezed
class ChatSettings with _$ChatSettings {
  const factory ChatSettings({
    @Default(true) bool readReceipts,
    @Default(true) bool typingIndicators,
    @Default(true) bool autoDownloadImages,
    @Default(false) bool autoDownloadVideos,
    @Default(MessageRetention.forever) MessageRetention messageRetention,
  }) = _ChatSettings;
}

@freezed
class ForumSettings with _$ForumSettings {
  const factory ForumSettings({
    @Default(false) bool defaultAnonymous,
    @Default(true) bool showNotifications,
    @Default([]) List<ForumCategory> subscribedCategories,
    @Default(SortOrder.newest) SortOrder defaultSortOrder,
  }) = _ForumSettings;
}

enum ProfileVisibility {
  public,
  private,
  friendsOnly,
}

enum ThemeMode {
  light,
  dark,
  system,
}

enum MessageRetention {
  oneWeek,
  oneMonth,
  threeMonths,
  oneYear,
  forever,
}

enum SortOrder {
  newest,
  oldest,
  mostLiked,
  mostCommented,
}

// Import ForumCategory from forum_entity
enum ForumCategory {
  general,
  support,
  experiences,
  questions,
  resources,
  achievements,
} 