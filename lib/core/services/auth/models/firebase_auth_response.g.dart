// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAuthResponse _$FirebaseAuthResponseFromJson(Map<String, dynamic> json) =>
    FirebaseAuthResponse(
      data: json['data'] != null 
          ? ApiResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : throw Exception('Data field is null in Firebase response'),
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$FirebaseAuthResponseToJson(
        FirebaseAuthResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

ApiResponseData _$ApiResponseDataFromJson(Map<String, dynamic> json) =>
    ApiResponseData(
      isNewUser: json['isNewUser'] as bool,
      userType: json['userType'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      firebaseUid: json['firebase_uid'] as String,
      institucionNombre: json['institucionNombre'] as String,
    );

Map<String, dynamic> _$ApiResponseDataToJson(ApiResponseData instance) =>
    <String, dynamic>{
      'isNewUser': instance.isNewUser,
      'userType': instance.userType,
      'userId': instance.userId,
      'token': instance.token,
      'nombre': instance.nombre,
      'correo': instance.correo,
      'firebase_uid': instance.firebaseUid,
      'institucionNombre': instance.institucionNombre,
    };

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) =>
    ApiUser(
      userId: json['userId'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      userType: $enumDecode(_$TipoUsuarioEnumMap, json['userType']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApiUserToJson(ApiUser instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'nombre': instance.nombre,
      'userType': _$TipoUsuarioEnumMap[instance.userType]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TipoUsuarioEnumMap = {
  TipoUsuario.tutor: 'tutor',
  TipoUsuario.alumno: 'alumno',
};

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
} 