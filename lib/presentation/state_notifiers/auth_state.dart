import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_firebase_entity.dart';

part 'auth_state.g.dart';

@JsonSerializable()
class AuthState {
  final String status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final UserFirebaseEntity? user;
  final String? message;

  // Constructor por defecto para json_serializable
  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  factory AuthState.initial() => const AuthState(status: 'initial');
  factory AuthState.loading() => const AuthState(status: 'loading');
  factory AuthState.authenticated(UserFirebaseEntity user) => 
      AuthState(status: 'authenticated', user: user);
  factory AuthState.unauthenticated() => const AuthState(status: 'unauthenticated');
  factory AuthState.error(String message) => 
      AuthState(status: 'error', message: message);

  factory AuthState.fromJson(Map<String, dynamic> json) => 
      _$AuthStateFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}

@JsonSerializable()
class LoginState {
  final String status;
  final String? message;

  // Constructor por defecto para json_serializable
  const LoginState({
    required this.status,
    this.message,
  });

  factory LoginState.initial() => const LoginState(status: 'initial');
  factory LoginState.loading() => const LoginState(status: 'loading');
  factory LoginState.success() => const LoginState(status: 'success');
  factory LoginState.error(String message) => 
      LoginState(status: 'error', message: message);

  factory LoginState.fromJson(Map<String, dynamic> json) => 
      _$LoginStateFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginStateToJson(this);
}