import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';
import 'package:psicodemy/core/services/auth/models/complete_user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<CompleteUserModel?> call() async {
    try {
      return await _authRepository.getCurrentUser();
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unknown('Error al obtener el usuario actual');
    }
  }
}

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
});
