import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = _NotificationStateInitial;
  const factory NotificationState.loading() = _NotificationStateLoading;
  const factory NotificationState.permission() = _NotificationStatePermission;
  const factory NotificationState.notifications(NotificationEntity notification) = _NotificationStateNotifications;
  const factory NotificationState.subscribedTopics(String topic) = _NotificationStateSubscribedTopics;
  const factory NotificationState.token(String token) = _NotificationStateToken;
  const factory NotificationState.error(String error) = _NotificationStateError;
}