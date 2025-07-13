import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';
import 'package:psicodemy/core/services/auth/models/firebase_user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<UserModel?> call() async {
    try {
      return await _authRepository.getCurrentUser();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
});