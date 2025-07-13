import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_cases/auth_use_cases.dart';
import '../../domain/entities/user_firebase_entity.dart';
import 'auth_state.dart';
import 'dart:async';

class AuthStateNotifier extends StateNotifier<AuthState> {
  StreamSubscription<UserFirebaseEntity?>? _authStateSubscription;
  final AuthUseCases _authUseCases;

  AuthStateNotifier(this._authUseCases) : super(const AuthState.initial()) {
    _listenToAuthState();
  }

  void _listenToAuthState() {
    try {
      _authStateSubscription = _authUseCases.authStateChanges.listen((user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      });
    } catch (error) {
      state = AuthState.error(error.toString());
    }
  }

  Future<void> getCurrentUser() async {
    try {
      state = const AuthState.loading();
      final user = await _authUseCases.getCurrentUser();
      
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
      await _authUseCases.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

class LoginStateNotifier extends StateNotifier<LoginState> {
  final AuthUseCases _authUseCases;

  LoginStateNotifier(this._authUseCases) : super(const LoginState.initial());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = const LoginState.loading();
      await _authUseCases.signInWithEmailAndPassword(email, password);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      state = const LoginState.loading();
      await _authUseCases.signUpWithEmailAndPassword(email, password);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      state = const LoginState.loading();
      await _authUseCases.signInWithGoogle();
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(e.toString());
    }
  }

  void reset() {
    state = const LoginState.initial();
  }
}

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authUseCases = ref.watch(authUseCasesProvider);
  return AuthStateNotifier(authUseCases);
});

final loginStateNotifierProvider = StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  final authUseCases = ref.watch(authUseCasesProvider);
  return LoginStateNotifier(authUseCases);
});