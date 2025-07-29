import '../../../constants/enums/tipo_usuario.dart';

class UserApiModel {
  final String userId;
  final String email;
  final String nombre;
  final TipoUsuario userType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserApiModel({
    required this.userId,
    required this.email,
    required this.nombre,
    required this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserApiModel.fromApiResponse(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['userId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      userType: _parseUserType(json['userType']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'nombre': nombre,
      'userType': userType.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static TipoUsuario _parseUserType(dynamic userType) {
    if (userType == null) return TipoUsuario.alumno;

    switch (userType.toString().toLowerCase()) {
      case 'tutor':
        return TipoUsuario.tutor;
      case 'alumno':
      default:
        return TipoUsuario.alumno;
    }
  }

  @override
  String toString() {
    return 'UserApiModel(userId: $userId, email: $email, nombre: $nombre, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserApiModel &&
        other.userId == userId &&
        other.email == email &&
        other.nombre == nombre &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        nombre.hashCode ^
        userType.hashCode;
  }
}
