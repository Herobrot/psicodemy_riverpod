import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    try {
      await _authRepository.signOut();
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unknown('Error al cerrar sesión');
    }
  }
}

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
});
