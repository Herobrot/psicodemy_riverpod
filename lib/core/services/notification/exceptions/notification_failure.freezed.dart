// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationFailure {

 String? get message;
/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationFailureCopyWith<NotificationFailure> get copyWith => _$NotificationFailureCopyWithImpl<NotificationFailure>(this as NotificationFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationFailureCopyWith<$Res>  {
  factory $NotificationFailureCopyWith(NotificationFailure value, $Res Function(NotificationFailure) _then) = _$NotificationFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$NotificationFailureCopyWithImpl<$Res>
    implements $NotificationFailureCopyWith<$Res> {
  _$NotificationFailureCopyWithImpl(this._self, this._then);

  final NotificationFailure _self;
  final $Res Function(NotificationFailure) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationFailure].
extension NotificationFailurePatterns on NotificationFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _NotInitialized value)?  notInitialized,TResult Function( _InvalidNotification value)?  invalidNotification,TResult Function( _SchedulingFailed value)?  schedulingFailed,TResult Function( _CancellationFailed value)?  cancellationFailed,TResult Function( _PlatformError value)?  platformError,TResult Function( _Unknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _NotInitialized() when notInitialized != null:
return notInitialized(_that);case _InvalidNotification() when invalidNotification != null:
return invalidNotification(_that);case _SchedulingFailed() when schedulingFailed != null:
return schedulingFailed(_that);case _CancellationFailed() when cancellationFailed != null:
return cancellationFailed(_that);case _PlatformError() when platformError != null:
return platformError(_that);case _Unknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _NotInitialized value)  notInitialized,required TResult Function( _InvalidNotification value)  invalidNotification,required TResult Function( _SchedulingFailed value)  schedulingFailed,required TResult Function( _CancellationFailed value)  cancellationFailed,required TResult Function( _PlatformError value)  platformError,required TResult Function( _Unknown value)  unknown,}){
final _that = this;
switch (_that) {
case _PermissionDenied():
return permissionDenied(_that);case _NotInitialized():
return notInitialized(_that);case _InvalidNotification():
return invalidNotification(_that);case _SchedulingFailed():
return schedulingFailed(_that);case _CancellationFailed():
return cancellationFailed(_that);case _PlatformError():
return platformError(_that);case _Unknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _NotInitialized value)?  notInitialized,TResult? Function( _InvalidNotification value)?  invalidNotification,TResult? Function( _SchedulingFailed value)?  schedulingFailed,TResult? Function( _CancellationFailed value)?  cancellationFailed,TResult? Function( _PlatformError value)?  platformError,TResult? Function( _Unknown value)?  unknown,}){
final _that = this;
switch (_that) {
case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _NotInitialized() when notInitialized != null:
return notInitialized(_that);case _InvalidNotification() when invalidNotification != null:
return invalidNotification(_that);case _SchedulingFailed() when schedulingFailed != null:
return schedulingFailed(_that);case _CancellationFailed() when cancellationFailed != null:
return cancellationFailed(_that);case _PlatformError() when platformError != null:
return platformError(_that);case _Unknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  permissionDenied,TResult Function( String? message)?  notInitialized,TResult Function( String? message)?  invalidNotification,TResult Function( String? message)?  schedulingFailed,TResult Function( String? message)?  cancellationFailed,TResult Function( String? message)?  platformError,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.message);case _NotInitialized() when notInitialized != null:
return notInitialized(_that.message);case _InvalidNotification() when invalidNotification != null:
return invalidNotification(_that.message);case _SchedulingFailed() when schedulingFailed != null:
return schedulingFailed(_that.message);case _CancellationFailed() when cancellationFailed != null:
return cancellationFailed(_that.message);case _PlatformError() when platformError != null:
return platformError(_that.message);case _Unknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  permissionDenied,required TResult Function( String? message)  notInitialized,required TResult Function( String? message)  invalidNotification,required TResult Function( String? message)  schedulingFailed,required TResult Function( String? message)  cancellationFailed,required TResult Function( String? message)  platformError,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case _PermissionDenied():
return permissionDenied(_that.message);case _NotInitialized():
return notInitialized(_that.message);case _InvalidNotification():
return invalidNotification(_that.message);case _SchedulingFailed():
return schedulingFailed(_that.message);case _CancellationFailed():
return cancellationFailed(_that.message);case _PlatformError():
return platformError(_that.message);case _Unknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  permissionDenied,TResult? Function( String? message)?  notInitialized,TResult? Function( String? message)?  invalidNotification,TResult? Function( String? message)?  schedulingFailed,TResult? Function( String? message)?  cancellationFailed,TResult? Function( String? message)?  platformError,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.message);case _NotInitialized() when notInitialized != null:
return notInitialized(_that.message);case _InvalidNotification() when invalidNotification != null:
return invalidNotification(_that.message);case _SchedulingFailed() when schedulingFailed != null:
return schedulingFailed(_that.message);case _CancellationFailed() when cancellationFailed != null:
return cancellationFailed(_that.message);case _PlatformError() when platformError != null:
return platformError(_that.message);case _Unknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _PermissionDenied extends NotificationFailure {
  const _PermissionDenied([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionDeniedCopyWith<_PermissionDenied> get copyWith => __$PermissionDeniedCopyWithImpl<_PermissionDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.permissionDenied(message: $message)';
}


}

/// @nodoc
abstract mixin class _$PermissionDeniedCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$PermissionDeniedCopyWith(_PermissionDenied value, $Res Function(_PermissionDenied) _then) = __$PermissionDeniedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$PermissionDeniedCopyWithImpl<$Res>
    implements _$PermissionDeniedCopyWith<$Res> {
  __$PermissionDeniedCopyWithImpl(this._self, this._then);

  final _PermissionDenied _self;
  final $Res Function(_PermissionDenied) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_PermissionDenied(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _NotInitialized extends NotificationFailure {
  const _NotInitialized([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotInitializedCopyWith<_NotInitialized> get copyWith => __$NotInitializedCopyWithImpl<_NotInitialized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotInitialized&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.notInitialized(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotInitializedCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$NotInitializedCopyWith(_NotInitialized value, $Res Function(_NotInitialized) _then) = __$NotInitializedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$NotInitializedCopyWithImpl<$Res>
    implements _$NotInitializedCopyWith<$Res> {
  __$NotInitializedCopyWithImpl(this._self, this._then);

  final _NotInitialized _self;
  final $Res Function(_NotInitialized) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_NotInitialized(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InvalidNotification extends NotificationFailure {
  const _InvalidNotification([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidNotificationCopyWith<_InvalidNotification> get copyWith => __$InvalidNotificationCopyWithImpl<_InvalidNotification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidNotification&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.invalidNotification(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InvalidNotificationCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$InvalidNotificationCopyWith(_InvalidNotification value, $Res Function(_InvalidNotification) _then) = __$InvalidNotificationCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$InvalidNotificationCopyWithImpl<$Res>
    implements _$InvalidNotificationCopyWith<$Res> {
  __$InvalidNotificationCopyWithImpl(this._self, this._then);

  final _InvalidNotification _self;
  final $Res Function(_InvalidNotification) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_InvalidNotification(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SchedulingFailed extends NotificationFailure {
  const _SchedulingFailed([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulingFailedCopyWith<_SchedulingFailed> get copyWith => __$SchedulingFailedCopyWithImpl<_SchedulingFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulingFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.schedulingFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SchedulingFailedCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$SchedulingFailedCopyWith(_SchedulingFailed value, $Res Function(_SchedulingFailed) _then) = __$SchedulingFailedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$SchedulingFailedCopyWithImpl<$Res>
    implements _$SchedulingFailedCopyWith<$Res> {
  __$SchedulingFailedCopyWithImpl(this._self, this._then);

  final _SchedulingFailed _self;
  final $Res Function(_SchedulingFailed) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_SchedulingFailed(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CancellationFailed extends NotificationFailure {
  const _CancellationFailed([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancellationFailedCopyWith<_CancellationFailed> get copyWith => __$CancellationFailedCopyWithImpl<_CancellationFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CancellationFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.cancellationFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class _$CancellationFailedCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$CancellationFailedCopyWith(_CancellationFailed value, $Res Function(_CancellationFailed) _then) = __$CancellationFailedCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$CancellationFailedCopyWithImpl<$Res>
    implements _$CancellationFailedCopyWith<$Res> {
  __$CancellationFailedCopyWithImpl(this._self, this._then);

  final _CancellationFailed _self;
  final $Res Function(_CancellationFailed) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_CancellationFailed(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _PlatformError extends NotificationFailure {
  const _PlatformError([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformErrorCopyWith<_PlatformError> get copyWith => __$PlatformErrorCopyWithImpl<_PlatformError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationFailure.platformError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$PlatformErrorCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
  factory _$PlatformErrorCopyWith(_PlatformError value, $Res Function(_PlatformError) _then) = __$PlatformErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$PlatformErrorCopyWithImpl<$Res>
    implements _$PlatformErrorCopyWith<$Res> {
  __$PlatformErrorCopyWithImpl(this._self, this._then);

  final _PlatformError _self;
  final $Res Function(_PlatformError) _then;

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_PlatformError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Unknown extends NotificationFailure {
  const _Unknown([this.message]): super._();
  

@override final  String? message;

/// Create a copy of NotificationFailure
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
  return 'NotificationFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnknownCopyWith<$Res> implements $NotificationFailureCopyWith<$Res> {
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

/// Create a copy of NotificationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Unknown(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
