// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationState _$NotificationStateFromJson(Map<String, dynamic> json) =>
    NotificationState(
      status: json['status'] as String,
      topic: json['topic'] as String?,
      token: json['token'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$NotificationStateToJson(NotificationState instance) =>
    <String, dynamic>{
      'status': instance.status,
      'topic': instance.topic,
      'token': instance.token,
      'error': instance.error,
    };
