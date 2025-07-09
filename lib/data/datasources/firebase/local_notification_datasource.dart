import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/notification_model.dart';

abstract class LocalNotificationDatasource {
  Future<void> saveNotification(NotificationModel notification);
  Future<List<NotificationModel>> getNotifications();
  Future<void> clearNotifications();
  Future<void> markAsRead(String notificationId);
}

class LocalNotificationDatasourceImpl implements LocalNotificationDatasource {
  final SharedPreferences _prefs;
  static const String _notificationsKey = 'local_notifications';

  LocalNotificationDatasourceImpl({required SharedPreferences prefs}) 
      : _prefs = prefs;

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    try {
      final notifications = await getNotifications();
      notifications.insert(0, notification);
      
      // Keep only last 50 notifications
      final limitedNotifications = notifications.take(50).toList();
      
      final jsonList = limitedNotifications.map((n) => n.toJson()).toList();
      await _prefs.setString(_notificationsKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Error saving notification locally: $e');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final jsonString = _prefs.getString(_notificationsKey);
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting local notifications: $e');
    }
  }

  @override
  Future<void> clearNotifications() async {
    try {
      await _prefs.remove(_notificationsKey);
    } catch (e) {
      throw Exception('Error clearing notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          body: notifications[index].body,
          data: notifications[index].data,
          timestamp: notifications[index].timestamp,
          isRead: true,
        );
        notifications[index] = updatedNotification;
        
        final jsonList = notifications.map((n) => n.toJson()).toList();
        await _prefs.setString(_notificationsKey, jsonEncode(jsonList));
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }
}