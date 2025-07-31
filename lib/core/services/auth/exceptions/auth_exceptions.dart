import 'package:firebase_auth/firebase_auth.dart';
import 'auth_failure.dart';

class AuthExceptions {
  static AuthFailure handleFirebaseAuthException(
    FirebaseAuthException exception,
  ) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthFailure.userNotFound('Usuario no encontrado');
      case 'wrong-password':
        return AuthFailure.wrongPassword('Contraseña incorrecta');
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse(
          'El correo electrónico ya está en uso',
        );
      case 'invalid-email':
        return AuthFailure.invalidEmail('El correo electrónico no es válido');
      case 'weak-password':
        return AuthFailure.weakPassword('La contraseña es demasiado débil');
      case 'user-disabled':
        return AuthFailure.userDisabled('El usuario está deshabilitado');
      case 'too-many-requests':
        return AuthFailure.tooManyRequests('Demasiadas solicitudes');
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed('Operación no permitida');
      case 'network-request-failed':
        return AuthFailure.networkError('Error de red');
      default:
        return AuthFailure.serverError('Error del servidor');
    }
  }

  static AuthFailure handleGoogleSignInException(Exception exception) {
    if (exception.toString().contains('sign_in_canceled')) {
      return AuthFailure.googleSignInCancelled(
        'El usuario canceló el inicio de sesión',
      );
    } else if (exception.toString().contains('network_error')) {
      return AuthFailure.networkError(
        'Error de red durante el inicio de sesión con Google',
      );
    } else {
      return AuthFailure.googleSignInFailed(
        'Error al iniciar sesión con Google',
      );
    }
  }

  static AuthFailure handleGenericException(Exception exception) {
    if (exception.toString().contains('storage')) {
      return AuthFailure.storageError('Error de almacenamiento');
    } else if (exception.toString().contains('network')) {
      return AuthFailure.networkError('Error de red');
    } else {
      return AuthFailure.unknown('Error desconocido');
    }
  }
}
