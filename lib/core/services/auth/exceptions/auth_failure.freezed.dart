// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {

 String? get message;
/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<AuthFailure> get copyWith => _$AuthFailureCopyWithImpl<AuthFailure>(this as AuthFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res>  {
  factory $AuthFailureCopyWith(AuthFailure value, $Res Function(AuthFailure) _then) = _$AuthFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$AuthFailureCopyWithImpl<$Res>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ServerError value)?  serverError,TResult Function( _ApiError value)?  apiError,TResult Function( _Unauthorized value)?  unauthorized,TResult Function( _InvalidCredentials value)?  invalidCredentials,TResult Function( _Network value)?  network,TResult Function( _EmailAlreadyInUse value)?  emailAlreadyInUse,TResult Function( _InvalidEmail value)?  invalidEmail,TResult Function( _WeakPassword value)?  weakPassword,TResult Function( _UserNotFound value)?  userNotFound,TResult Function( _WrongPassword value)?  wrongPassword,TResult Function( _UserDisabled value)?  userDisabled,TResult Function( _TooManyRequests value)?  tooManyRequests,TResult Function( _OperationNotAllowed value)?  operationNotAllowed,TResult Function( _NetworkError value)?  networkError,TResult Function( _GoogleSignInCancelled value)?  googleSignInCancelled,TResult Function( _GoogleSignInFailed value)?  googleSignInFailed,TResult Function( _StorageError value)?  storageError,TResult Function( _Unknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that);case _ApiError() when apiError != null:
return apiError(_that);case _Unauthorized() when unauthorized != null:
return unauthorized(_that);case _InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case _Network() when network != null:
return network(_that);case _EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case _InvalidEmail() when invalidEmail != null:
return invalidEmail(_that);case _WeakPassword() when weakPassword != null:
return weakPassword(_that);case _UserNotFound() when userNotFound != null:
return userNotFound(_that);case _WrongPassword() when wrongPassword != null:
return wrongPassword(_that);case _UserDisabled() when userDisabled != null:
return userDisabled(_that);case _TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case _OperationNotAllowed() when operationNotAllowed != null:
return operationNotAllowed(_that);case _NetworkError() when networkError != null:
return networkError(_that);case _GoogleSignInCancelled() when googleSignInCancelled != null:
return googleSignInCancelled(_that);case _GoogleSignInFailed() when googleSignInFailed != null:
return googleSignInFailed(_that);case _StorageError() when storageError != null:
return storageError(_that);case _Unknown() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ServerError value)  serverError,required TResult Function( _ApiError value)  apiError,required TResult Function( _Unauthorized value)  unauthorized,required TResult Function( _InvalidCredentials value)  invalidCredentials,required TResult Function( _Network value)  network,required TResult Function( _EmailAlreadyInUse value)  emailAlreadyInUse,required TResult Function( _InvalidEmail value)  invalidEmail,required TResult Function( _WeakPassword value)  weakPassword,required TResult Function( _UserNotFound value)  userNotFound,required TResult Function( _WrongPassword value)  wrongPassword,required TResult Function( _UserDisabled value)  userDisabled,required TResult Function( _TooManyRequests value)  tooManyRequests,required TResult Function( _OperationNotAllowed value)  operationNotAllowed,required TResult Function( _NetworkError value)  networkError,required TResult Function( _GoogleSignInCancelled value)  googleSignInCancelled,required TResult Function( _GoogleSignInFailed value)  googleSignInFailed,required TResult Function( _StorageError value)  storageError,required TResult Function( _Unknown value)  unknown,}){
final _that = this;
switch (_that) {
case _ServerError():
return serverError(_that);case _ApiError():
return apiError(_that);case _Unauthorized():
return unauthorized(_that);case _InvalidCredentials():
return invalidCredentials(_that);case _Network():
return network(_that);case _EmailAlreadyInUse():
return emailAlreadyInUse(_that);case _InvalidEmail():
return invalidEmail(_that);case _WeakPassword():
return weakPassword(_that);case _UserNotFound():
return userNotFound(_that);case _WrongPassword():
return wrongPassword(_that);case _UserDisabled():
return userDisabled(_that);case _TooManyRequests():
return tooManyRequests(_that);case _OperationNotAllowed():
return operationNotAllowed(_that);case _NetworkError():
return networkError(_that);case _GoogleSignInCancelled():
return googleSignInCancelled(_that);case _GoogleSignInFailed():
return googleSignInFailed(_that);case _StorageError():
return storageError(_that);case _Unknown():
return unknown(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ServerError value)?  serverError,TResult? Function( _ApiError value)?  apiError,TResult? Function( _Unauthorized value)?  unauthorized,TResult? Function( _InvalidCredentials value)?  invalidCredentials,TResult? Function( _Network value)?  network,TResult? Function( _EmailAlreadyInUse value)?  emailAlreadyInUse,TResult? Function( _InvalidEmail value)?  invalidEmail,TResult? Function( _WeakPassword value)?  weakPassword,TResult? Function( _UserNotFound value)?  userNotFound,TResult? Function( _WrongPassword value)?  wrongPassword,TResult? Function( _UserDisabled value)?  userDisabled,TResult? Function( _TooManyRequests value)?  tooManyRequests,TResult? Function( _OperationNotAllowed value)?  operationNotAllowed,TResult? Function( _NetworkError value)?  networkError,TResult? Function( _GoogleSignInCancelled value)?  googleSignInCancelled,TResult? Function( _GoogleSignInFailed value)?  googleSignInFailed,TResult? Function( _StorageError value)?  storageError,TResult? Function( _Unknown value)?  unknown,}){
final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that);case _ApiError() when apiError != null:
return apiError(_that);case _Unauthorized() when unauthorized != null:
return unauthorized(_that);case _InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case _Network() when network != null:
return network(_that);case _EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case _InvalidEmail() when invalidEmail != null:
return invalidEmail(_that);case _WeakPassword() when weakPassword != null:
return weakPassword(_that);case _UserNotFound() when userNotFound != null:
return userNotFound(_that);case _WrongPassword() when wrongPassword != null:
return wrongPassword(_that);case _UserDisabled() when userDisabled != null:
return userDisabled(_that);case _TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case _OperationNotAllowed() when operationNotAllowed != null:
return operationNotAllowed(_that);case _NetworkError() when networkError != null:
return networkError(_that);case _GoogleSignInCancelled() when googleSignInCancelled != null:
return googleSignInCancelled(_that);case _GoogleSignInFailed() when googleSignInFailed != null:
return googleSignInFailed(_that);case _StorageError() when storageError != null:
return storageError(_that);case _Unknown() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  serverError,TResult Function( String? message)?  apiError,TResult Function( String? message)?  unauthorized,TResult Function( String? message)?  invalidCredentials,TResult Function( String? message)?  network,TResult Function( String? message)?  emailAlreadyInUse,TResult Function( String? message)?  invalidEmail,TResult Function( String? message)?  weakPassword,TResult Function( String? message)?  userNotFound,TResult Function( String? message)?  wrongPassword,TResult Function( String? message)?  userDisabled,TResult Function( String? message)?  tooManyRequests,TResult Function( String? message)?  operationNotAllowed,TResult Function( String? message)?  networkError,TResult Function( String? message)?  googleSignInCancelled,TResult Function( String? message)?  googleSignInFailed,TResult Function( String? message)?  storageError,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that.message);case _ApiError() when apiError != null:
return apiError(_that.message);case _Unauthorized() when unauthorized != null:
return unauthorized(_that.message);case _InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that.message);case _Network() when network != null:
return network(_that.message);case _EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that.message);case _InvalidEmail() when invalidEmail != null:
return invalidEmail(_that.message);case _WeakPassword() when weakPassword != null:
return weakPassword(_that.message);case _UserNotFound() when userNotFound != null:
return userNotFound(_that.message);case _WrongPassword() when wrongPassword != null:
return wrongPassword(_that.message);case _UserDisabled() when userDisabled != null:
return userDisabled(_that.message);case _TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that.message);case _OperationNotAllowed() when operationNotAllowed != null:
return operationNotAllowed(_that.message);case _NetworkError() when networkError != null:
return networkError(_that.message);case _GoogleSignInCancelled() when googleSignInCancelled != null:
return googleSignInCancelled(_that.message);case _GoogleSignInFailed() when googleSignInFailed != null:
return googleSignInFailed(_that.message);case _StorageError() when storageError != null:
return storageError(_that.message);case _Unknown() when unknown != null:
return unknown(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  serverError,required TResult Function( String? message)  apiError,required TResult Function( String? message)  unauthorized,required TResult Function( String? message)  invalidCredentials,required TResult Function( String? message)  network,required TResult Function( String? message)  emailAlreadyInUse,required TResult Function( String? message)  invalidEmail,required TResult Function( String? message)  weakPassword,required TResult Function( String? message)  userNotFound,required TResult Function( String? message)  wrongPassword,required TResult Function( String? message)  userDisabled,required TResult Function( String? message)  tooManyRequests,required TResult Function( String? message)  operationNotAllowed,required TResult Function( String? message)  networkError,required TResult Function( String? message)  googleSignInCancelled,required TResult Function( String? message)  googleSignInFailed,required TResult Function( String? message)  storageError,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case _ServerError():
return serverError(_that.message);case _ApiError():
return apiError(_that.message);case _Unauthorized():
return unauthorized(_that.message);case _InvalidCredentials():
return invalidCredentials(_that.message);case _Network():
return network(_that.message);case _EmailAlreadyInUse():
return emailAlreadyInUse(_that.message);case _InvalidEmail():
return invalidEmail(_that.message);case _WeakPassword():
return weakPassword(_that.message);case _UserNotFound():
return userNotFound(_that.message);case _WrongPassword():
return wrongPassword(_that.message);case _UserDisabled():
return userDisabled(_that.message);case _TooManyRequests():
return tooManyRequests(_that.message);case _OperationNotAllowed():
return operationNotAllowed(_that.message);case _NetworkError():
return networkError(_that.message);case _GoogleSignInCancelled():
return googleSignInCancelled(_that.message);case _GoogleSignInFailed():
return googleSignInFailed(_that.message);case _StorageError():
return storageError(_that.message);case _Unknown():
return unknown(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  serverError,TResult? Function( String? message)?  apiError,TResult? Function( String? message)?  unauthorized,TResult? Function( String? message)?  invalidCredentials,TResult? Function( String? message)?  network,TResult? Function( String? message)?  emailAlreadyInUse,TResult? Function( String? message)?  invalidEmail,TResult? Function( String? message)?  weakPassword,TResult? Function( String? message)?  userNotFound,TResult? Function( String? message)?  wrongPassword,TResult? Function( String? message)?  userDisabled,TResult? Function( String? message)?  tooManyRequests,TResult? Function( String? message)?  operationNotAllowed,TResult? Function( String? message)?  networkError,TResult? Function( String? message)?  googleSignInCancelled,TResult? Function( String? message)?  googleSignInFailed,TResult? Function( String? message)?  storageError,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that.message);case _ApiError() when apiError != null:
return apiError(_that.message);case _Unauthorized() when unauthorized != null:
return unauthorized(_that.message);case _InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that.message);case _Network() when network != null:
return network(_that.message);case _EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that.message);case _InvalidEmail() when invalidEmail != null:
return invalidEmail(_that.message);case _WeakPassword() when weakPassword != null:
return weakPassword(_that.message);case _UserNotFound() when userNotFound != null:
return userNotFound(_that.message);case _WrongPassword() when wrongPassword != null:
return wrongPassword(_that.message);case _UserDisabled() when userDisabled != null:
return userDisabled(_that.message);case _TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that.message);case _OperationNotAllowed() when operationNotAllowed != null:
return operationNotAllowed(_that.message);case _NetworkError() when networkError != null:
return networkError(_that.message);case _GoogleSignInCancelled() when googleSignInCancelled != null:
return googleSignInCancelled(_that.message);case _GoogleSignInFailed() when googleSignInFailed != null:
return googleSignInFailed(_that.message);case _StorageError() when storageError != null:
return storageError(_that.message);case _Unknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ServerError extends AuthFailure {
  const _ServerError([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerErrorCopyWith<_ServerError> get copyWith => __$ServerErrorCopyWithImpl<_ServerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.serverError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ServerErrorCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$ServerErrorCopyWith(_ServerError value, $Res Function(_ServerError) _then) = __$ServerErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$ServerErrorCopyWithImpl<$Res>
    implements _$ServerErrorCopyWith<$Res> {
  __$ServerErrorCopyWithImpl(this._self, this._then);

  final _ServerError _self;
  final $Res Function(_ServerError) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_ServerError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ApiError extends AuthFailure {
  const _ApiError([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorCopyWith<_ApiError> get copyWith => __$ApiErrorCopyWithImpl<_ApiError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.apiError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$ApiErrorCopyWith(_ApiError value, $Res Function(_ApiError) _then) = __$ApiErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$ApiErrorCopyWithImpl<$Res>
    implements _$ApiErrorCopyWith<$Res> {
  __$ApiErrorCopyWithImpl(this._self, this._then);

  final _ApiError _self;
  final $Res Function(_ApiError) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_ApiError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Unauthorized extends AuthFailure {
  const _Unauthorized([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthorizedCopyWith<_Unauthorized> get copyWith => __$UnauthorizedCopyWithImpl<_Unauthorized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthorized&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.unauthorized(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnauthorizedCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$UnauthorizedCopyWith(_Unauthorized value, $Res Function(_Unauthorized) _then) = __$UnauthorizedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnauthorizedCopyWithImpl<$Res>
    implements _$UnauthorizedCopyWith<$Res> {
  __$UnauthorizedCopyWithImpl(this._self, this._then);

  final _Unauthorized _self;
  final $Res Function(_Unauthorized) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Unauthorized(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InvalidCredentials extends AuthFailure {
  const _InvalidCredentials([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidCredentialsCopyWith<_InvalidCredentials> get copyWith => __$InvalidCredentialsCopyWithImpl<_InvalidCredentials>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidCredentials&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.invalidCredentials(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InvalidCredentialsCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$InvalidCredentialsCopyWith(_InvalidCredentials value, $Res Function(_InvalidCredentials) _then) = __$InvalidCredentialsCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$InvalidCredentialsCopyWithImpl<$Res>
    implements _$InvalidCredentialsCopyWith<$Res> {
  __$InvalidCredentialsCopyWithImpl(this._self, this._then);

  final _InvalidCredentials _self;
  final $Res Function(_InvalidCredentials) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_InvalidCredentials(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Network extends AuthFailure {
  const _Network([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkCopyWith<_Network> get copyWith => __$NetworkCopyWithImpl<_Network>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Network&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NetworkCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$NetworkCopyWith(_Network value, $Res Function(_Network) _then) = __$NetworkCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$NetworkCopyWithImpl<$Res>
    implements _$NetworkCopyWith<$Res> {
  __$NetworkCopyWithImpl(this._self, this._then);

  final _Network _self;
  final $Res Function(_Network) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Network(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _EmailAlreadyInUse extends AuthFailure {
  const _EmailAlreadyInUse([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailAlreadyInUseCopyWith<_EmailAlreadyInUse> get copyWith => __$EmailAlreadyInUseCopyWithImpl<_EmailAlreadyInUse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailAlreadyInUse&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.emailAlreadyInUse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$EmailAlreadyInUseCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$EmailAlreadyInUseCopyWith(_EmailAlreadyInUse value, $Res Function(_EmailAlreadyInUse) _then) = __$EmailAlreadyInUseCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$EmailAlreadyInUseCopyWithImpl<$Res>
    implements _$EmailAlreadyInUseCopyWith<$Res> {
  __$EmailAlreadyInUseCopyWithImpl(this._self, this._then);

  final _EmailAlreadyInUse _self;
  final $Res Function(_EmailAlreadyInUse) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_EmailAlreadyInUse(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InvalidEmail extends AuthFailure {
  const _InvalidEmail([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidEmailCopyWith<_InvalidEmail> get copyWith => __$InvalidEmailCopyWithImpl<_InvalidEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidEmail&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.invalidEmail(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InvalidEmailCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$InvalidEmailCopyWith(_InvalidEmail value, $Res Function(_InvalidEmail) _then) = __$InvalidEmailCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$InvalidEmailCopyWithImpl<$Res>
    implements _$InvalidEmailCopyWith<$Res> {
  __$InvalidEmailCopyWithImpl(this._self, this._then);

  final _InvalidEmail _self;
  final $Res Function(_InvalidEmail) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_InvalidEmail(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _WeakPassword extends AuthFailure {
  const _WeakPassword([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakPasswordCopyWith<_WeakPassword> get copyWith => __$WeakPasswordCopyWithImpl<_WeakPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakPassword&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.weakPassword(message: $message)';
}


}

/// @nodoc
abstract mixin class _$WeakPasswordCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$WeakPasswordCopyWith(_WeakPassword value, $Res Function(_WeakPassword) _then) = __$WeakPasswordCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$WeakPasswordCopyWithImpl<$Res>
    implements _$WeakPasswordCopyWith<$Res> {
  __$WeakPasswordCopyWithImpl(this._self, this._then);

  final _WeakPassword _self;
  final $Res Function(_WeakPassword) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_WeakPassword(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _UserNotFound extends AuthFailure {
  const _UserNotFound([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserNotFoundCopyWith<_UserNotFound> get copyWith => __$UserNotFoundCopyWithImpl<_UserNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserNotFound&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.userNotFound(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UserNotFoundCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$UserNotFoundCopyWith(_UserNotFound value, $Res Function(_UserNotFound) _then) = __$UserNotFoundCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UserNotFoundCopyWithImpl<$Res>
    implements _$UserNotFoundCopyWith<$Res> {
  __$UserNotFoundCopyWithImpl(this._self, this._then);

  final _UserNotFound _self;
  final $Res Function(_UserNotFound) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_UserNotFound(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _WrongPassword extends AuthFailure {
  const _WrongPassword([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrongPasswordCopyWith<_WrongPassword> get copyWith => __$WrongPasswordCopyWithImpl<_WrongPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrongPassword&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.wrongPassword(message: $message)';
}


}

/// @nodoc
abstract mixin class _$WrongPasswordCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$WrongPasswordCopyWith(_WrongPassword value, $Res Function(_WrongPassword) _then) = __$WrongPasswordCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$WrongPasswordCopyWithImpl<$Res>
    implements _$WrongPasswordCopyWith<$Res> {
  __$WrongPasswordCopyWithImpl(this._self, this._then);

  final _WrongPassword _self;
  final $Res Function(_WrongPassword) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_WrongPassword(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _UserDisabled extends AuthFailure {
  const _UserDisabled([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDisabledCopyWith<_UserDisabled> get copyWith => __$UserDisabledCopyWithImpl<_UserDisabled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDisabled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.userDisabled(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UserDisabledCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$UserDisabledCopyWith(_UserDisabled value, $Res Function(_UserDisabled) _then) = __$UserDisabledCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UserDisabledCopyWithImpl<$Res>
    implements _$UserDisabledCopyWith<$Res> {
  __$UserDisabledCopyWithImpl(this._self, this._then);

  final _UserDisabled _self;
  final $Res Function(_UserDisabled) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_UserDisabled(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TooManyRequests extends AuthFailure {
  const _TooManyRequests([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TooManyRequestsCopyWith<_TooManyRequests> get copyWith => __$TooManyRequestsCopyWithImpl<_TooManyRequests>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TooManyRequests&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.tooManyRequests(message: $message)';
}


}

/// @nodoc
abstract mixin class _$TooManyRequestsCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$TooManyRequestsCopyWith(_TooManyRequests value, $Res Function(_TooManyRequests) _then) = __$TooManyRequestsCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$TooManyRequestsCopyWithImpl<$Res>
    implements _$TooManyRequestsCopyWith<$Res> {
  __$TooManyRequestsCopyWithImpl(this._self, this._then);

  final _TooManyRequests _self;
  final $Res Function(_TooManyRequests) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_TooManyRequests(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _OperationNotAllowed extends AuthFailure {
  const _OperationNotAllowed([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperationNotAllowedCopyWith<_OperationNotAllowed> get copyWith => __$OperationNotAllowedCopyWithImpl<_OperationNotAllowed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperationNotAllowed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.operationNotAllowed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$OperationNotAllowedCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$OperationNotAllowedCopyWith(_OperationNotAllowed value, $Res Function(_OperationNotAllowed) _then) = __$OperationNotAllowedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$OperationNotAllowedCopyWithImpl<$Res>
    implements _$OperationNotAllowedCopyWith<$Res> {
  __$OperationNotAllowedCopyWithImpl(this._self, this._then);

  final _OperationNotAllowed _self;
  final $Res Function(_OperationNotAllowed) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_OperationNotAllowed(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _NetworkError extends AuthFailure {
  const _NetworkError([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkErrorCopyWith<_NetworkError> get copyWith => __$NetworkErrorCopyWithImpl<_NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.networkError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NetworkErrorCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$NetworkErrorCopyWith(_NetworkError value, $Res Function(_NetworkError) _then) = __$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$NetworkErrorCopyWithImpl<$Res>
    implements _$NetworkErrorCopyWith<$Res> {
  __$NetworkErrorCopyWithImpl(this._self, this._then);

  final _NetworkError _self;
  final $Res Function(_NetworkError) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_NetworkError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _GoogleSignInCancelled extends AuthFailure {
  const _GoogleSignInCancelled([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoogleSignInCancelledCopyWith<_GoogleSignInCancelled> get copyWith => __$GoogleSignInCancelledCopyWithImpl<_GoogleSignInCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleSignInCancelled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.googleSignInCancelled(message: $message)';
}


}

/// @nodoc
abstract mixin class _$GoogleSignInCancelledCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$GoogleSignInCancelledCopyWith(_GoogleSignInCancelled value, $Res Function(_GoogleSignInCancelled) _then) = __$GoogleSignInCancelledCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$GoogleSignInCancelledCopyWithImpl<$Res>
    implements _$GoogleSignInCancelledCopyWith<$Res> {
  __$GoogleSignInCancelledCopyWithImpl(this._self, this._then);

  final _GoogleSignInCancelled _self;
  final $Res Function(_GoogleSignInCancelled) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_GoogleSignInCancelled(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _GoogleSignInFailed extends AuthFailure {
  const _GoogleSignInFailed([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoogleSignInFailedCopyWith<_GoogleSignInFailed> get copyWith => __$GoogleSignInFailedCopyWithImpl<_GoogleSignInFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleSignInFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.googleSignInFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$GoogleSignInFailedCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$GoogleSignInFailedCopyWith(_GoogleSignInFailed value, $Res Function(_GoogleSignInFailed) _then) = __$GoogleSignInFailedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$GoogleSignInFailedCopyWithImpl<$Res>
    implements _$GoogleSignInFailedCopyWith<$Res> {
  __$GoogleSignInFailedCopyWithImpl(this._self, this._then);

  final _GoogleSignInFailed _self;
  final $Res Function(_GoogleSignInFailed) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_GoogleSignInFailed(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _StorageError extends AuthFailure {
  const _StorageError([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageErrorCopyWith<_StorageError> get copyWith => __$StorageErrorCopyWithImpl<_StorageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.storageError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$StorageErrorCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$StorageErrorCopyWith(_StorageError value, $Res Function(_StorageError) _then) = __$StorageErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$StorageErrorCopyWithImpl<$Res>
    implements _$StorageErrorCopyWith<$Res> {
  __$StorageErrorCopyWithImpl(this._self, this._then);

  final _StorageError _self;
  final $Res Function(_StorageError) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_StorageError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Unknown extends AuthFailure {
  const _Unknown([this.message]): super._();
  

@override final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownCopyWith<_Unknown> get copyWith => __$UnknownCopyWithImpl<_Unknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnknownCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory _$UnknownCopyWith(_Unknown value, $Res Function(_Unknown) _then) = __$UnknownCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnknownCopyWithImpl<$Res>
    implements _$UnknownCopyWith<$Res> {
  __$UnknownCopyWithImpl(this._self, this._then);

  final _Unknown _self;
  final $Res Function(_Unknown) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Unknown(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
