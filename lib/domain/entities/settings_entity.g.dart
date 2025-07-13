// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsEntity _$SettingsEntityFromJson(Map<String, dynamic> json) =>
    SettingsEntity(
      userId: json['userId'] as String,
      notifications: NotificationSettings.fromJson(
        json['notifications'] as Map<String, dynamic>,
      ),
      privacy: PrivacySettings.fromJson(
        json['privacy'] as Map<String, dynamic>,
      ),
      appearance: AppearanceSettings.fromJson(
        json['appearance'] as Map<String, dynamic>,
      ),
      chat: ChatSettings.fromJson(json['chat'] as Map<String, dynamic>),
      forum: ForumSettings.fromJson(json['forum'] as Map<String, dynamic>),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$SettingsEntityToJson(SettingsEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
      'appearance': instance.appearance,
      'chat': instance.chat,
      'forum': instance.forum,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  pushNotifications: json['pushNotifications'] as bool? ?? true,
  emailNotifications: json['emailNotifications'] as bool? ?? true,
  chatNotifications: json['chatNotifications'] as bool? ?? true,
  forumNotifications: json['forumNotifications'] as bool? ?? true,
  dailyQuotes: json['dailyQuotes'] as bool? ?? true,
  reminders: json['reminders'] as bool? ?? true,
  systemUpdates: json['systemUpdates'] as bool? ?? true,
  dailyQuoteTime: json['dailyQuoteTime'] as String? ?? '08:00',
  mutedUsers:
      (json['mutedUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'pushNotifications': instance.pushNotifications,
  'emailNotifications': instance.emailNotifications,
  'chatNotifications': instance.chatNotifications,
  'forumNotifications': instance.forumNotifications,
  'dailyQuotes': instance.dailyQuotes,
  'reminders': instance.reminders,
  'systemUpdates': instance.systemUpdates,
  'dailyQuoteTime': instance.dailyQuoteTime,
  'mutedUsers': instance.mutedUsers,
};

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      profileVisibility:
          $enumDecodeNullable(
            _$ProfileVisibilityEnumMap,
            json['profileVisibility'],
          ) ??
          ProfileVisibility.public,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      allowDirectMessages: json['allowDirectMessages'] as bool? ?? false,
      showInSearch: json['showInSearch'] as bool? ?? true,
      dataCollection: json['dataCollection'] as bool? ?? false,
      blockedUsers:
          (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PrivacySettingsToJson(
  PrivacySettings instance,
) => <String, dynamic>{
  'profileVisibility': _$ProfileVisibilityEnumMap[instance.profileVisibility]!,
  'showOnlineStatus': instance.showOnlineStatus,
  'allowDirectMessages': instance.allowDirectMessages,
  'showInSearch': instance.showInSearch,
  'dataCollection': instance.dataCollection,
  'blockedUsers': instance.blockedUsers,
};

const _$ProfileVisibilityEnumMap = {
  ProfileVisibility.public: 'public',
  ProfileVisibility.private: 'private',
  ProfileVisibility.friendsOnly: 'friendsOnly',
};

AppearanceSettings _$AppearanceSettingsFromJson(Map<String, dynamic> json) =>
    AppearanceSettings(
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      language: json['language'] as String? ?? 'system',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      highContrast: json['highContrast'] as bool? ?? false,
      reduceAnimations: json['reduceAnimations'] as bool? ?? false,
    );

Map<String, dynamic> _$AppearanceSettingsToJson(AppearanceSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'language': instance.language,
      'fontSize': instance.fontSize,
      'highContrast': instance.highContrast,
      'reduceAnimations': instance.reduceAnimations,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
  ThemeMode.system: 'system',
};

ChatSettings _$ChatSettingsFromJson(Map<String, dynamic> json) => ChatSettings(
  readReceipts: json['readReceipts'] as bool? ?? true,
  typingIndicators: json['typingIndicators'] as bool? ?? true,
  autoDownloadImages: json['autoDownloadImages'] as bool? ?? true,
  autoDownloadVideos: json['autoDownloadVideos'] as bool? ?? false,
  messageRetention:
      $enumDecodeNullable(
        _$MessageRetentionEnumMap,
        json['messageRetention'],
      ) ??
      MessageRetention.forever,
);

Map<String, dynamic> _$ChatSettingsToJson(ChatSettings instance) =>
    <String, dynamic>{
      'readReceipts': instance.readReceipts,
      'typingIndicators': instance.typingIndicators,
      'autoDownloadImages': instance.autoDownloadImages,
      'autoDownloadVideos': instance.autoDownloadVideos,
      'messageRetention': _$MessageRetentionEnumMap[instance.messageRetention]!,
    };

const _$MessageRetentionEnumMap = {
  MessageRetention.oneWeek: 'oneWeek',
  MessageRetention.oneMonth: 'oneMonth',
  MessageRetention.threeMonths: 'threeMonths',
  MessageRetention.oneYear: 'oneYear',
  MessageRetention.forever: 'forever',
};

ForumSettings _$ForumSettingsFromJson(Map<String, dynamic> json) =>
    ForumSettings(
      defaultAnonymous: json['defaultAnonymous'] as bool? ?? false,
      showNotifications: json['showNotifications'] as bool? ?? true,
      subscribedCategories:
          (json['subscribedCategories'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ForumCategoryEnumMap, e))
              .toList() ??
          const [],
      defaultSortOrder:
          $enumDecodeNullable(_$SortOrderEnumMap, json['defaultSortOrder']) ??
          SortOrder.newest,
    );

Map<String, dynamic> _$ForumSettingsToJson(ForumSettings instance) =>
    <String, dynamic>{
      'defaultAnonymous': instance.defaultAnonymous,
      'showNotifications': instance.showNotifications,
      'subscribedCategories': instance.subscribedCategories
          .map((e) => _$ForumCategoryEnumMap[e]!)
          .toList(),
      'defaultSortOrder': _$SortOrderEnumMap[instance.defaultSortOrder]!,
    };

const _$ForumCategoryEnumMap = {
  ForumCategory.general: 'general',
  ForumCategory.support: 'support',
  ForumCategory.experiences: 'experiences',
  ForumCategory.questions: 'questions',
  ForumCategory.resources: 'resources',
  ForumCategory.achievements: 'achievements',
};

const _$SortOrderEnumMap = {
  SortOrder.newest: 'newest',
  SortOrder.oldest: 'oldest',
  SortOrder.mostLiked: 'mostLiked',
  SortOrder.mostCommented: 'mostCommented',
};
