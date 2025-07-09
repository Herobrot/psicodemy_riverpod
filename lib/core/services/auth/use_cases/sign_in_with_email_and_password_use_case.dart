import 'package:psicodemy/core/services/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

part 'sign_in_with_email_and_password_use_case.g.dart';

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

@riverpod
SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInWithEmailAndPasswordUseCase(authRepository);
}