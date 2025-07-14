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

abstract class AuthRepository {
  Future<CompleteUserModel> signInWithEmailAndPassword(String email, String password, {String? codigoTutor});
  Future<CompleteUserModel> signUpWithEmailAndPassword(String email, String password, {String? codigoTutor});
  Future<CompleteUserModel> signInWithGoogle({String? codigoTutor});
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
  Future<CompleteUserModel> signInWithEmailAndPassword(String email, String password, {String? codigoTutor}) async {
    try {
      print('🔐 AuthRepository: Iniciando autenticación con credenciales');
      print('📧 Email: $email');
      print('🔑 Código tutor: $codigoTutor');
      
      final response = await _apiService.authenticateWithCredentials(
        correo: email,
        password: password,
        codigoTutor: codigoTutor,
      );

      print('📡 AuthRepository: Respuesta de API recibida');
      print('📡 Response keys: ${response.keys.toList()}');
      print('📡 User data: ${response['user']}');

      if (response['user'] == null) {
        print('❌ AuthRepository: Usuario no encontrado en la respuesta');
        throw AuthFailure.unknown('Usuario no encontrado después del inicio de sesión');
      }

      print('✅ AuthRepository: Creando CompleteUserModel');
      final user = CompleteUserModel.fromJson(response['user']);
      print('✅ AuthRepository: Usuario creado: ${user.toString()}');
      
      print('💾 AuthRepository: Guardando sesión de usuario');
      await _storeUserSession(user);
      print('✅ AuthRepository: Sesión guardada exitosamente');
      
      return user;
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
  Future<CompleteUserModel> signInWithGoogle({String? codigoTutor}) async {
    try {
      // 1. Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw AuthFailure.googleSignInCancelled('El usuario canceló el inicio de sesión');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw AuthFailure.unknown('Usuario no encontrado después del inicio de sesión con Google');
      }

      final firebaseUser = UserModel.fromFirebaseUser(userCredential.user!);
      
      // 2. Obtener token de Firebase
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
        throw AuthFailure.serverError('Firebase token is null');
      }
      final apiResponse = await _apiService.authenticateWithFirebase(
        firebaseToken: firebaseToken,
        nombre: firebaseUser.displayName ?? googleUser.displayName ?? firebaseUser.email.split('@')[0],
        correo: firebaseUser.email,
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
        
        // Intentar obtener datos adicionales del storage
        final savedUserData = await _secureStorage.read('complete_user_data');
        if (savedUserData != null) {
          try {
            final userData = CompleteUserModel.fromJson(savedUserData);
            return userData;
          } catch (e) {
            // Si no se puede deserializar, devolver solo datos de Firebase
            return CompleteUserModel.fromFirebaseUser(userModel);
          }
        }
        
        return CompleteUserModel.fromFirebaseUser(userModel);
      }
      return null;
    } catch (e) {
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
      if (firebaseUser != null) {
        final userModel = UserModel.fromFirebaseUser(firebaseUser);
        
        // Intentar obtener datos adicionales del storage
        final savedUserData = await _secureStorage.read('complete_user_data');
        if (savedUserData != null) {
          try {
            final userData = CompleteUserModel.fromJson(savedUserData);
            return userData;
          } catch (e) {
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
        userId = user.uid; // Firebase user
      } else if (user is UserApiModel) {
        userId = user.userId; // API user
      } else if (user is CompleteUserModel) {
        userId = user.uid; // Complete user
        userData = user.toJson();
      } else {
        throw ArgumentError('Tipo de usuario no válido');
      }

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