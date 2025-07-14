// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorException _$TutorExceptionFromJson(Map<String, dynamic> json) =>
    TutorException(
      type: json['type'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$TutorExceptionToJson(TutorException instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'details': instance.details,
    };
