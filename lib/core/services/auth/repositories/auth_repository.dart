import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http_client;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/firebase_user_model.dart';
import '../models/user_model.dart';
import '../providers/firebase_auth_provider.dart';
import '../providers/google_sign_in_provider.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/auth_failure.dart';
import 'secure_storage_repository.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<UserApiModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Stream<UserModel?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final SecureStorageRepository _secureStorage;
  final String _baseUrl = 'https://api.rutasegura.xyz';

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._secureStorage,
  );

  @override
  Future<UserApiModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Preparar datos para envío a API
      final loginData = {
        'correo': email,
        'contraseña': password,
      };
  
      final response = await http_client.post(
        Uri.parse('$_baseUrl/auth/validate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(loginData),
      );
  
      // Verificar respuesta
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Verificar si la respuesta contiene datos del usuario
        if (responseData['user'] == null) {
          throw const AuthFailure.unknown('Usuario no encontrado después del inicio de sesión');
        }
  
        // Crear el modelo de usuario desde la respuesta de la API
        final user = UserApiModel.fromApiResponse(responseData['user']);
        
        // Almacenar token si lo proporciona la API
        if (responseData['token'] != null) {
          await _secureStorage.storeToken('token', responseData['token']);
        }
        
        // Almacenar sesión del usuario
        await _storeUserSession(user);
        
        return user;
      } else {
        // Manejar errores de la API
        final errorData = json.decode(response.body);
        throw AuthFailure.apiError(
          errorData['message'] ?? 'Error desconocido en el servidor'
        );
      }
    } on SocketException {
      throw const AuthFailure.network('Error de conexión a internet');
    } on FormatException {
      throw const AuthFailure.unknown('Respuesta inválida del servidor');
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure.unknown(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw const AuthFailure.unknown('Usuario no creado correctamente');
      }

      final user = UserModel.fromFirebaseUser(userCredential.user!);
      await _storeUserSession(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw const AuthFailure.googleSignInCancelled('El usuario canceló el inicio de sesión');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw const AuthFailure.unknown('Usuario no encontrado después del inicio de sesión con Google');
      }

      final user = UserModel.fromFirebaseUser(userCredential.user!);
      await _storeUserSession(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
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
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        return UserModel.fromFirebaseUser(firebaseUser);
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
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  Future<void> _storeUserSession(dynamic user) async {
    try {
      String userId;

      if (user is UserModel) {
        userId = user.uid; // Firebase user
      } else if (user is UserApiModel) {
        userId = user.id; // API user
      } else {
        throw ArgumentError('Tipo de usuario no válido');
      }

      await _secureStorage.storeToken('user_session', userId);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception(e.toString()));
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  final secureStorage = ref.watch(secureStorageRepositoryProvider);
  
  return AuthRepositoryImpl(firebaseAuth, googleSignIn, secureStorage);
}