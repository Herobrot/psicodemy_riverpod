import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';
import 'package:psicodemy/core/services/auth/models/firebase_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';

part 'get_current_user_use_case.g.dart';

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

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
}