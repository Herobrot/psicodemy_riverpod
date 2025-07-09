import 'package:psicodemy/core/services/auth/models/firebase_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

part 'sign_up_with_email_and_password_use_case.g.dart';

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

@riverpod
SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignUpWithEmailAndPasswordUseCase(authRepository);
}

