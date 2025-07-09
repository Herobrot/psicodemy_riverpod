import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/firebase_user_model.dart';
import '../repositories/auth_repository.dart';
import '../exceptions/auth_failure.dart';

part 'sign_in_with_google_use_case.g.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<UserModel> call() async {
    try {
      return await _authRepository.signInWithGoogle();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }
}

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInWithGoogleUseCase(authRepository);
}