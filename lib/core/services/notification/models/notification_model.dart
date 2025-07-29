enum NotificationPriority { min, low, defaultPriority, high, max }

enum RecurrenceType { daily, weekly, monthly, yearly }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? payload;
  final DateTime? scheduledTime;
  final NotificationPriority priority;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final String? channelId;
  final String? channelName;
  final String? channelDescription;
  final String? icon;
  final String? sound;
  final bool enableVibration;
  final bool enableLights;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.scheduledTime,
    this.priority = NotificationPriority.defaultPriority,
    this.isRecurring = false,
    this.recurrenceType,
    this.channelId,
    this.channelName,
    this.channelDescription,
    this.icon,
    this.sound,
    this.enableVibration = true,
    this.enableLights = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'priority': priority.index,
      'isRecurring': isRecurring,
      'recurrenceType': recurrenceType?.index,
      'channelId': channelId,
      'channelName': channelName,
      'channelDescription': channelDescription,
      'icon': icon,
      'sound': sound,
      'enableVibration': enableVibration,
      'enableLights': enableLights,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String?,
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : null,
      priority: NotificationPriority.values[json['priority']],
      isRecurring: json['isRecurring'] as bool,
      recurrenceType: json['recurrenceType'] != null
          ? RecurrenceType.values[json['recurrenceType']]
          : null,
      channelId: json['channelId'] as String?,
      channelName: json['channelName'] as String?,
      channelDescription: json['channelDescription'] as String?,
      icon: json['icon'] as String?,
      sound: json['sound'] as String?,
      enableVibration: json['enableVibration'] as bool,
      enableLights: json['enableLights'] as bool,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? payload,
    DateTime? scheduledTime,
    NotificationPriority? priority,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? icon,
    String? sound,
    bool? enableVibration,
    bool? enableLights,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      priority: priority ?? this.priority,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelDescription: channelDescription ?? this.channelDescription,
      icon: icon ?? this.icon,
      sound: sound ?? this.sound,
      enableVibration: enableVibration ?? this.enableVibration,
      enableLights: enableLights ?? this.enableLights,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.payload == payload &&
        other.scheduledTime == scheduledTime &&
        other.priority == priority &&
        other.isRecurring == isRecurring &&
        other.recurrenceType == recurrenceType &&
        other.channelId == channelId &&
        other.channelName == channelName &&
        other.channelDescription == channelDescription &&
        other.icon == icon &&
        other.sound == sound &&
        other.enableVibration == enableVibration &&
        other.enableLights == enableLights;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        payload.hashCode ^
        scheduledTime.hashCode ^
        priority.hashCode ^
        isRecurring.hashCode ^
        recurrenceType.hashCode ^
        channelId.hashCode ^
        channelName.hashCode ^
        channelDescription.hashCode ^
        icon.hashCode ^
        sound.hashCode ^
        enableVibration.hashCode ^
        enableLights.hashCode;
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, payload: $payload, scheduledTime: $scheduledTime, priority: $priority, isRecurring: $isRecurring, recurrenceType: $recurrenceType, channelId: $channelId, channelName: $channelName, channelDescription: $channelDescription, icon: $icon, sound: $sound, enableVibration: $enableVibration, enableLights: $enableLights)';
  }
}
