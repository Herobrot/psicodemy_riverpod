abstract class PushNotificationSettings {
  final bool isEnabled;
  final List<String> subscribedTopics;
  final String? fcmToken;

  const PushNotificationSettings({
    required this.isEnabled,
    required this.subscribedTopics,
    this.fcmToken,
  });
}