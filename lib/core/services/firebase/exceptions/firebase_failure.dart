import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_failure.freezed.dart';

@freezed 
class FirebaseFailure with _$FirebaseFailure { 
  const FirebaseFailure._();

  @override
  String? get message => null;

  const factory FirebaseFailure.notInitialized([String? message]) = _InitializationFailure; 
  const factory FirebaseFailure.badConfiguration([String? message]) = _ConfigurationFailure; 
  const factory FirebaseFailure.connectionError([String? message]) = _ConnectionFailure; 
  const factory FirebaseFailure.permissionDenied([String? message]) = _PermissionFailure; 
  const factory FirebaseFailure.networkError([String? message]) = _NetworkFailure; 
  const factory FirebaseFailure.timeout([String? message]) = _TimeoutFailure; 
  const factory FirebaseFailure.unavailable([String? message]) = _UnavailableFailure; 
  const factory FirebaseFailure.unknown([String? message]) = _UnknownFailure;
}