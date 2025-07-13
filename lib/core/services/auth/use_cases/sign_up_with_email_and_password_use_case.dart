import 'package:psicodemy/core/services/auth/models/firebase_user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  SignUpWithEmailAndPasswordUseCase(this._authRepository);

  Future<UserModel> call(String email, String password) async {
    try {
      return await _authRepository.signUpWithEmailAndPassword(email, password);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

final signUpWithEmailAndPasswordUseCaseProvider = Provider<SignUpWithEmailAndPasswordUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignUpWithEmailAndPasswordUseCase(authRepository);
});

