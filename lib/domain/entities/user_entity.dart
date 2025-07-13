import '../../core/constants/enums/tipo_usuario.dart';

class UserEntity {
  final String id;
  final String correo;
  final String password;
  final TipoUsuario tipoUsuario;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  UserEntity({
    required this.id,
    required this.correo,
    required this.password,
    required this.tipoUsuario,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'UserEntity(id: $id, correo: $correo, password: $password, tipoUsuario: $tipoUsuario, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserEntity &&
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