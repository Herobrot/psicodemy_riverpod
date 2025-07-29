import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.data,
    required super.timestamp,
    super.isRead,
  });

  factory NotificationModel.fromFirebase(Map<String, dynamic> message) {
    final notification = message['notification'] as Map<String, dynamic>?;
    final data = message['data'] as Map<String, dynamic>?;

    return NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification?['title'] ?? '',
      body: notification?['body'] ?? '',
      data: data,
      timestamp: DateTime.now(),
      isRead: false,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
