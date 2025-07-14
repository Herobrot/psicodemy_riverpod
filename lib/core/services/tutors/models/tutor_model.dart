import 'package:json_annotation/json_annotation.dart';

part 'tutor_model.g.dart';

/// Modelo para un tutor individual
@JsonSerializable()
class TutorModel {
  final String id;
  final String nombre;
  final String correo;

  const TutorModel({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) =>
      _$TutorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TutorModelToJson(this);

  @override
  String toString() {
    return 'TutorModel(id: $id, nombre: $nombre, correo: $correo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TutorModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.correo == correo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nombre.hashCode ^ correo.hashCode;
  }
}

/// Datos de la respuesta de tutores
@JsonSerializable()
class TutorData {
  final List<TutorModel> users;
  final int total;
  final String userType;

  const TutorData({
    required this.users,
    required this.total,
    required this.userType,
  });

  factory TutorData.fromJson(Map<String, dynamic> json) =>
      _$TutorDataFromJson(json);

  Map<String, dynamic> toJson() => _$TutorDataToJson(this);
}

/// Respuesta completa de la API de tutores
@JsonSerializable()
class TutorListResponse {
  final TutorData data;
  final String message;
  final String status;

  const TutorListResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TutorListResponse.fromJson(Map<String, dynamic> json) =>
      _$TutorListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TutorListResponseToJson(this);

  /// Getter para obtener la lista de tutores directamente
  List<TutorModel> get tutores => data.users;

  /// Getter para obtener el total de tutores
  int get totalTutores => data.total;

  /// Verificar si la respuesta es exitosa
  bool get isSuccess => status == 'success';
}

/// Respuesta de error para tutores
@JsonSerializable()
class TutorErrorResponse {
  final dynamic data;
  final String message;
  final String status;

  const TutorErrorResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TutorErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$TutorErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TutorErrorResponseToJson(this);
} 