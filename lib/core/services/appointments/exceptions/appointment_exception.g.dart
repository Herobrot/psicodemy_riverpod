// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentException _$AppointmentExceptionFromJson(
  Map<String, dynamic> json,
) => AppointmentException(
  type: json['type'] as String,
  message: json['message'] as String,
  details: json['details'] as String?,
);

Map<String, dynamic> _$AppointmentExceptionToJson(
  AppointmentException instance,
) => <String, dynamic>{
  'type': instance.type,
  'message': instance.message,
  'details': instance.details,
};
