import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_failure.freezed.dart';

@freezed
class NotificationFailure with _$NotificationFailure {
  const NotificationFailure._();

  @override
  String? get message => null;

  const factory NotificationFailure.permissionDenied([String? message]) = _PermissionDenied;
  const factory NotificationFailure.notInitialized([String? message]) = _NotInitialized;
  const factory NotificationFailure.invalidNotification([String? message]) = _InvalidNotification;
  const factory NotificationFailure.schedulingFailed([String? message]) = _SchedulingFailed;
  const factory NotificationFailure.cancellationFailed([String? message]) = _CancellationFailed;
  const factory NotificationFailure.platformError([String? message]) = _PlatformError;
  const factory NotificationFailure.unknown([String? message]) = _Unknown;
}