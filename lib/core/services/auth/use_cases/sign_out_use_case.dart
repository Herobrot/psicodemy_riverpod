import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

part 'sign_out_use_case.g.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    try {
      await _authRepository.signOut();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

@riverpod
SignOutUseCase signOutUseCase (Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
}