import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {  
  const factory NotificationState.initial() = _Initial;    
  const factory NotificationState.permissionRequested() = _PermissionRequested;
  const factory NotificationState.permissionGranted() = _PermissionGranted;
  const factory NotificationState.permissionDenied() = _PermissionDenied;    
  const factory NotificationState.notificationShown() = _NotificationShown;
  const factory NotificationState.notificationScheduled() = _NotificationScheduled;
  const factory NotificationState.notificationCancelled() = _NotificationCancelled;
  const factory NotificationState.allNotificationsCancelled() = _AllNotificationsCancelled;    
  const factory NotificationState.channelCreated() = _ChannelCreated;
  const factory NotificationState.channelDeleted() = _ChannelDeleted;    
  const factory NotificationState.error(String message) = _Error;    
  const factory NotificationState.loading() = _Loading;    
  const factory NotificationState.settingsChecked(bool enabled) = _SettingsChecked;
}