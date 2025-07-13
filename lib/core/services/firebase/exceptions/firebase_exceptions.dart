import 'firebase_failure.dart';

class FirebaseExceptions {
  static FirebaseFailure handleFirebaseException(Exception exception) {
    if (exception.toString().contains('permission-denied')) {
      return const FirebaseFailure.permissionDenied('No tienes permiso para realizar esta accion');
    } else if (exception.toString().contains('bad-initialization')) {
      return const FirebaseFailure.notInitialized('Firebase no ha sido inicializado');
    } else if (exception.toString().contains('bad-config')) {
      return const FirebaseFailure.notInitialized('Firebase no ha sido configurado');
    } else if (exception.toString().contains('network-error')) {
      return const FirebaseFailure.networkError('Error de red');
    } else if (exception.toString().contains('connection-error')) {
      return const FirebaseFailure.connectionError('Error de servidor');
    } else if (exception.toString().contains('timeout')) {
      return const FirebaseFailure.timeout('Tiempo de espera agotado');
    } else if (exception.toString().contains('unavailable')) {
      return const FirebaseFailure.unavailable('Servicio no disponible');
    } else {
      return FirebaseFailure.unknown(exception.toString());
    }
  }
}
