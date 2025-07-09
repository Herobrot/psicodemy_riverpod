import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';

part 'send_password_reset_email_use_case.g.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository _authRepository;

  SendPasswordResetEmailUseCase(this._authRepository);

  Future<void> call(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

@riverpod
SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase (Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SendPasswordResetEmailUseCase(authRepository);
}