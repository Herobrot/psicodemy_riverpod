import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_firebase_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';

// part 'auth_use_cases.g.dart';

class AuthUseCases {
  final AuthRepositoryInterface _authRepository;

  AuthUseCases(this._authRepository);

  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email y contraseña son requeridos');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email no válido');
    }

    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    if (!_isValidPassword(password)) {
      throw Exception(
        'La contraseña no debe contener caracteres especiales (@, #, \$, %, &, !, etc.)',
      );
    }

    return await _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<UserFirebaseEntity> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email y contraseña son requeridos');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email no válido');
    }

    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    if (!_isValidPassword(password)) {
      throw Exception(
        'La contraseña no debe contener caracteres especiales (@, #, \$, %, &, !, etc.)',
      );
    }

    return await _authRepository.signUpWithEmailAndPassword(email, password);
  }

  Future<UserFirebaseEntity> signInWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<UserFirebaseEntity?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw Exception('Email es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Email no válido');
    }

    await _authRepository.sendPasswordResetEmail(email);
  }

  Stream<UserFirebaseEntity?> get authStateChanges =>
      _authRepository.authStateChanges;

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password);
  }
}

final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  final authRepository = ref.watch(authRepositoryImplProvider);
  return AuthUseCases(authRepository);
});
