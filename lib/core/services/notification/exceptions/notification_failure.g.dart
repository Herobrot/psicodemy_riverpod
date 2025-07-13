// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationFailure _$NotificationFailureFromJson(Map<String, dynamic> json) =>
    NotificationFailure(
      type: json['type'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$NotificationFailureToJson(
  NotificationFailure instance,
) => <String, dynamic>{'type': instance.type, 'message': instance.message};
