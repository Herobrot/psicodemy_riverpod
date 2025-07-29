import '../models/notification_model.dart';

class NotificationSettings {
  final bool appEnabled;
  final bool channelEnabled; // Android-specific
  final NotificationPermissionStatus permission;

  NotificationSettings({
    required this.appEnabled,
    required this.channelEnabled,
    required this.permission,
  });
}

class NotificationActionResponse {
  final String notificationId;
  final String actionId;
  final String? payload;
  final bool didNotificationLaunchApp; // iOS-specific

  const NotificationActionResponse({
    required this.notificationId,
    required this.actionId,
    this.payload,
    this.didNotificationLaunchApp = false,
  });
}

enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  limited, // Para iOS
}

abstract class NotificationRepository {
  // Inicialización
  Future<void> initialize();

  // Permisos y configuración
  Future<NotificationSettings> getNotificationSettings();
  Future<NotificationPermissionStatus> requestPermission();

  // Operaciones básicas
  Future<void> showNotification(NotificationModel notification);
  Future<void> scheduleNotification(NotificationModel notification);
  Future<void> cancelNotification(String notificationId);
  Future<void> cancelAllNotifications();

  // Gestión programadas
  Future<List<NotificationModel>> getPendingNotifications();

  // Gestión de canales (Android)
  Future<void> createNotificationChannel({
    required String channelId,
    required String channelName,
    required String channelDescription,
    NotificationPriority priority = NotificationPriority.defaultPriority,
    String? sound, // Añadido
  });
  Future<void> deleteNotificationChannel(String channelId);

  // Streams de interacción
  Stream<String?> get onNotificationTap;
  Stream<NotificationActionResponse> get onNotificationActionTap;
}
