// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
  status: json['status'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
};

LoginState _$LoginStateFromJson(Map<String, dynamic> json) => LoginState(
  status: json['status'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$LoginStateToJson(LoginState instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};
