// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) =>
    UserListResponse(
      data: UserListData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

UserListData _$UserListDataFromJson(Map<String, dynamic> json) => UserListData(
  users: (json['users'] as List<dynamic>)
      .map((e) => UserListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  pagination: PaginationInfo.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserListDataToJson(UserListData instance) =>
    <String, dynamic>{
      'users': instance.users,
      'total': instance.total,
      'pagination': instance.pagination,
    };

UserListItem _$UserListItemFromJson(Map<String, dynamic> json) => UserListItem(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  correo: json['correo'] as String,
  tipoUsuario: json['tipo_usuario'] as String,
  isActive: json['is_active'] as bool,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$UserListItemToJson(UserListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'correo': instance.correo,
      'tipo_usuario': instance.tipoUsuario,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) =>
    PaginationInfo(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrev: json['hasPrev'] as bool,
    );

Map<String, dynamic> _$PaginationInfoToJson(PaginationInfo instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };
