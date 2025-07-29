import 'package:firebase_auth/firebase_auth.dart';
import 'auth_failure.dart';

class AuthExceptions {
  static AuthFailure handleFirebaseAuthException(
    FirebaseAuthException exception,
  ) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthFailure.userNotFound(exception.message);
      case 'wrong-password':
        return AuthFailure.wrongPassword(exception.message);
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse(exception.message);
      case 'invalid-email':
        return AuthFailure.invalidEmail(exception.message);
      case 'weak-password':
        return AuthFailure.weakPassword(exception.message);
      case 'user-disabled':
        return AuthFailure.userDisabled(exception.message);
      case 'too-many-requests':
        return AuthFailure.tooManyRequests(exception.message);
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed(exception.message);
      case 'network-request-failed':
        return AuthFailure.networkError(exception.message);
      default:
        return AuthFailure.serverError(exception.message);
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
      return AuthFailure.googleSignInFailed(exception.toString());
    }
  }

  static AuthFailure handleGenericException(Exception exception) {
    if (exception.toString().contains('storage')) {
      return AuthFailure.storageError(exception.toString());
    } else if (exception.toString().contains('network')) {
      return AuthFailure.networkError(exception.toString());
    } else {
      return AuthFailure.unknown(exception.toString());
    }
  }
}
