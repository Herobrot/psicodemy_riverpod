import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/complete_user_model.dart';
import 'models/user_api_model.dart';
import 'repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<UserApiModel> signInWithEmailAndPassword(String email, String password, {String? codigoTutor}) async {
    return await _authRepository.signInWithEmailAndPassword(email, password, codigoTutor: codigoTutor);
  }

  Future<CompleteUserModel> signUpWithEmailAndPassword(String email, String password, {String? codigoTutor}) async {
    return await _authRepository.signUpWithEmailAndPassword(email, password, codigoTutor: codigoTutor);
  }

  Future<CompleteUserModel> signInWithGoogle({String? codigoTutor}) async {
    return await _authRepository.signInWithGoogle(codigoTutor: codigoTutor);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<CompleteUserModel?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authRepository.sendPasswordResetEmail(email);
  }

  Stream<CompleteUserModel?> get authStateChanges => _authRepository.authStateChanges;
}

// Provider simple para AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository);
});