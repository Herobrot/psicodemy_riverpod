import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/user_firebase_entity.dart';
import '../state_notifiers/auth_state_notifier.dart';
import '../state_notifiers/auth_state.dart';

final authErrorMessageProvider = Provider<String?>((ref) {
  final state = ref.watch(authStateNotifierProvider);
  return state.status == 'error' ? state.message : null;
});

final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authStateNotifierProvider);
});

final loginStateProvider = Provider<LoginState>((ref) {
  return ref.watch(loginStateNotifierProvider);
});

final currentUserProvider = Provider<UserFirebaseEntity?>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.status == 'authenticated' ? authState.user : null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.status == 'authenticated';
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  final loginState = ref.watch(loginStateNotifierProvider);

  return authState.status == 'loading' || loginState.status == 'loading';
});
