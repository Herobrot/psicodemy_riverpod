import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/use_cases/auth_use_cases.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthUseCases _authUseCases;

  AuthStateNotifier(this._authUseCases) : super(AuthState.initial()) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final user = await _authUseCases.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = AuthState.loading();
      // signInWithEmailAndPassword retorna UserEntity, no UserFirebaseEntity
      // Por ahora solo verificamos que la autenticación fue exitosa
      await _authUseCases.signInWithEmailAndPassword(email, password);
      // Después de un login exitoso, verificamos el usuario actual
      final currentUser = await _authUseCases.getCurrentUser();
      if (currentUser != null) {
        state = AuthState.authenticated(currentUser);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = AuthState.loading();
      final user = await _authUseCases.signInWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      state = AuthState.loading();
      final user = await _authUseCases.signUpWithEmailAndPassword(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authUseCases.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

class LoginStateNotifier extends StateNotifier<LoginState> {
  final AuthUseCases _authUseCases;

  LoginStateNotifier(this._authUseCases) : super(LoginState.initial());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = LoginState.loading();
      await _authUseCases.signInWithEmailAndPassword(email, password);
      state = LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = LoginState.loading();
      await _authUseCases.signInWithGoogle();
      state = LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      state = LoginState.loading();
      await _authUseCases.signUpWithEmailAndPassword(email, password);
      state = LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  void reset() {
    state = LoginState.initial();
  }
}

// Providers para los state notifiers
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authUseCases = ref.watch(authUseCasesProvider);
  return AuthStateNotifier(authUseCases);
});

final loginStateNotifierProvider = StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  final authUseCases = ref.watch(authUseCasesProvider);
  return LoginStateNotifier(authUseCases);
});