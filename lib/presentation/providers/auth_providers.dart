import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_firebase_entity.dart';
import '../state_notifiers/auth_state_notifier.dart';
import '../state_notifiers/auth_state.dart';

part 'auth_providers.g.dart';

@riverpod
String? authErrorMessage(Ref ref) {
  final state = ref.watch(authStateProvider);
  return state.maybeWhen(error: (msg) => msg, orElse: () => null);
}

// Provider que expone el estado de autenticación
@riverpod
AuthState authState(Ref ref) {
  return ref.watch(authStateNotifierProvider);
}

// Provider que expone el estado de login
@riverpod
LoginState loginState(Ref ref) {
  return ref.watch(loginStateNotifierProvider);
}

// Provider que expone el usuario actual (si está autenticado)
@riverpod
UserFirebaseEntity? currentUser(Ref ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.when(
    initial: () => null,
    loading: () => null,
    authenticated: (user) => user,
    unauthenticated: () => null,
    error: (message) => null,
  );
}

// Provider que indica si el usuario está autenticado
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.when(
    initial: () => false,
    loading: () => false,
    authenticated: (user) => true,
    unauthenticated: () => false,
    error: (message) => false,
  );
}

// Provider que indica si hay una operación de autenticación en progreso
@riverpod
bool isAuthLoading(Ref ref) {
  final authState = ref.watch(authStateNotifierProvider);
  final loginState = ref.watch(loginStateNotifierProvider);
  
  return authState.when(
    initial: () => false,
    loading: () => true,
    authenticated: (user) => false,
    unauthenticated: () => false,
    error: (message) => false,
  ) || loginState.when(
    initial: () => false,
    loading: () => true,
    success: () => false,
    error: (message) => false,
  );
}