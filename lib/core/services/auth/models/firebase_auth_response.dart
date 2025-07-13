import 'package:json_annotation/json_annotation.dart';
import '../../../types/tipo_usuario.dart';

part 'firebase_auth_response.g.dart';

@JsonSerializable()
class FirebaseAuthResponse {
  final ApiResponseData data;
  final String message;
  final String status;

  const FirebaseAuthResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseAuthResponseToJson(this);
}

@JsonSerializable()
class ApiResponseData {
  final bool isNewUser;
  final String userType;
  final String userId;
  final String token;
  final String nombre;
  final String correo;
  @JsonKey(name: 'firebase_uid')
  final String firebaseUid;
  final String institucionNombre;

  const ApiResponseData({
    required this.isNewUser,
    required this.userType,
    required this.userId,
    required this.token,
    required this.nombre,
    required this.correo,
    required this.firebaseUid,
    required this.institucionNombre,
  });

  factory ApiResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseDataToJson(this);
      
  // Método helper para obtener TipoUsuario
  TipoUsuario get tipoUsuario {
    switch (userType.toLowerCase()) {
      case 'tutor':
        return TipoUsuario.tutor;
      case 'alumno':
        return TipoUsuario.alumno;
      default:
        return TipoUsuario.alumno;
    }
  }
}

// Mantenemos ApiUser para compatibilidad con otras partes del código
@JsonSerializable()
class ApiUser {
  final String userId;
  final String email;
  final String nombre;
  final TipoUsuario userType;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ApiUser({
    required this.userId,
    required this.email,
    required this.nombre,
    required this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);
      
  // Factory para crear desde ApiResponseData
  factory ApiUser.fromApiResponseData(ApiResponseData data) {
    return ApiUser(
      userId: data.userId,
      email: data.correo,
      nombre: data.nombre,
      userType: data.tipoUsuario,
      createdAt: null, // No disponible en la respuesta actual
      updatedAt: null, // No disponible en la respuesta actual
    );
  }
}

// Extensión para facilitar el trabajo con TipoUsuario
extension TipoUsuarioJsonExtension on TipoUsuario {
  String get jsonValue {
    switch (this) {
      case TipoUsuario.tutor:
        return 'tutor';
      case TipoUsuario.alumno:
        return 'alumno';
    }
  }
}

// Convertidor personalizado para TipoUsuario
class TipoUsuarioConverter implements JsonConverter<TipoUsuario, String> {
  const TipoUsuarioConverter();

  @override
  TipoUsuario fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'tutor':
        return TipoUsuario.tutor;
      case 'alumno':
        return TipoUsuario.alumno;
      default:
        return TipoUsuario.alumno; // Valor por defecto
    }
  }

  @override
  String toJson(TipoUsuario object) => object.jsonValue;
} 