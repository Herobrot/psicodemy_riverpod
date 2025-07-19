import 'package:psicodemy/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_firebase_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../core/services/auth/auth_service.dart';
import '../../core/services/auth/models/complete_user_model.dart';
import '../../core/constants/enums/tipo_usuario.dart';

// part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepositoryInterface {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _authService.signInWithEmailAndPassword(email, password);
      return _mapUserApiToEntity(userModel);
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  @override
  Future<UserFirebaseEntity> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await _authService.signUpWithEmailAndPassword(email, password);
      return _mapUserModelToEntity(userModel);
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  @override
  Future<UserFirebaseEntity> signInWithGoogle() async {
    try {
      final userModel = await _authService.signInWithGoogle();
      return _mapUserModelToEntity(userModel);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<UserFirebaseEntity?> getCurrentUser() async {
    try {
      final userModel = await _authService.getCurrentUser();
      return userModel != null ? _mapUserModelToEntity(userModel) : null;
    } catch (e) {
      throw Exception('Error al obtener usuario actual: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: ${e.toString()}');
    }
  }

  @override
  Stream<UserFirebaseEntity?> get authStateChanges {
    return _authService.authStateChanges.map((userModel) {
      return userModel != null ? _mapUserModelToEntity(userModel) : null;
    });
  }

  UserFirebaseEntity _mapUserModelToEntity(CompleteUserModel userModel) {
    return UserFirebaseEntity(
      uid: userModel.uid,
      email: userModel.email,
      displayName: userModel.displayName,
      photoURL: userModel.photoURL,
      isEmailVerified: userModel.isEmailVerified,
    );
  }

  UserEntity _mapUserApiToEntity(CompleteUserModel userApi) {
    return UserEntity(
      id: userApi.userId ?? userApi.uid, // Usar userId de API o uid de Firebase como fallback
      correo: userApi.email,
      password: '', // No tenemos password en CompleteUserModel
      tipoUsuario: userApi.tipoUsuario ?? TipoUsuario.alumno, // Usar tipoUsuario directamente
      createdAt: userApi.apiCreatedAt ?? userApi.createdAt ?? DateTime.now(),
      updatedAt: userApi.apiUpdatedAt ?? DateTime.now(),
      deletedAt: null,
    );
  }
}

final authRepositoryImplProvider = Provider<AuthRepositoryImpl>((ref) {
  // Crear un AuthService temporal para que compile
  final authService = AuthService(null as dynamic); // Temporal
  return AuthRepositoryImpl(authService);
});