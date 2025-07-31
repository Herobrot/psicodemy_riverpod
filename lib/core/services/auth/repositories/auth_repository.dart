import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/complete_user_model.dart';
import '../models/firebase_auth_response.dart';
import '../models/user_api_model.dart';
import '../providers/firebase_auth_provider.dart';
import '../providers/google_sign_in_provider.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/auth_failure.dart';
import 'secure_storage_repository.dart';
import '../../api_service.dart';
import '../../api_service_provider.dart';
import '../../../constants/timeout_config.dart';

abstract class AuthRepository {
  Future<CompleteUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<CompleteUserModel> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? codigoTutor,
  });
  Future<CompleteUserModel> signInWithGoogle();
  Future<void> signOut();
  Future<CompleteUserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Stream<CompleteUserModel?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final SecureStorageRepository _secureStorage;
  final ApiService _apiService;

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._secureStorage,
    this._apiService,
  );

  @override
  Future<CompleteUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // 1. Iniciar sesión con Firebase
      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(TimeoutConfig.firebaseAuth);

      if (userCredential.user == null) {
        throw AuthFailure.unknown(
          'Usuario no encontrado después del inicio de sesión',
        );
      }

      // 2. Obtener token de Firebase
      final firebaseToken = await userCredential.user!.getIdToken().timeout(
        TimeoutConfig.firebaseToken,
      );

      // 🔍 DEBUG: Imprimir token de Firebase

      // 3. Autenticar en la API del backend
      if (firebaseToken == null) {
        throw AuthFailure.serverError('Firebase token is null');
      }

      final response = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre: userCredential.user!.displayName ?? email.split('@')[0],
        correo: email,
      );

      if (response['data'] == null) {
        throw AuthFailure.unknown(
          'Usuario no encontrado después del inicio de sesión',
        );
      }

      final user = CompleteUserModel.fromApiResponse(
        response['data'],
        UserModel.fromFirebaseUser(userCredential.user!),
      );

      await _storeUserSession(user).timeout(TimeoutConfig.storage);

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unknown('Error al iniciar sesión');
    }
  }

  @override
  Future<CompleteUserModel> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? codigoTutor,
  }) async {
    try {
      // 1. Crear usuario en Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthFailure.unknown(
          'Usuario no creado correctamente en Firebase',
        );
      }

      final firebaseUser = UserModel.fromFirebaseUser(userCredential.user!);

      // 2. Obtener token de Firebase
      final firebaseToken = await userCredential.user!.getIdToken();

      // 🔍 DEBUG: Imprimir token de Firebase

      // 3. Registrar en la API del backend
      if (firebaseToken == null) {
        throw AuthFailure.serverError('Firebase token is null');
      }
      final apiResponse = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre: firebaseUser.displayName ?? email.split('@')[0],
        correo: email,
        codigoTutor: codigoTutor,
      );

      final firebaseAuthResponse = FirebaseAuthResponse.fromJson(apiResponse);

      // 4. Crear modelo completo del usuario
      final completeUser = CompleteUserModel.fromFirebaseAuthResponse(
        firebaseUser,
        firebaseAuthResponse,
      );

      await _storeUserSession(completeUser);
      return completeUser;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error al crear usuario'),
      );
    }
  }

  @override
  Future<CompleteUserModel> signInWithGoogle() async {
    try {
      // 1. Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw AuthFailure.googleSignInCancelled(
          'El usuario canceló el inicio de sesión',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw AuthFailure.unknown(
          'Usuario no encontrado después del inicio de sesión con Google',
        );
      }

      final firebaseUser = UserModel.fromFirebaseUser(userCredential.user!);

      // 2. Obtener token de Firebase
      final firebaseToken = await userCredential.user!.getIdToken();

      // 🔍 DEBUG: Imprimir token de Firebase

      // 3. Autenticar/Registrar en la API del backend
      if (firebaseToken == null) {
        throw AuthFailure.serverError('Firebase token is null');
      }

      final apiResponse = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre:
            firebaseUser.displayName ??
            googleUser.displayName ??
            firebaseUser.email.split('@')[0],
        correo: firebaseUser.email,
      );

      final firebaseAuthResponse = FirebaseAuthResponse.fromJson(apiResponse);

      // 4. Crear modelo completo del usuario
      final completeUser = CompleteUserModel.fromFirebaseAuthResponse(
        firebaseUser,
        firebaseAuthResponse,
      );

      await _storeUserSession(completeUser);

      return completeUser;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthExceptions.handleGoogleSignInException(
        Exception('Error al iniciar sesión con Google'),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _secureStorage.clearAll(),
      ]);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error al cerrar sesión'),
      );
    }
  }

  @override
  Future<CompleteUserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        final userModel = UserModel.fromFirebaseUser(firebaseUser);

        // Intentar obtener datos adicionales del storage
        final savedUserData = await _secureStorage.read('complete_user_data');

        if (savedUserData != null) {
          try {
            final userData = CompleteUserModel.fromJson(savedUserData);
            // Validar que el UID del usuario actual coincida con el del storage
            if (userData.uid != firebaseUser.uid) {
              // Forzar obtención de datos completos desde la API
              try {
                final firebaseToken = await firebaseUser.getIdToken();
                if (firebaseToken == null) {
                  final completeUser = CompleteUserModel.fromFirebaseUser(
                    userModel,
                  );
                  return completeUser;
                }
                final apiResponse = await _apiService.authenticateWithFirebase(
                  firebaseToken: firebaseToken,
                  nombre:
                      userModel.displayName ??
                      firebaseUser.email?.split('@')[0] ??
                      '',
                  correo: firebaseUser.email ?? '',
                  codigoTutor: null,
                );
                final firebaseAuthResponse = FirebaseAuthResponse.fromJson(
                  apiResponse,
                );
                final completeUser = CompleteUserModel.fromFirebaseAuthResponse(
                  userModel,
                  firebaseAuthResponse,
                );
                await _storeUserSession(completeUser);
                return completeUser;
              } catch (tokenError) {
                final completeUser = CompleteUserModel.fromFirebaseUser(
                  userModel,
                );
                return completeUser;
              }
            }
            return userData;
          } catch (_) {
            final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
            return completeUser;
          }
        }
        // Si no hay datos en storage, devolver solo datos de Firebase
        final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
        return completeUser;
      }
      return null;
    } on AuthFailure {
      rethrow;
    } catch (_) {
      try {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null) {
          final userModel = UserModel.fromFirebaseUser(firebaseUser);
          final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
          return completeUser;
        }
      } catch (_) {
        throw AuthExceptions.handleGenericException(
          Exception('Error al obtener el usuario actual'),
        );
      }
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error al enviar el correo de restablecimiento'),
      );
    }
  }

  @override
  Stream<CompleteUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser != null) {
        final userModel = UserModel.fromFirebaseUser(firebaseUser);

        // Intentar obtener datos adicionales del storage
        final savedUserData = await _secureStorage.read('complete_user_data');

        if (savedUserData != null) {
          try {
            final userData = CompleteUserModel.fromJson(savedUserData);
            return userData;
          } catch (_) {
            // Si no se puede deserializar, devolver solo datos de Firebase
            return CompleteUserModel.fromFirebaseUser(userModel);
          }
        }
        return CompleteUserModel.fromFirebaseUser(userModel);
      }

      return null;
    });
  }

  Future<void> _storeUserSession(dynamic user) async {
    try {
      String userId;
      Map<String, dynamic>? userData;

      if (user is UserModel) {
        userId = user.uid; // Firebase user (no tiene userId de API)
      } else if (user is UserApiModel) {
        userId = user.userId; // API user - usar el userId de la API ✅
      } else if (user is CompleteUserModel) {
        // CORRECCIÓN: usar el userId de la API si está disponible, sino el UID de Firebase
        userId = user.userId ?? user.uid; // Priorizar userId de API ✅
        userData = user.toJson();
      } else {
        throw ArgumentError('Tipo de usuario no válido');
      }

      await _secureStorage.storeToken('user_session', userId);

      // Guardar datos completos del usuario si están disponibles
      if (userData != null) {
        await _secureStorage.storeData('complete_user_data', userData);
      }
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error al almacenar la sesión del usuario'),
      );
    }
  }
}

// Provider simple para AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  final secureStorage = ref.watch(secureStorageRepositoryProvider);
  final apiService = ref.watch(apiServiceProvider);

  return AuthRepositoryImpl(
    firebaseAuth,
    googleSignIn,
    secureStorage,
    apiService,
  );
});
