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
  Future<CompleteUserModel> signInWithEmailAndPassword(String email, String password);
  Future<CompleteUserModel> signUpWithEmailAndPassword(String email, String password, {String? codigoTutor});
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
  Future<CompleteUserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      // 1. Iniciar sesión con Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(TimeoutConfig.firebaseAuth);
      
      if (userCredential.user == null) {
        throw AuthFailure.unknown('Usuario no encontrado después del inicio de sesión');
      }

      // 2. Obtener token de Firebase
      final firebaseToken = await userCredential.user!.getIdToken().timeout(TimeoutConfig.firebaseToken);
      
      // 🔍 DEBUG: Imprimir token de Firebase
      print('🔥 FIREBASE TOKEN (Sign In):');
      print('Token length: ${firebaseToken?.length ?? 0}');
      print('Token: $firebaseToken');
      print('User UID: ${userCredential.user!.uid}');
      print('User Email: ${userCredential.user!.email}');
      print('---');
      
      // 3. Autenticar en la API del backend
      if (firebaseToken == null) {
        throw AuthFailure.serverError('Firebase token is null');
      }
      
      final response = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre: userCredential.user!.displayName ?? email.split('@')[0],
        correo: email
      );

      print('📡 AuthRepository: Respuesta de API recibida');
      print('📡 Response keys: ${response.keys.toList()}');
      print('📡 User data: ${response['data']}');

      if (response['data'] == null) {
        print('❌ AuthRepository: Usuario no encontrado en la respuesta');
        throw AuthFailure.unknown('Usuario no encontrado después del inicio de sesión');
      }

      print('✅ AuthRepository: Creando CompleteUserModel');
      final user = CompleteUserModel.fromApiResponse(response['data'], UserModel.fromFirebaseUser(userCredential.user!));
      print('✅ AuthRepository: Usuario creado: ${user.toString()}');
      
      print('💾 AuthRepository: Guardando sesión de usuario');
      await _storeUserSession(user).timeout(TimeoutConfig.storage);
      print('✅ AuthRepository: Sesión guardada exitosamente');
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      print('❌ AuthRepository: Error en signInWithEmailAndPassword');
      print('❌ Error tipo: ${e.runtimeType}');
      print('❌ Error mensaje: $e');
      
      if (e is AuthFailure) {
        print('❌ Es un AuthFailure, re-lanzando');
        rethrow;
      }
      
      print('❌ Convirtiendo a AuthFailure.unknown');
      throw AuthFailure.unknown(e.toString());
    }
  }

  @override
  Future<CompleteUserModel> signUpWithEmailAndPassword(String email, String password, {String? codigoTutor}) async {
    try {
      // 1. Crear usuario en Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw AuthFailure.unknown('Usuario no creado correctamente en Firebase');
      }

      final firebaseUser = UserModel.fromFirebaseUser(userCredential.user!);
      
      // 2. Obtener token de Firebase
      final firebaseToken = await userCredential.user!.getIdToken();
      
      // 🔍 DEBUG: Imprimir token de Firebase
      print('🔥 FIREBASE TOKEN (Sign Up):');
      print('Token length: ${firebaseToken?.length ?? 0}');
      print('Token: $firebaseToken');
      print('User UID: ${userCredential.user!.uid}');
      print('User Email: ${userCredential.user!.email}');
      print('---');
      
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
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }

  @override
  Future<CompleteUserModel> signInWithGoogle() async {
    try {
      print('🔐 AuthRepository: Iniciando proceso de Google Sign In...');
      
      // 1. Iniciar sesión con Google
      print('🔐 AuthRepository: Llamando a _googleSignIn.signIn()...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ AuthRepository: Usuario canceló el inicio de sesión con Google');
        throw AuthFailure.googleSignInCancelled('El usuario canceló el inicio de sesión');
      }

      print('✅ AuthRepository: Google Sign In exitoso');
      print('🔍 Google User: ${googleUser.displayName} (${googleUser.email})');
      
      print('🔐 AuthRepository: Obteniendo autenticación de Google...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('✅ AuthRepository: Autenticación de Google obtenida');
      print('🔍 Access Token: ${googleAuth.accessToken?.substring(0, 20)}...');
      print('🔍 ID Token: ${googleAuth.idToken?.substring(0, 20)}...');

      print('🔐 AuthRepository: Creando credencial de Firebase...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔐 AuthRepository: Iniciando sesión en Firebase con credencial...');
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        print('❌ AuthRepository: Usuario no encontrado después del inicio de sesión con Google');
        throw AuthFailure.unknown('Usuario no encontrado después del inicio de sesión con Google');
      }

      print('✅ AuthRepository: Firebase Sign In exitoso');
      final firebaseUser = UserModel.fromFirebaseUser(userCredential.user!);
      print('🔍 Firebase User: ${firebaseUser.displayName} (${firebaseUser.email})');
      
      // 2. Obtener token de Firebase
      print('🔐 AuthRepository: Obteniendo token de Firebase...');
      final firebaseToken = await userCredential.user!.getIdToken();
      
      // 🔍 DEBUG: Imprimir token de Firebase
      print('🔥 FIREBASE TOKEN (Google Sign In):');
      print('Token length: ${firebaseToken?.length ?? 0}');
      print('Token: $firebaseToken');
      print('User UID: ${userCredential.user!.uid}');
      print('User Email: ${userCredential.user!.email}');
      print('Google Access Token: ${googleAuth.accessToken}');
      print('Google ID Token: ${googleAuth.idToken}');
      print('---');
      
      // 3. Autenticar/Registrar en la API del backend
      if (firebaseToken == null) {
        print('❌ AuthRepository: Firebase token es null');
        throw AuthFailure.serverError('Firebase token is null');
      }
      
      print('🔐 AuthRepository: Autenticando con la API del backend...');
      final apiResponse = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre: firebaseUser.displayName ?? googleUser.displayName ?? firebaseUser.email.split('@')[0],
        correo: firebaseUser.email      
      );

      print('✅ AuthRepository: API response recibida');
      print('📡 API Response keys: ${apiResponse.keys.toList()}');

      final firebaseAuthResponse = FirebaseAuthResponse.fromJson(apiResponse);
      
      // 4. Crear modelo completo del usuario
      print('🔐 AuthRepository: Creando CompleteUserModel...');
      final completeUser = CompleteUserModel.fromFirebaseAuthResponse(
        firebaseUser,
        firebaseAuthResponse,
      );
      
      print('✅ AuthRepository: CompleteUserModel creado');
      print('🔍 Complete User: ${completeUser.nombre} (${completeUser.email}) - Tipo: ${completeUser.tipoUsuario}');
      
      print('💾 AuthRepository: Guardando sesión de usuario...');
      await _storeUserSession(completeUser);
      print('✅ AuthRepository: Sesión guardada exitosamente');
      
      return completeUser;
    } on FirebaseAuthException catch (e) {
      print('❌ AuthRepository: FirebaseAuthException en signInWithGoogle');
      print('❌ Error code: ${e.code}');
      print('❌ Error message: ${e.message}');
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      print('❌ AuthRepository: Error genérico en signInWithGoogle');
      print('❌ Error tipo: ${e.runtimeType}');
      print('❌ Error mensaje: $e');
      
      if (e is AuthFailure) {
        print('❌ Es un AuthFailure, re-lanzando');
        rethrow;
      }
      
      print('❌ Convirtiendo a AuthFailure.googleSignInFailed');
      throw AuthExceptions.handleGoogleSignInException(Exception(e.toString()));
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
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }

  @override
  Future<CompleteUserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        final userModel = UserModel.fromFirebaseUser(firebaseUser);
        print('🔍 === OBTENIENDO USUARIO ACTUAL ===');
        print('Firebase UID: ${firebaseUser.uid}');
        print('Firebase Email: ${firebaseUser.email}');

        // Intentar obtener datos adicionales del storage
        final savedUserData = await _secureStorage.read('complete_user_data');
        print('¿Hay datos guardados en storage?: ${savedUserData != null}');

        if (savedUserData != null) {
          try {
            final userData = CompleteUserModel.fromJson(savedUserData);
            // Validar que el UID del usuario actual coincida con el del storage
            if (userData.uid != firebaseUser.uid) {
              print('❌ UID de storage no coincide con el usuario actual. Ignorando datos guardados.');
              // Forzar obtención de datos completos desde la API
              try {
                final firebaseToken = await firebaseUser.getIdToken();
                if (firebaseToken == null) {
                  print('❌ No se pudo obtener el token de Firebase.');
                  final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
                  print('Devolviendo solo datos de Firebase');
                  print('=====================================');
                  return completeUser;
                }
                final apiResponse = await _apiService.authenticateWithFirebase(
                  firebaseToken: firebaseToken,
                  nombre: userModel.displayName ?? firebaseUser.email?.split('@')[0] ?? '',
                  correo: firebaseUser.email ?? '',
                  codigoTutor: null,
                );
                final firebaseAuthResponse = FirebaseAuthResponse.fromJson(apiResponse);
                final completeUser = CompleteUserModel.fromFirebaseAuthResponse(
                  userModel,
                  firebaseAuthResponse,
                );
                await _storeUserSession(completeUser);
                print('✅ Usuario actualizado desde la API tras cambio de cuenta.');
                print('=====================================');
                return completeUser;
              } catch (tokenError) {
                print('❌ Error obteniendo token de Firebase: $tokenError');
                print('🔍 Usando datos de Firebase como fallback debido a error de conectividad');
                final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
                print('Devolviendo solo datos de Firebase');
                print('=====================================');
                return completeUser;
              }
            }
            print('Datos recuperados del storage:');
            print('  - UID Firebase: ${userData.uid}');
            print('  - UserID API: ${userData.userId}');
            print('  - Email: ${userData.email}');
            print('  - Nombre: ${userData.nombre}');
            print('  - Tipo: ${userData.tipoUsuario}');
            print('=====================================');
            return userData;
          } catch (e) {
            print('❌ Error al deserializar datos: $e');
            // Si no se puede deserializar, devolver solo datos de Firebase
            final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
            print('Devolviendo solo datos de Firebase');
            print('=====================================');
            return completeUser;
          }
        }
        // Si no hay datos en storage, devolver solo datos de Firebase
        final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
        print('No hay datos en storage - usando solo Firebase');
        print('=====================================');
        return completeUser;
      }
      print('🔍 No hay usuario en Firebase Auth');
      return null;
    } catch (e) {
      print('❌ Error general en getCurrentUser: $e');
      // En lugar de lanzar una excepción, intentar devolver datos básicos de Firebase
      try {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null) {
          final userModel = UserModel.fromFirebaseUser(firebaseUser);
          final completeUser = CompleteUserModel.fromFirebaseUser(userModel);
          print('🔍 Devolviendo datos básicos de Firebase como fallback');
          return completeUser;
        }
      } catch (fallbackError) {
        print('❌ Error en fallback de getCurrentUser: $fallbackError');
      }
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }

  @override
  Stream<CompleteUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      try {
        print('🔍 AuthRepository: authStateChanges - Firebase user: ${firebaseUser?.email ?? 'null'}');
        
        if (firebaseUser != null) {
          final userModel = UserModel.fromFirebaseUser(firebaseUser);
          
          // Intentar obtener datos adicionales del storage
          Map<String, dynamic>? savedUserData;
          try {
            savedUserData = await _secureStorage.read('complete_user_data');
            print('🔍 AuthRepository: authStateChanges - ¿Hay datos guardados?: ${savedUserData != null}');
          } catch (storageError) {
            print('❌ AuthRepository: authStateChanges - Error reading storage: $storageError');
            // Continue without stored data
          }
          
          if (savedUserData != null) {
            try {
              final userData = CompleteUserModel.fromJson(savedUserData);
              print('🔍 AuthRepository: authStateChanges - Usuario completo recuperado: ${userData.nombre} (${userData.tipoUsuario})');
              return userData;
            } catch (e) {
              print('❌ AuthRepository: authStateChanges - Error al deserializar datos guardados: $e');
              // Si no se puede deserializar, devolver solo datos de Firebase
              try {
                return CompleteUserModel.fromFirebaseUser(userModel);
              } catch (fallbackError) {
                print('❌ AuthRepository: authStateChanges - Error en fallback: $fallbackError');
                return null;
              }
            }
          }
          
          print('🔍 AuthRepository: authStateChanges - No hay datos guardados, usando solo Firebase');
          try {
            return CompleteUserModel.fromFirebaseUser(userModel);
          } catch (fallbackError) {
            print('❌ AuthRepository: authStateChanges - Error creando CompleteUserModel: $fallbackError');
            return null;
          }
        }
        
        print('🔍 AuthRepository: authStateChanges - Usuario null (logout)');
        return null;
      } catch (e) {
        print('❌ AuthRepository: authStateChanges - Error general: $e');
        // Return null instead of crashing
        return null;
      }
    }).handleError((error) {
      print('❌ AuthRepository: authStateChanges - Stream error: $error');
      // Return null instead of crashing the stream
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

      // 🔍 DEBUG: Imprimir lo que se está guardando
      print('🔍 === GUARDANDO SESIÓN DE USUARIO ===');
      print('Tipo de usuario: ${user.runtimeType}');
      print('UserID guardado en storage: $userId');
      if (user is UserApiModel) {
        print('UserID de API: ${user.userId}');
        print('Email de API: ${user.email}');
        print('Nombre de API: ${user.nombre}');
        print('Tipo de API: ${user.userType}');
      } else if (user is CompleteUserModel) {
        print('UID Firebase: ${user.uid}');
        print('UserID API: ${user.userId}');
        print('Email: ${user.email}');
        print('Nombre: ${user.nombre}');
        print('Tipo: ${user.tipoUsuario}');
        print('¿Usando userId de API?: ${user.userId != null}');
      }
      print('==================================');

      await _secureStorage.storeToken('user_session', userId);
      
      // Guardar datos completos del usuario si están disponibles
      if (userData != null) {
        await _secureStorage.storeData('complete_user_data', userData);
      }
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }
}

// Provider simple para AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  final secureStorage = ref.watch(secureStorageRepositoryProvider);
  final apiService = ref.watch(apiServiceProvider);
  
  return AuthRepositoryImpl(firebaseAuth, googleSignIn, secureStorage, apiService);
});