import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider básico para FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider para el stream de cambios de autenticación
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

// Provider que indica si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Provider que indica si hay loading en autenticación
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.isLoading;
});

// Provider para errores de autenticación
final authErrorMessageProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (_) => null,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
});

// Provider para el usuario actual
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Provider para acciones de autenticación
final authActionsProvider = Provider((ref) => AuthActions(ref));

class AuthActions {
  final Ref _ref;
  
  AuthActions(this._ref);
  
  Future<void> signOut() async {
    final firebaseAuth = _ref.read(firebaseAuthProvider);
    await firebaseAuth.signOut();
  }
  
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    final firebaseAuth = _ref.read(firebaseAuthProvider);
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    final firebaseAuth = _ref.read(firebaseAuthProvider);
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> sendPasswordResetEmail(String email) async {
    final firebaseAuth = _ref.read(firebaseAuthProvider);
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
} 