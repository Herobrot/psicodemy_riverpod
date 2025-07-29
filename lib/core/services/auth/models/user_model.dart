import '../../../constants/enums/tipo_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.createdAt,
    this.lastSignInAt,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInAt': lastSignInAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ displayName.hashCode;
  }
}

// Función helper para parsear tipo de usuario
TipoUsuario parseTipoUsuario(dynamic value) {
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
