import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:psicodemy/core/services/auth/models/complete_user_model.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<CompleteUserModel> call() async {
    try {
      return await _authRepository.signInWithGoogle();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInWithGoogleUseCase(authRepository);
});
