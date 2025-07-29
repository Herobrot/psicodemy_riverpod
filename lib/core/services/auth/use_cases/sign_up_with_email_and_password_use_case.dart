import 'package:psicodemy/core/services/auth/models/complete_user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  SignUpWithEmailAndPasswordUseCase(this._authRepository);

  Future<CompleteUserModel> call(String email, String password) async {
    try {
      return await _authRepository.signUpWithEmailAndPassword(email, password);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unknown('Error al crear usuario');
    }
  }
}

final signUpWithEmailAndPasswordUseCaseProvider =
    Provider<SignUpWithEmailAndPasswordUseCase>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return SignUpWithEmailAndPasswordUseCase(authRepository);
    });
