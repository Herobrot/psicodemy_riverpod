import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository _authRepository;

  SendPasswordResetEmailUseCase(this._authRepository);

  Future<void> call(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unknown(
        'Error al enviar el correo de restablecimiento',
      );
    }
  }
}

final sendPasswordResetEmailUseCaseProvider =
    Provider<SendPasswordResetEmailUseCase>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return SendPasswordResetEmailUseCase(authRepository);
    });
