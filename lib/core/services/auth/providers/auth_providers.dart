import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/firebase_auth_state.dart';
import '../models/firebase_user_model.dart';
import '../auth_service.dart';
import '../exceptions/auth_failure.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _listenToAuthChanges();
    return const AuthState.initial();
  }

  void _listenToAuthChanges() {
    final authService = ref.read(authServiceProvider);
    
    authService.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final user = await ref.read(authServiceProvider).signInWithEmailAndPassword(email, password);
      state = AuthState.authenticated(user);
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final user = await ref.read(authServiceProvider).signUpWithEmailAndPassword(email, password);
      state = AuthState.authenticated(user);
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    
    try {
      final user = await ref.read(authServiceProvider).signInWithGoogle();
      state = AuthState.authenticated(user);
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    
    try {
      await ref.read(authServiceProvider).signOut();
      state = const AuthState.unauthenticated();
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email);
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    
    try {
      final user = await ref.read(authServiceProvider).getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } on AuthFailure catch (failure) {
      state = AuthState.error(failure);
    } catch (e) {
      state = AuthState.error(AuthFailure.unknown(e.toString()));
    }
  }
}

@riverpod
UserModel? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
}

@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
}

@riverpod
bool isLoading(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
}