// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState()';
}


}

/// @nodoc
class $NotificationStateCopyWith<$Res>  {
$NotificationStateCopyWith(NotificationState _, $Res Function(NotificationState) __);
}


/// Adds pattern-matching-related methods to [NotificationState].
extension NotificationStatePatterns on NotificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _PermissionRequested value)?  permissionRequested,TResult Function( _PermissionGranted value)?  permissionGranted,TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _NotificationShown value)?  notificationShown,TResult Function( _NotificationScheduled value)?  notificationScheduled,TResult Function( _NotificationCancelled value)?  notificationCancelled,TResult Function( _AllNotificationsCancelled value)?  allNotificationsCancelled,TResult Function( _ChannelCreated value)?  channelCreated,TResult Function( _ChannelDeleted value)?  channelDeleted,TResult Function( _Error value)?  error,TResult Function( _Loading value)?  loading,TResult Function( _SettingsChecked value)?  settingsChecked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _PermissionRequested() when permissionRequested != null:
return permissionRequested(_that);case _PermissionGranted() when permissionGranted != null:
return permissionGranted(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _NotificationShown() when notificationShown != null:
return notificationShown(_that);case _NotificationScheduled() when notificationScheduled != null:
return notificationScheduled(_that);case _NotificationCancelled() when notificationCancelled != null:
return notificationCancelled(_that);case _AllNotificationsCancelled() when allNotificationsCancelled != null:
return allNotificationsCancelled(_that);case _ChannelCreated() when channelCreated != null:
return channelCreated(_that);case _ChannelDeleted() when channelDeleted != null:
return channelDeleted(_that);case _Error() when error != null:
return error(_that);case _Loading() when loading != null:
return loading(_that);case _SettingsChecked() when settingsChecked != null:
return settingsChecked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _PermissionRequested value)  permissionRequested,required TResult Function( _PermissionGranted value)  permissionGranted,required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _NotificationShown value)  notificationShown,required TResult Function( _NotificationScheduled value)  notificationScheduled,required TResult Function( _NotificationCancelled value)  notificationCancelled,required TResult Function( _AllNotificationsCancelled value)  allNotificationsCancelled,required TResult Function( _ChannelCreated value)  channelCreated,required TResult Function( _ChannelDeleted value)  channelDeleted,required TResult Function( _Error value)  error,required TResult Function( _Loading value)  loading,required TResult Function( _SettingsChecked value)  settingsChecked,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _PermissionRequested():
return permissionRequested(_that);case _PermissionGranted():
return permissionGranted(_that);case _PermissionDenied():
return permissionDenied(_that);case _NotificationShown():
return notificationShown(_that);case _NotificationScheduled():
return notificationScheduled(_that);case _NotificationCancelled():
return notificationCancelled(_that);case _AllNotificationsCancelled():
return allNotificationsCancelled(_that);case _ChannelCreated():
return channelCreated(_that);case _ChannelDeleted():
return channelDeleted(_that);case _Error():
return error(_that);case _Loading():
return loading(_that);case _SettingsChecked():
return settingsChecked(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _PermissionRequested value)?  permissionRequested,TResult? Function( _PermissionGranted value)?  permissionGranted,TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _NotificationShown value)?  notificationShown,TResult? Function( _NotificationScheduled value)?  notificationScheduled,TResult? Function( _NotificationCancelled value)?  notificationCancelled,TResult? Function( _AllNotificationsCancelled value)?  allNotificationsCancelled,TResult? Function( _ChannelCreated value)?  channelCreated,TResult? Function( _ChannelDeleted value)?  channelDeleted,TResult? Function( _Error value)?  error,TResult? Function( _Loading value)?  loading,TResult? Function( _SettingsChecked value)?  settingsChecked,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _PermissionRequested() when permissionRequested != null:
return permissionRequested(_that);case _PermissionGranted() when permissionGranted != null:
return permissionGranted(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _NotificationShown() when notificationShown != null:
return notificationShown(_that);case _NotificationScheduled() when notificationScheduled != null:
return notificationScheduled(_that);case _NotificationCancelled() when notificationCancelled != null:
return notificationCancelled(_that);case _AllNotificationsCancelled() when allNotificationsCancelled != null:
return allNotificationsCancelled(_that);case _ChannelCreated() when channelCreated != null:
return channelCreated(_that);case _ChannelDeleted() when channelDeleted != null:
return channelDeleted(_that);case _Error() when error != null:
return error(_that);case _Loading() when loading != null:
return loading(_that);case _SettingsChecked() when settingsChecked != null:
return settingsChecked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  permissionRequested,TResult Function()?  permissionGranted,TResult Function()?  permissionDenied,TResult Function()?  notificationShown,TResult Function()?  notificationScheduled,TResult Function()?  notificationCancelled,TResult Function()?  allNotificationsCancelled,TResult Function()?  channelCreated,TResult Function()?  channelDeleted,TResult Function( String message)?  error,TResult Function()?  loading,TResult Function( bool enabled)?  settingsChecked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _PermissionRequested() when permissionRequested != null:
return permissionRequested();case _PermissionGranted() when permissionGranted != null:
return permissionGranted();case _PermissionDenied() when permissionDenied != null:
return permissionDenied();case _NotificationShown() when notificationShown != null:
return notificationShown();case _NotificationScheduled() when notificationScheduled != null:
return notificationScheduled();case _NotificationCancelled() when notificationCancelled != null:
return notificationCancelled();case _AllNotificationsCancelled() when allNotificationsCancelled != null:
return allNotificationsCancelled();case _ChannelCreated() when channelCreated != null:
return channelCreated();case _ChannelDeleted() when channelDeleted != null:
return channelDeleted();case _Error() when error != null:
return error(_that.message);case _Loading() when loading != null:
return loading();case _SettingsChecked() when settingsChecked != null:
return settingsChecked(_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  permissionRequested,required TResult Function()  permissionGranted,required TResult Function()  permissionDenied,required TResult Function()  notificationShown,required TResult Function()  notificationScheduled,required TResult Function()  notificationCancelled,required TResult Function()  allNotificationsCancelled,required TResult Function()  channelCreated,required TResult Function()  channelDeleted,required TResult Function( String message)  error,required TResult Function()  loading,required TResult Function( bool enabled)  settingsChecked,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _PermissionRequested():
return permissionRequested();case _PermissionGranted():
return permissionGranted();case _PermissionDenied():
return permissionDenied();case _NotificationShown():
return notificationShown();case _NotificationScheduled():
return notificationScheduled();case _NotificationCancelled():
return notificationCancelled();case _AllNotificationsCancelled():
return allNotificationsCancelled();case _ChannelCreated():
return channelCreated();case _ChannelDeleted():
return channelDeleted();case _Error():
return error(_that.message);case _Loading():
return loading();case _SettingsChecked():
return settingsChecked(_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  permissionRequested,TResult? Function()?  permissionGranted,TResult? Function()?  permissionDenied,TResult? Function()?  notificationShown,TResult? Function()?  notificationScheduled,TResult? Function()?  notificationCancelled,TResult? Function()?  allNotificationsCancelled,TResult? Function()?  channelCreated,TResult? Function()?  channelDeleted,TResult? Function( String message)?  error,TResult? Function()?  loading,TResult? Function( bool enabled)?  settingsChecked,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _PermissionRequested() when permissionRequested != null:
return permissionRequested();case _PermissionGranted() when permissionGranted != null:
return permissionGranted();case _PermissionDenied() when permissionDenied != null:
return permissionDenied();case _NotificationShown() when notificationShown != null:
return notificationShown();case _NotificationScheduled() when notificationScheduled != null:
return notificationScheduled();case _NotificationCancelled() when notificationCancelled != null:
return notificationCancelled();case _AllNotificationsCancelled() when allNotificationsCancelled != null:
return allNotificationsCancelled();case _ChannelCreated() when channelCreated != null:
return channelCreated();case _ChannelDeleted() when channelDeleted != null:
return channelDeleted();case _Error() when error != null:
return error(_that.message);case _Loading() when loading != null:
return loading();case _SettingsChecked() when settingsChecked != null:
return settingsChecked(_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NotificationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.initial()';
}


}




/// @nodoc


class _PermissionRequested implements NotificationState {
  const _PermissionRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.permissionRequested()';
}


}




/// @nodoc


class _PermissionGranted implements NotificationState {
  const _PermissionGranted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionGranted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.permissionGranted()';
}


}




/// @nodoc


class _PermissionDenied implements NotificationState {
  const _PermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.permissionDenied()';
}


}




/// @nodoc


class _NotificationShown implements NotificationState {
  const _NotificationShown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationShown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.notificationShown()';
}


}




/// @nodoc


class _NotificationScheduled implements NotificationState {
  const _NotificationScheduled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationScheduled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.notificationScheduled()';
}


}




/// @nodoc


class _NotificationCancelled implements NotificationState {
  const _NotificationCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.notificationCancelled()';
}


}




/// @nodoc


class _AllNotificationsCancelled implements NotificationState {
  const _AllNotificationsCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllNotificationsCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.allNotificationsCancelled()';
}


}




/// @nodoc


class _ChannelCreated implements NotificationState {
  const _ChannelCreated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelCreated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.channelCreated()';
}


}




/// @nodoc


class _ChannelDeleted implements NotificationState {
  const _ChannelDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.channelDeleted()';
}


}




/// @nodoc


class _Error implements NotificationState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loading implements NotificationState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.loading()';
}


}




/// @nodoc


class _SettingsChecked implements NotificationState {
  const _SettingsChecked(this.enabled);
  

 final  bool enabled;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCheckedCopyWith<_SettingsChecked> get copyWith => __$SettingsCheckedCopyWithImpl<_SettingsChecked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsChecked&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'NotificationState.settingsChecked(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$SettingsCheckedCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$SettingsCheckedCopyWith(_SettingsChecked value, $Res Function(_SettingsChecked) _then) = __$SettingsCheckedCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$SettingsCheckedCopyWithImpl<$Res>
    implements _$SettingsCheckedCopyWith<$Res> {
  __$SettingsCheckedCopyWithImpl(this._self, this._then);

  final _SettingsChecked _self;
  final $Res Function(_SettingsChecked) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_SettingsChecked(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
