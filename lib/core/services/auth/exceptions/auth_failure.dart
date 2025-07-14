import 'package:json_annotation/json_annotation.dart';

part 'auth_failure.g.dart';

@JsonSerializable()
class AuthFailure {
  final String type;
  final String? message;

  // Constructor por defecto para json_serializable
  const AuthFailure({
    required this.type,
    this.message,
  });

  factory AuthFailure.serverError([String? message]) => 
      AuthFailure(type: 'serverError', message: message);
  
  factory AuthFailure.apiError([String? message]) => 
      AuthFailure(type: 'apiError', message: message);
  
  factory AuthFailure.unauthorized([String? message]) => 
      AuthFailure(type: 'unauthorized', message: message);
  
  factory AuthFailure.invalidCredentials([String? message]) => 
      AuthFailure(type: 'invalidCredentials', message: message);
  
  factory AuthFailure.network([String? message]) => 
      AuthFailure(type: 'network', message: message);
  
  factory AuthFailure.emailAlreadyInUse([String? message]) => 
      AuthFailure(type: 'emailAlreadyInUse', message: message);
  
  factory AuthFailure.invalidEmail([String? message]) => 
      AuthFailure(type: 'invalidEmail', message: message);
  
  factory AuthFailure.weakPassword([String? message]) => 
      AuthFailure(type: 'weakPassword', message: message);
  
  factory AuthFailure.userNotFound([String? message]) => 
      AuthFailure(type: 'userNotFound', message: message);
  
  factory AuthFailure.wrongPassword([String? message]) => 
      AuthFailure(type: 'wrongPassword', message: message);
  
  factory AuthFailure.userDisabled([String? message]) => 
      AuthFailure(type: 'userDisabled', message: message);
  
  factory AuthFailure.tooManyRequests([String? message]) => 
      AuthFailure(type: 'tooManyRequests', message: message);
  
  factory AuthFailure.operationNotAllowed([String? message]) => 
      AuthFailure(type: 'operationNotAllowed', message: message);
  
  factory AuthFailure.networkError([String? message]) => 
      AuthFailure(type: 'networkError', message: message);
  
  factory AuthFailure.googleSignInCancelled([String? message]) => 
      AuthFailure(type: 'googleSignInCancelled', message: message);
  
  factory AuthFailure.googleSignInFailed([String? message]) => 
      AuthFailure(type: 'googleSignInFailed', message: message);
  
  factory AuthFailure.storageError([String? message]) => 
      AuthFailure(type: 'storageError', message: message);
  
  factory AuthFailure.unknown([String? message]) => 
      AuthFailure(type: 'unknown', message: message);

  factory AuthFailure.fromJson(Map<String, dynamic> json) => 
      _$AuthFailureFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthFailureToJson(this);

  @override
  String toString() {
    // Si hay un mensaje específico, úsalo
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    
    // Si no hay mensaje, devolver un mensaje amigable basado en el tipo
    switch (type) {
      case 'serverError':
        return 'Error del servidor. Intenta de nuevo más tarde.';
      case 'apiError':
        return 'Error en la API. Intenta de nuevo más tarde.';
      case 'unauthorized':
        return 'No autorizado. Verifica tus credenciales.';
      case 'invalidCredentials':
        return 'Credenciales inválidas. Verifica tu correo y contraseña.';
      case 'network':
      case 'networkError':
        return 'Error de conexión. Verifica tu conexión a internet.';
      case 'emailAlreadyInUse':
        return 'Este correo electrónico ya está registrado.';
      case 'invalidEmail':
        return 'El correo electrónico no es válido.';
      case 'weakPassword':
        return 'La contraseña es demasiado débil.';
      case 'userNotFound':
        return 'Usuario no encontrado. Verifica tu correo electrónico.';
      case 'wrongPassword':
        return 'Contraseña incorrecta. Intenta de nuevo.';
      case 'userDisabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'tooManyRequests':
        return 'Demasiados intentos. Intenta de nuevo más tarde.';
      case 'operationNotAllowed':
        return 'Operación no permitida.';
      case 'googleSignInCancelled':
        return 'Inicio de sesión con Google cancelado.';
      case 'googleSignInFailed':
        return 'Error al iniciar sesión con Google.';
      case 'storageError':
        return 'Error de almacenamiento local.';
      case 'unknown':
      default:
        return 'Ha ocurrido un error inesperado. Intenta de nuevo.';
    }
  }
}