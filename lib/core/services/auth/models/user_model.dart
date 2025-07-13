import '../../../constants/enums/tipo_usuario.dart';

class UserApiModel {
  final String id;
  final String correo;
  final String password;
  final TipoUsuario tipoUsuario;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  UserApiModel({
    required this.id,
    required this.correo,
    required this.password,
    required this.tipoUsuario,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'contraseña': password,
      'tipo_usuario': tipoUsuario.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
    };
  }

  // Factory constructor para crear desde respuesta de API
  factory UserApiModel.fromApiResponse(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['id'] as String,
      correo: json['correo'] as String,
      password: json['contraseña'] as String,
      tipoUsuario: _parseTipoUsuario(json['tipo_usuario']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null 
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  // Método para crear copia sin contraseña (para mostrar en UI)
  UserApiModel copyWithoutPassword({
    String? id,
    String? correo,
    TipoUsuario? tipoUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return UserApiModel(
      id: id ?? this.id,
      correo: correo ?? this.correo,
      password: '',
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() {
    return 'UserApiModel(id: $id, correo: $correo, password: $password, tipoUsuario: $tipoUsuario, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserApiModel &&
      other.id == id &&
      other.correo == correo &&
      other.password == password &&
      other.tipoUsuario == tipoUsuario &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      correo.hashCode ^
      password.hashCode ^
      tipoUsuario.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}

// Función helper para parsear tipo de usuario
TipoUsuario _parseTipoUsuario(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'tutor':
        return TipoUsuario.tutor;
      case 'alumno':
        return TipoUsuario.alumno;
      default:
        return TipoUsuario.alumno;
    }
  }
  return TipoUsuario.alumno;
}

// Extensión para obtener el nombre del tipo de usuario
extension TipoUsuarioExtension on TipoUsuario {
  String get displayName {
    switch (this) {
      case TipoUsuario.tutor:
        return 'Tutor';
      case TipoUsuario.alumno:
        return 'Alumno';
    }
  }
}