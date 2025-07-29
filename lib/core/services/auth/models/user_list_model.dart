import 'package:json_annotation/json_annotation.dart';

part 'user_list_model.g.dart';

@JsonSerializable()
class UserListResponse {
  final UserListData data;
  final String message;
  final String status;

  UserListResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);
}

@JsonSerializable()
class UserListData {
  final List<UserListItem> users;
  final int total;
  final PaginationInfo pagination;

  UserListData({
    required this.users,
    required this.total,
    required this.pagination,
  });

  factory UserListData.fromJson(Map<String, dynamic> json) =>
      _$UserListDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserListDataToJson(this);
}

@JsonSerializable()
class UserListItem {
  final String id;
  final String nombre;
  final String correo;
  @JsonKey(name: 'tipo_usuario')
  final String tipoUsuario;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  UserListItem({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.tipoUsuario,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserListItem.fromJson(Map<String, dynamic> json) =>
      _$UserListItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserListItemToJson(this);
}

@JsonSerializable()
class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  @JsonKey(name: 'totalPages')
  final int totalPages;
  @JsonKey(name: 'hasNext')
  final bool hasNext;
  @JsonKey(name: 'hasPrev')
  final bool hasPrev;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);
}
