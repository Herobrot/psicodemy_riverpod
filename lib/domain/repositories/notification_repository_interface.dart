import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<String?> getFCMToken();
  Future<void> saveFCMToken(String token, String userId);
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> requestPermission();
  Future<bool> hasPermission();
  Stream<Map<String, dynamic>> get onMessageReceived;
  Stream<Map<String, dynamic>> get onMessageOpenedApp;
  Future<void> saveNotificationToLocal(NotificationEntity notification);
  Future<List<NotificationEntity>> getLocalNotifications();
}