import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_cases/auth_use_cases.dart';
import '../../domain/entities/user_firebase_entity.dart';
import 'auth_state.dart';
import 'dart:async';

part 'auth_state_notifier.g.dart';

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  StreamSubscription<UserFirebaseEntity?>? _authStateSubscription;

  @override
  AuthState build() {
    _listenToAuthState();
    return const AuthState.initial();
  }

  void _listenToAuthState() {
    final authUseCases = ref.watch(authUseCasesProvider);
    
    _authStateSubscription?.cancel();
    _authStateSubscription = authUseCases.authStateChanges.listen(
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
      onError: (error) {
        state = AuthState.error(error.toString());
      },
    );
  }

  Future<void> checkAuthStatus() async {
    try {
      state = const AuthState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      final user = await authUseCases.getCurrentUser();
      
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      await authUseCases.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void dispose() {
    _authStateSubscription?.cancel();
  }
}

@riverpod
class LoginStateNotifier extends _$LoginStateNotifier {
  @override
  LoginState build() {
    return const LoginState.initial();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = const LoginState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      await authUseCases.signInWithEmailAndPassword(email, password);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      state = const LoginState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      await authUseCases.signUpWithEmailAndPassword(email, password);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const LoginState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      await authUseCases.signInWithGoogle();
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = const LoginState.loading();
      final authUseCases = ref.watch(authUseCasesProvider);
      await authUseCases.sendPasswordResetEmail(email);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  void resetState() {
    state = const LoginState.initial();
  }
}