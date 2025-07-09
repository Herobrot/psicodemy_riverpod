import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/firebase_user_model.dart';
import 'models/user_model.dart';
import 'repositories/auth_repository.dart';

part 'auth_service.g.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<UserApiModel> signInWithEmailAndPassword(String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async {
    return await _authRepository.signUpWithEmailAndPassword(email, password);
  }

  Future<UserModel> signInWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authRepository.sendPasswordResetEmail(email);
  }

  Stream<UserModel?> get authStateChanges => _authRepository.authStateChanges;
}

@riverpod
AuthService authService(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository);
}