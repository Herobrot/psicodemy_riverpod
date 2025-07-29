import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psicodemy/presentation/state_notifiers/auth_state.dart';
import '../auth_service.dart';
import '../exceptions/auth_failure.dart';
import '../../../../domain/entities/user_firebase_entity.dart';

// Enum para los estados de autenticación
enum AuthStateStatus { initial, loading, authenticated, unauthenticated, error }

// StateNotifier para manejar el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authService.authStateChanges.listen((completeUser) {
      if (completeUser != null) {
        final userEntity = UserFirebaseEntity(
          uid: completeUser.uid,
          email: completeUser.email,
          displayName: completeUser.displayName ?? '',
          photoURL: completeUser.photoURL ?? '',
          isEmailVerified: completeUser.isEmailVerified,
        );
        state = AuthState.authenticated(userEntity);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password, {
    String? codigoInstitucion,
  }) async {
    state = AuthState.loading();

    try {
      final userApiModel = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      final userEntity = UserFirebaseEntity(
        uid: userApiModel.userId ?? userApiModel.uid,
        email: userApiModel.email,
        displayName: userApiModel.nombre,
        photoURL: '',
        isEmailVerified: true,
      );
      state = AuthState.authenticated(userEntity);
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message ?? 'Error de autenticación');
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? codigoInstitucion,
  }) async {
    state = AuthState.loading();

    try {
      final completeUser = await _authService.signUpWithEmailAndPassword(
        email,
        password,
      );
      final userEntity = UserFirebaseEntity(
        uid: completeUser.uid,
        email: completeUser.email,
        displayName: completeUser.displayName ?? '',
        photoURL: completeUser.photoURL ?? '',
        isEmailVerified: completeUser.isEmailVerified,
      );
      state = AuthState.authenticated(userEntity);
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message ?? 'Error de autenticación');
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }

  Future<void> signInWithGoogle({String? codigoInstitucion}) async {
    state = AuthState.loading();

    try {
      final completeUser = await _authService.signInWithGoogle();
      final userEntity = UserFirebaseEntity(
        uid: completeUser.uid,
        email: completeUser.email,
        displayName: completeUser.displayName ?? '',
        photoURL: completeUser.photoURL ?? '',
        isEmailVerified: completeUser.isEmailVerified,
      );
      state = AuthState.authenticated(userEntity);
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message ?? 'Error de autenticación');
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final completeUser = await _authService.getCurrentUser();
      if (completeUser != null) {
        final userEntity = UserFirebaseEntity(
          uid: completeUser.uid,
          email: completeUser.email,
          displayName: completeUser.displayName ?? '',
          photoURL: completeUser.photoURL ?? '',
          isEmailVerified: completeUser.isEmailVerified,
        );
        state = AuthState.authenticated(userEntity);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(
        AuthFailure.unknown(e.toString()).message ?? 'Error desconocido',
      );
    }
  }
}

// Provider para AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Providers derivados para facilidad de uso
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == 'authenticated';
});

final currentUserProvider = Provider<UserFirebaseEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == 'authenticated' ? authState.user : null;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == 'loading';
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status == 'error' ? authState.message : null;
});
