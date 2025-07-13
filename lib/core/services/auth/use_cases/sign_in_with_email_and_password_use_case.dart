import 'package:psicodemy/core/services/auth/models/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  SignInWithEmailAndPasswordUseCase(this._authRepository);

  Future<UserApiModel> call(String email, String password) async {
    try {
      return await _authRepository.signInWithEmailAndPassword(email, password);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

final signInWithEmailAndPasswordUseCaseProvider = Provider<SignInWithEmailAndPasswordUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInWithEmailAndPasswordUseCase(authRepository);
});