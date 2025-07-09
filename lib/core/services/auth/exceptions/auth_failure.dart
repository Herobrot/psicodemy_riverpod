import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const AuthFailure._();

  @override
  String? get message => null;

  const factory AuthFailure.serverError([String? message]) = _ServerError;
  const factory AuthFailure.apiError([String? message]) = _ApiError;
  const factory AuthFailure.unauthorized([String? message]) = _Unauthorized;
  const factory AuthFailure.invalidCredentials([String? message]) = _InvalidCredentials;
  const factory AuthFailure.network([String? message]) = _Network;
  const factory AuthFailure.emailAlreadyInUse([String? message]) = _EmailAlreadyInUse;
  const factory AuthFailure.invalidEmail([String? message]) = _InvalidEmail;
  const factory AuthFailure.weakPassword([String? message]) = _WeakPassword;
  const factory AuthFailure.userNotFound([String? message]) = _UserNotFound;
  const factory AuthFailure.wrongPassword([String? message]) = _WrongPassword;
  const factory AuthFailure.userDisabled([String? message]) = _UserDisabled;
  const factory AuthFailure.tooManyRequests([String? message]) = _TooManyRequests;
  const factory AuthFailure.operationNotAllowed([String? message]) = _OperationNotAllowed;
  const factory AuthFailure.networkError([String? message]) = _NetworkError;
  const factory AuthFailure.googleSignInCancelled([String? message]) = _GoogleSignInCancelled;
  const factory AuthFailure.googleSignInFailed([String? message]) = _GoogleSignInFailed;
  const factory AuthFailure.storageError([String? message]) = _StorageError;
  const factory AuthFailure.unknown([String? message]) = _Unknown;
}