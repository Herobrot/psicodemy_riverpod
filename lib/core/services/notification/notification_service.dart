// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'models/notification_model.dart';
// import 'use_cases/notification_use_cases.dart';
// import 'repositories/interface_notification_repository.dart';
// import 'exceptions/notification_exceptions.dart';

// /// Main notification service that provides a high-level API for notification management
// class NotificationService {
//   final Ref _ref;

//   NotificationService(this._ref);

//   /// Initialize the notification service
//   Future<void> initialize() async {
//     try {
//       await _ref.read(initializeNotificationsProvider.notifier).initialize();
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to initialize notification service',
//         error: e,
//       );
//     }
//   }

//   /// Check if notifications are enabled
//   Future<bool> areNotificationsEnabled() async {
//     try {
//       return await _ref.read(checkNotificationPermissionProvider.notifier).check();
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to check notification permission',
//         error: e,
//       );
//     }
//   }

//   /// Request notification permission
//   Future<bool> requestPermission() async {
//     try {
//       return await _ref.read(requestNotificationPermissionProvider.notifier).request();
//     } catch (e) {
//       throw NotificationException.permissionDenied(
//         message: 'Failed to request notification permission',
//       );
//     }
//   }

//   /// Show an immediate notification
//   Future<void> showNotification(NotificationModel notification) async {
//     try {
//       await _ref.read(showNotificationProvider.notifier).show(notification);
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to show notification',
//         error: e,
//       );
//     }
//   }

//   /// Schedule a notification for a specific time
//   Future<void> scheduleNotification(NotificationModel notification) async {
//     try {
//       await _ref.read(scheduleNotificationProvider.notifier).schedule(notification);
//     } catch (e) {
//       throw NotificationException.schedulingFailed(
//         message: 'Failed to schedule notification',
//       );
//     }
//   }

//   /// Cancel a specific notification
//   Future<void> cancelNotification(String notificationId) async {
//     try {
//       await _ref.read(cancelNotificationProvider.notifier).cancel(notificationId);
//     } catch (e) {
//       throw NotificationException.cancellationFailed(
//         message: 'Failed to cancel notification',
//       );
//     }
//   }

//   /// Cancel all notifications
//   Future<void> cancelAllNotifications() async {
//     try {
//       await _ref.read(cancelNotificationProvider.notifier).cancelAll();
//     } catch (e) {
//       throw NotificationException.cancellationFailed(
//         message: 'Failed to cancel all notifications',
//       );
//     }
//   }

//   /// Get all pending notifications
//   Future<List<NotificationModel>> getPendingNotifications() async {
//     try {
//       final asyncValue = await _ref.read(pendingNotificationsProvider.future);
//       return asyncValue;
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to get pending notifications',
//         error: e,
//       );
//     }
//   }

//   /// Get all active notifications
//   Future<List<NotificationModel>> getActiveNotifications() async {
//     try {
//       final asyncValue = await _ref.read(activeNotificationsProvider.future);
//       return asyncValue;
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to get active notifications',
//         error: e,
//       );
//     }
//   }

//   /// Create a notification channel (Android only)
//   Future<void> createNotificationChannel({
//     required String channelId,
//     required String channelName,
//     required String channelDescription,
//     NotificationPriority priority = NotificationPriority.defaultPriority,
//   }) async {
//     try {
//       await _ref.read(createNotificationChannelProvider.notifier).create(
//         channelId: channelId,
//         channelName: channelName,
//         channelDescription: channelDescription,
//         priority: priority,
//       );
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to create notification channel',
//         error: e,
//       );
//     }
//   }

//   /// Delete a notification channel (Android only)
//   Future<void> deleteNotificationChannel(String channelId) async {
//     try {
//       await _ref.read(deleteNotificationChannelProvider.notifier).delete(channelId);
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to delete notification channel',
//         error: e,
//       );
//     }
//   }

//   /// Listen to notification taps
//   Stream<String?> get onNotificationTap {
//     return _ref.read(notificationTapStreamProvider);
//   }

//   /// Listen to notification action taps
//   Stream<NotificationActionResponse> get onNotificationActionTap {
//     return _ref.read(notificationActionStreamProvider);
//   }

//   // Convenience methods for common notification types

//   /// Show a simple notification
//   Future<void> showSimple({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     try {
//       await _ref.read(quickNotificationProvider.notifier).showSimple(
//         title: title,
//         body: body,
//         payload: payload,
//       );
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to show simple notification',
//         error: e,
//       );
//     }
//   }

//   /// Schedule a simple notification
//   Future<void> scheduleSimple({
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String? payload,
//   }) async {
//     try {
//       await _ref.read(quickNotificationProvider.notifier).scheduleSimple(
//         title: title,
//         body: body,
//         scheduledTime: scheduledTime,
//         payload: payload,
//       );
//     } catch (e) {
//       throw NotificationException.schedulingFailed(
//         message: 'Failed to schedule simple notification',
//       );
//     }
//   }

//   /// Schedule a recurring notification
//   Future<void> scheduleRecurring({
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     required RecurrenceType recurrenceType,
//     String? payload,
//   }) async {
//     try {
//       await _ref.read(quickNotificationProvider.notifier).scheduleRecurring(
//         title: title,
//         body: body,
//         scheduledTime: scheduledTime,
//         recurrenceType: recurrenceType,
//         payload: payload,
//       );
//     } catch (e) {
//       throw NotificationException.schedulingFailed(
//         message: 'Failed to schedule recurring notification',
//       );
//     }
//   }

//   /// Create default notification channels
//   Future<void> createDefaultChannels() async {
//     try {
//       // Default channel
//       await createNotificationChannel(
//         channelId: 'default_channel',
//         channelName: 'Default',
//         channelDescription: 'Default notification channel',
//         priority: NotificationPriority.defaultPriority,
//       );

//       // High priority channel
//       await createNotificationChannel(
//         channelId: 'high_priority_channel',
//         channelName: 'High Priority',
//         channelDescription: 'High priority notifications',
//         priority: NotificationPriority.high,
//       );

//       // Low priority channel
//       await createNotificationChannel(
//         channelId: 'low_priority_channel',
//         channelName: 'Low Priority',
//         channelDescription: 'Low priority notifications',
//         priority: NotificationPriority.low,
//       );
//     } catch (e) {
//       throw NotificationException.unknown(
//         message: 'Failed to create default notification channels',
//         error: e,
//       );
//     }
//   }
// }