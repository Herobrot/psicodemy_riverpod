// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firebase_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FirebaseFailure {

 String? get message;
/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirebaseFailureCopyWith<FirebaseFailure> get copyWith => _$FirebaseFailureCopyWithImpl<FirebaseFailure>(this as FirebaseFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirebaseFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $FirebaseFailureCopyWith<$Res>  {
  factory $FirebaseFailureCopyWith(FirebaseFailure value, $Res Function(FirebaseFailure) _then) = _$FirebaseFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$FirebaseFailureCopyWithImpl<$Res>
    implements $FirebaseFailureCopyWith<$Res> {
  _$FirebaseFailureCopyWithImpl(this._self, this._then);

  final FirebaseFailure _self;
  final $Res Function(FirebaseFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FirebaseFailure].
extension FirebaseFailurePatterns on FirebaseFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InitializationFailure value)?  notInitialized,TResult Function( _ConfigurationFailure value)?  badConfiguration,TResult Function( _ConnectionFailure value)?  connectionError,TResult Function( _PermissionFailure value)?  permissionDenied,TResult Function( _NetworkFailure value)?  networkError,TResult Function( _TimeoutFailure value)?  timeout,TResult Function( _UnavailableFailure value)?  unavailable,TResult Function( _UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitializationFailure() when notInitialized != null:
return notInitialized(_that);case _ConfigurationFailure() when badConfiguration != null:
return badConfiguration(_that);case _ConnectionFailure() when connectionError != null:
return connectionError(_that);case _PermissionFailure() when permissionDenied != null:
return permissionDenied(_that);case _NetworkFailure() when networkError != null:
return networkError(_that);case _TimeoutFailure() when timeout != null:
return timeout(_that);case _UnavailableFailure() when unavailable != null:
return unavailable(_that);case _UnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InitializationFailure value)  notInitialized,required TResult Function( _ConfigurationFailure value)  badConfiguration,required TResult Function( _ConnectionFailure value)  connectionError,required TResult Function( _PermissionFailure value)  permissionDenied,required TResult Function( _NetworkFailure value)  networkError,required TResult Function( _TimeoutFailure value)  timeout,required TResult Function( _UnavailableFailure value)  unavailable,required TResult Function( _UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case _InitializationFailure():
return notInitialized(_that);case _ConfigurationFailure():
return badConfiguration(_that);case _ConnectionFailure():
return connectionError(_that);case _PermissionFailure():
return permissionDenied(_that);case _NetworkFailure():
return networkError(_that);case _TimeoutFailure():
return timeout(_that);case _UnavailableFailure():
return unavailable(_that);case _UnknownFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InitializationFailure value)?  notInitialized,TResult? Function( _ConfigurationFailure value)?  badConfiguration,TResult? Function( _ConnectionFailure value)?  connectionError,TResult? Function( _PermissionFailure value)?  permissionDenied,TResult? Function( _NetworkFailure value)?  networkError,TResult? Function( _TimeoutFailure value)?  timeout,TResult? Function( _UnavailableFailure value)?  unavailable,TResult? Function( _UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case _InitializationFailure() when notInitialized != null:
return notInitialized(_that);case _ConfigurationFailure() when badConfiguration != null:
return badConfiguration(_that);case _ConnectionFailure() when connectionError != null:
return connectionError(_that);case _PermissionFailure() when permissionDenied != null:
return permissionDenied(_that);case _NetworkFailure() when networkError != null:
return networkError(_that);case _TimeoutFailure() when timeout != null:
return timeout(_that);case _UnavailableFailure() when unavailable != null:
return unavailable(_that);case _UnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  notInitialized,TResult Function( String? message)?  badConfiguration,TResult Function( String? message)?  connectionError,TResult Function( String? message)?  permissionDenied,TResult Function( String? message)?  networkError,TResult Function( String? message)?  timeout,TResult Function( String? message)?  unavailable,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitializationFailure() when notInitialized != null:
return notInitialized(_that.message);case _ConfigurationFailure() when badConfiguration != null:
return badConfiguration(_that.message);case _ConnectionFailure() when connectionError != null:
return connectionError(_that.message);case _PermissionFailure() when permissionDenied != null:
return permissionDenied(_that.message);case _NetworkFailure() when networkError != null:
return networkError(_that.message);case _TimeoutFailure() when timeout != null:
return timeout(_that.message);case _UnavailableFailure() when unavailable != null:
return unavailable(_that.message);case _UnknownFailure() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  notInitialized,required TResult Function( String? message)  badConfiguration,required TResult Function( String? message)  connectionError,required TResult Function( String? message)  permissionDenied,required TResult Function( String? message)  networkError,required TResult Function( String? message)  timeout,required TResult Function( String? message)  unavailable,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case _InitializationFailure():
return notInitialized(_that.message);case _ConfigurationFailure():
return badConfiguration(_that.message);case _ConnectionFailure():
return connectionError(_that.message);case _PermissionFailure():
return permissionDenied(_that.message);case _NetworkFailure():
return networkError(_that.message);case _TimeoutFailure():
return timeout(_that.message);case _UnavailableFailure():
return unavailable(_that.message);case _UnknownFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  notInitialized,TResult? Function( String? message)?  badConfiguration,TResult? Function( String? message)?  connectionError,TResult? Function( String? message)?  permissionDenied,TResult? Function( String? message)?  networkError,TResult? Function( String? message)?  timeout,TResult? Function( String? message)?  unavailable,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case _InitializationFailure() when notInitialized != null:
return notInitialized(_that.message);case _ConfigurationFailure() when badConfiguration != null:
return badConfiguration(_that.message);case _ConnectionFailure() when connectionError != null:
return connectionError(_that.message);case _PermissionFailure() when permissionDenied != null:
return permissionDenied(_that.message);case _NetworkFailure() when networkError != null:
return networkError(_that.message);case _TimeoutFailure() when timeout != null:
return timeout(_that.message);case _UnavailableFailure() when unavailable != null:
return unavailable(_that.message);case _UnknownFailure() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _InitializationFailure extends FirebaseFailure {
  const _InitializationFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitializationFailureCopyWith<_InitializationFailure> get copyWith => __$InitializationFailureCopyWithImpl<_InitializationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitializationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.notInitialized(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InitializationFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$InitializationFailureCopyWith(_InitializationFailure value, $Res Function(_InitializationFailure) _then) = __$InitializationFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$InitializationFailureCopyWithImpl<$Res>
    implements _$InitializationFailureCopyWith<$Res> {
  __$InitializationFailureCopyWithImpl(this._self, this._then);

  final _InitializationFailure _self;
  final $Res Function(_InitializationFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_InitializationFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ConfigurationFailure extends FirebaseFailure {
  const _ConfigurationFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigurationFailureCopyWith<_ConfigurationFailure> get copyWith => __$ConfigurationFailureCopyWithImpl<_ConfigurationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigurationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.badConfiguration(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ConfigurationFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$ConfigurationFailureCopyWith(_ConfigurationFailure value, $Res Function(_ConfigurationFailure) _then) = __$ConfigurationFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$ConfigurationFailureCopyWithImpl<$Res>
    implements _$ConfigurationFailureCopyWith<$Res> {
  __$ConfigurationFailureCopyWithImpl(this._self, this._then);

  final _ConfigurationFailure _self;
  final $Res Function(_ConfigurationFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_ConfigurationFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ConnectionFailure extends FirebaseFailure {
  const _ConnectionFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionFailureCopyWith<_ConnectionFailure> get copyWith => __$ConnectionFailureCopyWithImpl<_ConnectionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.connectionError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ConnectionFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$ConnectionFailureCopyWith(_ConnectionFailure value, $Res Function(_ConnectionFailure) _then) = __$ConnectionFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$ConnectionFailureCopyWithImpl<$Res>
    implements _$ConnectionFailureCopyWith<$Res> {
  __$ConnectionFailureCopyWithImpl(this._self, this._then);

  final _ConnectionFailure _self;
  final $Res Function(_ConnectionFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_ConnectionFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _PermissionFailure extends FirebaseFailure {
  const _PermissionFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionFailureCopyWith<_PermissionFailure> get copyWith => __$PermissionFailureCopyWithImpl<_PermissionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.permissionDenied(message: $message)';
}


}

/// @nodoc
abstract mixin class _$PermissionFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$PermissionFailureCopyWith(_PermissionFailure value, $Res Function(_PermissionFailure) _then) = __$PermissionFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$PermissionFailureCopyWithImpl<$Res>
    implements _$PermissionFailureCopyWith<$Res> {
  __$PermissionFailureCopyWithImpl(this._self, this._then);

  final _PermissionFailure _self;
  final $Res Function(_PermissionFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_PermissionFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _NetworkFailure extends FirebaseFailure {
  const _NetworkFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkFailureCopyWith<_NetworkFailure> get copyWith => __$NetworkFailureCopyWithImpl<_NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.networkError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NetworkFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$NetworkFailureCopyWith(_NetworkFailure value, $Res Function(_NetworkFailure) _then) = __$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$NetworkFailureCopyWithImpl<$Res>
    implements _$NetworkFailureCopyWith<$Res> {
  __$NetworkFailureCopyWithImpl(this._self, this._then);

  final _NetworkFailure _self;
  final $Res Function(_NetworkFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_NetworkFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TimeoutFailure extends FirebaseFailure {
  const _TimeoutFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeoutFailureCopyWith<_TimeoutFailure> get copyWith => __$TimeoutFailureCopyWithImpl<_TimeoutFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeoutFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.timeout(message: $message)';
}


}

/// @nodoc
abstract mixin class _$TimeoutFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$TimeoutFailureCopyWith(_TimeoutFailure value, $Res Function(_TimeoutFailure) _then) = __$TimeoutFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$TimeoutFailureCopyWithImpl<$Res>
    implements _$TimeoutFailureCopyWith<$Res> {
  __$TimeoutFailureCopyWithImpl(this._self, this._then);

  final _TimeoutFailure _self;
  final $Res Function(_TimeoutFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_TimeoutFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _UnavailableFailure extends FirebaseFailure {
  const _UnavailableFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnavailableFailureCopyWith<_UnavailableFailure> get copyWith => __$UnavailableFailureCopyWithImpl<_UnavailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnavailableFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.unavailable(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnavailableFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$UnavailableFailureCopyWith(_UnavailableFailure value, $Res Function(_UnavailableFailure) _then) = __$UnavailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnavailableFailureCopyWithImpl<$Res>
    implements _$UnavailableFailureCopyWith<$Res> {
  __$UnavailableFailureCopyWithImpl(this._self, this._then);

  final _UnavailableFailure _self;
  final $Res Function(_UnavailableFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_UnavailableFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _UnknownFailure extends FirebaseFailure {
  const _UnknownFailure([this.message]): super._();
  

@override final  String? message;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownFailureCopyWith<_UnknownFailure> get copyWith => __$UnknownFailureCopyWithImpl<_UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnknownFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FirebaseFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnknownFailureCopyWith<$Res> implements $FirebaseFailureCopyWith<$Res> {
  factory _$UnknownFailureCopyWith(_UnknownFailure value, $Res Function(_UnknownFailure) _then) = __$UnknownFailureCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnknownFailureCopyWithImpl<$Res>
    implements _$UnknownFailureCopyWith<$Res> {
  __$UnknownFailureCopyWithImpl(this._self, this._then);

  final _UnknownFailure _self;
  final $Res Function(_UnknownFailure) _then;

/// Create a copy of FirebaseFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_UnknownFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
