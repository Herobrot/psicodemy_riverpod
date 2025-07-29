import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_state.g.dart';

@JsonSerializable()
class NotificationState {
  final String status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final NotificationEntity? notification;
  final String? topic;
  final String? token;
  final String? error;

  // Constructor por defecto para json_serializable
  const NotificationState({
    required this.status,
    this.notification,
    this.topic,
    this.token,
    this.error,
  });

  factory NotificationState.initial() =>
      const NotificationState(status: 'initial');
  factory NotificationState.loading() =>
      const NotificationState(status: 'loading');
  factory NotificationState.permission() =>
      const NotificationState(status: 'permission');
  factory NotificationState.notifications(NotificationEntity notification) =>
      NotificationState(status: 'notifications', notification: notification);
  factory NotificationState.subscribedTopics(String topic) =>
      NotificationState(status: 'subscribedTopics', topic: topic);
  factory NotificationState.token(String token) =>
      NotificationState(status: 'token', token: token);
  factory NotificationState.error(String error) =>
      NotificationState(status: 'error', error: error);

  factory NotificationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationStateFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationStateToJson(this);
}
