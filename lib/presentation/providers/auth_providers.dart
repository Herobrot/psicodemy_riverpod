import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_firebase_entity.dart';
import '../state_notifiers/auth_state_notifier.dart';
import '../state_notifiers/auth_state.dart';

final authErrorMessageProvider = Provider<String?>((ref) {
  final state = ref.watch(authStateNotifierProvider);
  return state.maybeWhen(error: (msg) => msg, orElse: () => null);
});

final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authStateNotifierProvider);
});

final loginStateProvider = Provider<LoginState>((ref) {
  return ref.watch(loginStateNotifierProvider);
});

final currentUserProvider = Provider<UserFirebaseEntity?>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  final loginState = ref.watch(loginStateNotifierProvider);
  
  return authState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  ) || loginState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});