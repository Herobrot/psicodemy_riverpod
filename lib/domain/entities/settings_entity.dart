import 'package:json_annotation/json_annotation.dart';

part 'settings_entity.g.dart';

@JsonSerializable()
class SettingsEntity {
  final String userId;
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final AppearanceSettings appearance;
  final ChatSettings chat;
  final ForumSettings forum;
  final DateTime? lastUpdated;

  const SettingsEntity({
    required this.userId,
    required this.notifications,
    required this.privacy,
    required this.appearance,
    required this.chat,
    required this.forum,
    this.lastUpdated,
  });

  factory SettingsEntity.fromJson(Map<String, dynamic> json) => _$SettingsEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsEntityToJson(this);
}

@JsonSerializable()
class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool chatNotifications;
  final bool forumNotifications;
  final bool dailyQuotes;
  final bool reminders;
  final bool systemUpdates;
  final String dailyQuoteTime;
  final List<String> mutedUsers;

  const NotificationSettings({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.chatNotifications = true,
    this.forumNotifications = true,
    this.dailyQuotes = true,
    this.reminders = true,
    this.systemUpdates = true,
    this.dailyQuoteTime = '08:00',
    this.mutedUsers = const [],
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}

@JsonSerializable()
class PrivacySettings {
  final ProfileVisibility profileVisibility;
  final bool showOnlineStatus;
  final bool allowDirectMessages;
  final bool showInSearch;
  final bool dataCollection;
  final List<String> blockedUsers;

  const PrivacySettings({
    this.profileVisibility = ProfileVisibility.public,
    this.showOnlineStatus = true,
    this.allowDirectMessages = false,
    this.showInSearch = true,
    this.dataCollection = false,
    this.blockedUsers = const [],
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) => _$PrivacySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PrivacySettingsToJson(this);
}

@JsonSerializable()
class AppearanceSettings {
  final ThemeMode themeMode;
  final String language;
  final double fontSize;
  final bool highContrast;
  final bool reduceAnimations;

  const AppearanceSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'system',
    this.fontSize = 16.0,
    this.highContrast = false,
    this.reduceAnimations = false,
  });

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) => _$AppearanceSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppearanceSettingsToJson(this);
}

@JsonSerializable()
class ChatSettings {
  final bool readReceipts;
  final bool typingIndicators;
  final bool autoDownloadImages;
  final bool autoDownloadVideos;
  final MessageRetention messageRetention;

  const ChatSettings({
    this.readReceipts = true,
    this.typingIndicators = true,
    this.autoDownloadImages = true,
    this.autoDownloadVideos = false,
    this.messageRetention = MessageRetention.forever,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) => _$ChatSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSettingsToJson(this);
}

@JsonSerializable()
class ForumSettings {
  final bool defaultAnonymous;
  final bool showNotifications;
  final List<ForumCategory> subscribedCategories;
  final SortOrder defaultSortOrder;

  const ForumSettings({
    this.defaultAnonymous = false,
    this.showNotifications = true,
    this.subscribedCategories = const [],
    this.defaultSortOrder = SortOrder.newest,
  });

  factory ForumSettings.fromJson(Map<String, dynamic> json) => _$ForumSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ForumSettingsToJson(this);
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