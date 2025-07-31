import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth/models/complete_user_model.dart';
import '../../core/constants/enums/tipo_usuario.dart';
import '../../core/services/auth/repositories/auth_repository.dart';
import '../../core/services/auth/providers/firebase_auth_provider.dart';

// Provider para el stream de cambios de autenticación
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

// Provider que indica si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final completeUserAsync = ref.watch(currentCompleteUserProvider);

  // Solo considerar autenticado si tanto Firebase como el usuario completo están disponibles
  final firebaseAuth = authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );

  final completeUserAuth = completeUserAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );

  final isAuthenticated = firebaseAuth && completeUserAuth;

  return isAuthenticated;
});

// Provider que indica si hay loading en autenticación
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final completeUserAsync = ref.watch(currentCompleteUserProvider);

  // Considerar loading si cualquiera de los dos streams está cargando
  final isLoading = authState.isLoading || completeUserAsync.isLoading;

  return isLoading;
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

// Provider para el CompleteUserModel actual
final currentCompleteUserProvider = StreamProvider<CompleteUserModel?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges;
});

// Provider para el tipo de usuario actual
final currentUserTypeProvider = Provider<TipoUsuario?>((ref) {
  final completeUserAsync = ref.watch(currentCompleteUserProvider);
  final userType = completeUserAsync.when(
    data: (completeUser) {
      return completeUser?.tipoUsuario;
    },
    loading: () {
      return null;
    },
    error: (error, _) {
      return null;
    },
  );
  return userType;
});

// Provider para verificar si el usuario es tutor
final isTutorProvider = Provider<bool>((ref) {
  final userType = ref.watch(currentUserTypeProvider);
  final isTutor = userType == TipoUsuario.tutor;
  return isTutor;
});

// Provider para verificar si el usuario es alumno
final isAlumnoProvider = Provider<bool>((ref) {
  final userType = ref.watch(currentUserTypeProvider);
  final isAlumno = userType == TipoUsuario.alumno;
  return isAlumno;
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

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final firebaseAuth = _ref.read(firebaseAuthProvider);
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
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
