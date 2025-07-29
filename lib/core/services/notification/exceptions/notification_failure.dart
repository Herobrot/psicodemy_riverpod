import 'package:json_annotation/json_annotation.dart';

part 'notification_failure.g.dart';

@JsonSerializable()
class NotificationFailure {
  final String type;
  final String? message;

  // Constructor por defecto para json_serializable
  const NotificationFailure({required this.type, this.message});

  factory NotificationFailure.permissionDenied([String? message]) =>
      NotificationFailure(type: 'permissionDenied', message: message);

  factory NotificationFailure.notInitialized([String? message]) =>
      NotificationFailure(type: 'notInitialized', message: message);

  factory NotificationFailure.invalidNotification([String? message]) =>
      NotificationFailure(type: 'invalidNotification', message: message);

  factory NotificationFailure.schedulingFailed([String? message]) =>
      NotificationFailure(type: 'schedulingFailed', message: message);

  factory NotificationFailure.cancellationFailed([String? message]) =>
      NotificationFailure(type: 'cancellationFailed', message: message);

  factory NotificationFailure.platformError([String? message]) =>
      NotificationFailure(type: 'platformError', message: message);

  factory NotificationFailure.unknown([String? message]) =>
      NotificationFailure(type: 'unknown', message: message);

  factory NotificationFailure.fromJson(Map<String, dynamic> json) =>
      _$NotificationFailureFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationFailureToJson(this);
}
