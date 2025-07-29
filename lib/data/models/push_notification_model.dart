/*import '../../domain/entities/push_notification_settings.dart';

class PushNotificationSettingsModel extends PushNotificationSettings {
  const PushNotificationSettingsModel({
    required super.isEnabled,
    required super.subscribedTopics,
    super.fcmToken,
  });

  factory PushNotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationSettingsModel(
      isEnabled: json['isEnabled'] ?? false,
      subscribedTopics: List<String>.from(json['subscribedTopics'] ?? []),
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'subscribedTopics': subscribedTopics,
      'fcmToken': fcmToken,
    };
  }
}*/
