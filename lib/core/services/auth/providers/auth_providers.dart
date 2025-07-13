import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/firebase_auth_state.dart';
import '../models/firebase_user_model.dart';
import '../models/complete_user_model.dart';
import '../auth_service.dart';
import '../exceptions/auth_failure.dart';

// StateNotifier para manejar el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(FirebaseUserModel.fromCompleteUser(user));
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password, {String? codigoInstitucion}) async {
    state = const AuthState.loading();
    
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      state = AuthState.authenticated(FirebaseUserModel.fromCompleteUser(user));
    } on AuthFailure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, {String? codigoInstitucion}) async {
    state = const AuthState.loading();
    
    try {
      final user = await _authService.signUpWithEmailAndPassword(email, password);
      state = AuthState.authenticated(FirebaseUserModel.fromCompleteUser(user));
    } on AuthFailure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signInWithGoogle({String? codigoInstitucion}) async {
    state = const AuthState.loading();
    
    try {
      final user = await _authService.signInWithGoogle();
      state = AuthState.authenticated(FirebaseUserModel.fromCompleteUser(user));
    } on AuthFailure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(FirebaseUserModel.fromCompleteUser(user));
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }
}

// Provider para AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Providers derivados para facilidad de uso
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

final currentUserProvider = Provider<FirebaseUserModel?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    error: (failure) => failure.message,
    orElse: () => null,
  );
});