// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorModel _$TutorModelFromJson(Map<String, dynamic> json) => TutorModel(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  correo: json['correo'] as String,
);

Map<String, dynamic> _$TutorModelToJson(TutorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'correo': instance.correo,
    };

TutorData _$TutorDataFromJson(Map<String, dynamic> json) => TutorData(
  users: (json['users'] as List<dynamic>)
      .map((e) => TutorModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  userType: json['userType'] as String,
);

Map<String, dynamic> _$TutorDataToJson(TutorData instance) => <String, dynamic>{
  'users': instance.users,
  'total': instance.total,
  'userType': instance.userType,
};

TutorListResponse _$TutorListResponseFromJson(Map<String, dynamic> json) =>
    TutorListResponse(
      data: TutorData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$TutorListResponseToJson(TutorListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

TutorErrorResponse _$TutorErrorResponseFromJson(Map<String, dynamic> json) =>
    TutorErrorResponse(
      data: json['data'],
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$TutorErrorResponseToJson(TutorErrorResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };
