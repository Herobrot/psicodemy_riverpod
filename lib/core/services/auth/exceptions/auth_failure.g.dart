// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthFailure _$AuthFailureFromJson(Map<String, dynamic> json) => AuthFailure(
  type: json['type'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$AuthFailureToJson(AuthFailure instance) =>
    <String, dynamic>{'type': instance.type, 'message': instance.message};
