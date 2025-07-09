// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../models/notification_model.dart';
// import '../exceptions/notification_exceptions.dart';
// import '../repositories/interface_notification_repository.dart';

// part 'local_notification_provider.g.dart';

// @riverpod
// class LocalNotificationProviderRef extends _$LocalNotificationProviderRef {
//   @override
//   LocalNotificationProvider build() {
//     _listenToNotificationChanges();
//     return LocalNotificationProvider();
//   }

//   void _listenToNotificationChanges(){
//     final notificationService = ref.read(notificationServiceProvider);

//   }
// }

// /*class LocalNotificationProvider implements NotificationRepository {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//   final StreamController<String?> _notificationTapController;
//   final StreamController<NotificationActionResponse> _notificationActionController;
  
//   bool _isInitialized = false;

//   LocalNotificationProvider()
//       : _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
//         _notificationTapController = StreamController<String?>.broadcast(),
//         _notificationActionController = StreamController<NotificationActionResponse>.broadcast();

//   @override
//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     try {
//       const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//       const initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false,
//       );

//       const initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//       );

//       await _flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: _onNotificationResponse,
//         onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationResponse,
//       );

//       _isInitialized = true;
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to initialize notification service',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<bool> areNotificationsEnabled() async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     if (Platform.isAndroid) {
//       final permission = await Permission.notification.status;
//       return permission.isGranted;
//     } else if (Platform.isIOS) {
//       final permission = await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//       return permission ?? false;
//     }

//     return false;
//   }

//   @override
//   Future<bool> requestPermission() async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       if (Platform.isAndroid) {
//         if (Platform.version.contains('33') || 
//             int.tryParse(Platform.version.split('.').first) != null &&
//             int.parse(Platform.version.split('.').first) >= 33) {
//           final permission = await Permission.notification.request();
//           return permission.isGranted;
//         }
//         return true; // Android < 13 doesn't require runtime permission
//       } else if (Platform.isIOS) {
//         final permission = await _flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<
//                 IOSFlutterLocalNotificationsPlugin>()
//             ?.requestPermissions(
//               alert: true,
//               badge: true,
//               sound: true,
//             );
//         return permission ?? false;
//       }
//       return false;
//     } catch (e) {
//       throw NotificationException.permissionDenied(
//         message: 'Failed to request notification permission: ${e.toString()}',
//       );
//     }
//   }

//   @override
//   Future<void> showNotification(NotificationModel notification) async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       final androidDetails = _buildAndroidNotificationDetails(notification);
//       final iOSDetails = _buildIOSNotificationDetails(notification);

//       final notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iOSDetails,
//       );

//       await _flutterLocalNotificationsPlugin.show(
//         notification.id.hashCode,
//         notification.title,
//         notification.body,
//         notificationDetails,
//         payload: notification.payload,
//       );
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to show notification',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<void> scheduleNotification(NotificationModel notification) async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     if (notification.scheduledTime == null) {
//       throw const NotificationException.invalidNotification(
//         message: 'Scheduled time is required for scheduled notifications',
//       );
//     }

//     try {
//       final scheduledDate = tz.TZDateTime.from(
//         notification.scheduledTime!,
//         tz.local,
//       );

//       final androidDetails = _buildAndroidNotificationDetails(notification);
//       final iOSDetails = _buildIOSNotificationDetails(notification);

//       final notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iOSDetails,
//       );

//       if (notification.isRecurring && notification.recurrenceType != null) {
//         await _scheduleRecurringNotification(
//           notification,
//           notificationDetails,
//           scheduledDate,
//         );
//       } else {
//         await _flutterLocalNotificationsPlugin.zonedSchedule(
//           notification.id.hashCode,
//           notification.title,
//           notification.body,
//           scheduledDate,
//           notificationDetails,
//           payload: notification.payload,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//         );
//       }
//     } catch (e) {
//       throw NotificationException.schedulingFailed(
//         message: 'Failed to schedule notification: ${e.toString()}',
//       );
//     }
//   }

//   @override
//   Future<void> cancelNotification(String notificationId) async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       await _flutterLocalNotificationsPlugin.cancel(notificationId.hashCode);
//     } catch (e) {
//       throw NotificationException.cancellationFailed(
//         message: 'Failed to cancel notification',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<void> cancelAllNotifications() async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       await _flutterLocalNotificationsPlugin.cancelAll();
//     } catch (e) {
//       throw NotificationException.cancellationFailed(
//         message: 'Failed to cancel all notifications',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<List<NotificationModel>> getPendingNotifications() async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       final pendingNotifications = await _flutterLocalNotificationsPlugin
//           .pendingNotificationRequests();
      
//       return pendingNotifications.map((request) {
//         return NotificationModel(
//           id: request.id.toString(),
//           title: request.title ?? '',
//           body: request.body ?? '',
//           payload: request.payload,
//         );
//       }).toList();
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to get pending notifications',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<List<NotificationModel>> getActiveNotifications() async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     try {
//       final activeNotifications = await _flutterLocalNotificationsPlugin
//           .getActiveNotifications();
      
//       return activeNotifications.map((notification) {
//         return NotificationModel(
//           id: notification.id.toString(),
//           title: notification.title ?? '',
//           body: notification.body ?? '',
//           payload: notification.payload,
//         );
//       }).toList();
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to get active notifications',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<void> createNotificationChannel({
//     required String channelId,
//     required String channelName,
//     required String channelDescription,
//     NotificationPriority priority = NotificationPriority.defaultPriority,
//   }) async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     if (!Platform.isAndroid) return;

//     try {
//       final androidChannel = AndroidNotificationChannel(
//         channelId,
//         channelName,
//         description: channelDescription,
//         importance: _mapPriorityToImportance(priority),
//       );

//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(androidChannel);
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to create notification channel',
//         error: e,
//       );
//     }
//   }

//   @override
//   Future<void> deleteNotificationChannel(String channelId) async {
//     if (!_isInitialized) {
//       throw const NotificationException.notInitialized();
//     }

//     if (!Platform.isAndroid) return;

//     try {
//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.deleteNotificationChannel(channelId);
//     } catch (e) {
//       throw NotificationException.platformError(
//         message: 'Failed to delete notification channel',
//         error: e,
//       );
//     }
//   }

//   @override
//   Stream<String?> get onNotificationTap => _notificationTapController.stream;

//   @override
//   Stream<NotificationActionResponse> get onNotificationActionTap =>
//       _notificationActionController.stream;

//   // Private methods

//   AndroidNotificationDetails _buildAndroidNotificationDetails(
//     NotificationModel notification,
//   ) {
//     return AndroidNotificationDetails(
//       notification.channelId ?? 'default_channel',
//       notification.channelName ?? 'Default Channel',
//       channelDescription: notification.channelDescription ?? 'Default channel for notifications',
//       importance: _mapPriorityToImportance(notification.priority),
//       priority: _mapPriorityToPriority(notification.priority),
//       enableVibration: notification.enableVibration,
//       enableLights: notification.enableLights,
//       icon: notification.icon,
//       sound: notification.sound != null 
//           ? RawResourceAndroidNotificationSound(notification.sound!)
//           : null,
//       actions: notification.actions?.map((action) {
//         return AndroidNotificationAction(
//           action.id,
//           action.title,
//           icon: action.icon != null 
//               ? DrawableResourceAndroidBitmap(action.icon!)
//               : null,
//           contextual: action.requiresAuthentication,
//           showsUserInterface: action.showsUserInterface,
//         );
//       }).toList(),
//     );
//   }

//   DarwinNotificationDetails _buildIOSNotificationDetails(
//     NotificationModel notification,
//   ) {
//     return DarwinNotificationDetails(
//       sound: notification.sound,
//       threadIdentifier: notification.channelId,
//       interruptionLevel: _mapPriorityToInterruptionLevel(notification.priority),
//     );
//   }

//   Future<void> _scheduleRecurringNotification(
//     NotificationModel notification,
//     NotificationDetails notificationDetails,
//     tz.TZDateTime scheduledDate,
//   ) async {
//     DateTimeComponents? dateTimeComponents;

//     switch (notification.recurrenceType!) {
//       case RecurrenceType.daily:
//         dateTimeComponents = DateTimeComponents.time;
//         break;
//       case RecurrenceType.weekly:
//         dateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
//         break;
//       case RecurrenceType.monthly:
//         dateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
//         break;
//       case RecurrenceType.yearly:
//         dateTimeComponents = DateTimeComponents.dateAndTime;
//         break;
//     }

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       notification.id.hashCode,
//       notification.title,
//       notification.body,
//       scheduledDate,
//       notificationDetails,
//       payload: notification.payload,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: dateTimeComponents,
//     );
//   }

//   Importance _mapPriorityToImportance(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.min:
//         return Importance.min;
//       case NotificationPriority.low:
//         return Importance.low;
//       case NotificationPriority.defaultPriority:
//         return Importance.defaultImportance;
//       case NotificationPriority.high:
//         return Importance.high;
//       case NotificationPriority.max:
//         return Importance.max;
//     }
//   }

//   Priority _mapPriorityToPriority(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.min:
//         return Priority.min;
//       case NotificationPriority.low:
//         return Priority.low;
//       case NotificationPriority.defaultPriority:
//         return Priority.defaultPriority;
//       case NotificationPriority.high:
//         return Priority.high;
//       case NotificationPriority.max:
//         return Priority.max;
//     }
//   }

//   InterruptionLevel _mapPriorityToInterruptionLevel(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.min:
//       case NotificationPriority.low:
//         return InterruptionLevel.passive;
//       case NotificationPriority.defaultPriority:
//         return InterruptionLevel.active;
//       case NotificationPriority.high:
//         return InterruptionLevel.timeSensitive;
//       case NotificationPriority.max:
//         return InterruptionLevel.critical;
//     }
//   }

//   void _onNotificationResponse(NotificationResponse response) {
//     if (response.actionId != null) {
//       _notificationActionController.add(NotificationActionResponse(
//         notificationId: response.id.toString(),
//         actionId: response.actionId!,
//         payload: response.payload,
//       ));
//     } else {
//       _notificationTapController.add(response.payload);
//     }
//   }

//   @pragma('vm:entry-point')
//   static void _onBackgroundNotificationResponse(NotificationResponse response) {
//     // Handle background notification response
//     // Note: This is a static method and has limited access to instance variables
//     print('Background notification response: ${response.payload}');
//   }

//   void dispose() {
//     _notificationTapController.close();
//     _notificationActionController.close();
//   }
// }*/