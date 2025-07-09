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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NotificationStateInitial value)?  initial,TResult Function( _NotificationStateLoading value)?  loading,TResult Function( _NotificationStatePermission value)?  permission,TResult Function( _NotificationStateNotifications value)?  notifications,TResult Function( _NotificationStateSubscribedTopics value)?  subscribedTopics,TResult Function( _NotificationStateToken value)?  token,TResult Function( _NotificationStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationStateInitial() when initial != null:
return initial(_that);case _NotificationStateLoading() when loading != null:
return loading(_that);case _NotificationStatePermission() when permission != null:
return permission(_that);case _NotificationStateNotifications() when notifications != null:
return notifications(_that);case _NotificationStateSubscribedTopics() when subscribedTopics != null:
return subscribedTopics(_that);case _NotificationStateToken() when token != null:
return token(_that);case _NotificationStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NotificationStateInitial value)  initial,required TResult Function( _NotificationStateLoading value)  loading,required TResult Function( _NotificationStatePermission value)  permission,required TResult Function( _NotificationStateNotifications value)  notifications,required TResult Function( _NotificationStateSubscribedTopics value)  subscribedTopics,required TResult Function( _NotificationStateToken value)  token,required TResult Function( _NotificationStateError value)  error,}){
final _that = this;
switch (_that) {
case _NotificationStateInitial():
return initial(_that);case _NotificationStateLoading():
return loading(_that);case _NotificationStatePermission():
return permission(_that);case _NotificationStateNotifications():
return notifications(_that);case _NotificationStateSubscribedTopics():
return subscribedTopics(_that);case _NotificationStateToken():
return token(_that);case _NotificationStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NotificationStateInitial value)?  initial,TResult? Function( _NotificationStateLoading value)?  loading,TResult? Function( _NotificationStatePermission value)?  permission,TResult? Function( _NotificationStateNotifications value)?  notifications,TResult? Function( _NotificationStateSubscribedTopics value)?  subscribedTopics,TResult? Function( _NotificationStateToken value)?  token,TResult? Function( _NotificationStateError value)?  error,}){
final _that = this;
switch (_that) {
case _NotificationStateInitial() when initial != null:
return initial(_that);case _NotificationStateLoading() when loading != null:
return loading(_that);case _NotificationStatePermission() when permission != null:
return permission(_that);case _NotificationStateNotifications() when notifications != null:
return notifications(_that);case _NotificationStateSubscribedTopics() when subscribedTopics != null:
return subscribedTopics(_that);case _NotificationStateToken() when token != null:
return token(_that);case _NotificationStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  permission,TResult Function( NotificationEntity notification)?  notifications,TResult Function( String topic)?  subscribedTopics,TResult Function( String token)?  token,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationStateInitial() when initial != null:
return initial();case _NotificationStateLoading() when loading != null:
return loading();case _NotificationStatePermission() when permission != null:
return permission();case _NotificationStateNotifications() when notifications != null:
return notifications(_that.notification);case _NotificationStateSubscribedTopics() when subscribedTopics != null:
return subscribedTopics(_that.topic);case _NotificationStateToken() when token != null:
return token(_that.token);case _NotificationStateError() when error != null:
return error(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  permission,required TResult Function( NotificationEntity notification)  notifications,required TResult Function( String topic)  subscribedTopics,required TResult Function( String token)  token,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _NotificationStateInitial():
return initial();case _NotificationStateLoading():
return loading();case _NotificationStatePermission():
return permission();case _NotificationStateNotifications():
return notifications(_that.notification);case _NotificationStateSubscribedTopics():
return subscribedTopics(_that.topic);case _NotificationStateToken():
return token(_that.token);case _NotificationStateError():
return error(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  permission,TResult? Function( NotificationEntity notification)?  notifications,TResult? Function( String topic)?  subscribedTopics,TResult? Function( String token)?  token,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _NotificationStateInitial() when initial != null:
return initial();case _NotificationStateLoading() when loading != null:
return loading();case _NotificationStatePermission() when permission != null:
return permission();case _NotificationStateNotifications() when notifications != null:
return notifications(_that.notification);case _NotificationStateSubscribedTopics() when subscribedTopics != null:
return subscribedTopics(_that.topic);case _NotificationStateToken() when token != null:
return token(_that.token);case _NotificationStateError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationStateInitial implements NotificationState {
  const _NotificationStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.initial()';
}


}




/// @nodoc


class _NotificationStateLoading implements NotificationState {
  const _NotificationStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.loading()';
}


}




/// @nodoc


class _NotificationStatePermission implements NotificationState {
  const _NotificationStatePermission();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStatePermission);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.permission()';
}


}




/// @nodoc


class _NotificationStateNotifications implements NotificationState {
  const _NotificationStateNotifications(this.notification);
  

 final  NotificationEntity notification;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStateNotificationsCopyWith<_NotificationStateNotifications> get copyWith => __$NotificationStateNotificationsCopyWithImpl<_NotificationStateNotifications>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateNotifications&&(identical(other.notification, notification) || other.notification == notification));
}


@override
int get hashCode => Object.hash(runtimeType,notification);

@override
String toString() {
  return 'NotificationState.notifications(notification: $notification)';
}


}

/// @nodoc
abstract mixin class _$NotificationStateNotificationsCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateNotificationsCopyWith(_NotificationStateNotifications value, $Res Function(_NotificationStateNotifications) _then) = __$NotificationStateNotificationsCopyWithImpl;
@useResult
$Res call({
 NotificationEntity notification
});




}
/// @nodoc
class __$NotificationStateNotificationsCopyWithImpl<$Res>
    implements _$NotificationStateNotificationsCopyWith<$Res> {
  __$NotificationStateNotificationsCopyWithImpl(this._self, this._then);

  final _NotificationStateNotifications _self;
  final $Res Function(_NotificationStateNotifications) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? notification = null,}) {
  return _then(_NotificationStateNotifications(
null == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as NotificationEntity,
  ));
}


}

/// @nodoc


class _NotificationStateSubscribedTopics implements NotificationState {
  const _NotificationStateSubscribedTopics(this.topic);
  

 final  String topic;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStateSubscribedTopicsCopyWith<_NotificationStateSubscribedTopics> get copyWith => __$NotificationStateSubscribedTopicsCopyWithImpl<_NotificationStateSubscribedTopics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateSubscribedTopics&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,topic);

@override
String toString() {
  return 'NotificationState.subscribedTopics(topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$NotificationStateSubscribedTopicsCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateSubscribedTopicsCopyWith(_NotificationStateSubscribedTopics value, $Res Function(_NotificationStateSubscribedTopics) _then) = __$NotificationStateSubscribedTopicsCopyWithImpl;
@useResult
$Res call({
 String topic
});




}
/// @nodoc
class __$NotificationStateSubscribedTopicsCopyWithImpl<$Res>
    implements _$NotificationStateSubscribedTopicsCopyWith<$Res> {
  __$NotificationStateSubscribedTopicsCopyWithImpl(this._self, this._then);

  final _NotificationStateSubscribedTopics _self;
  final $Res Function(_NotificationStateSubscribedTopics) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? topic = null,}) {
  return _then(_NotificationStateSubscribedTopics(
null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NotificationStateToken implements NotificationState {
  const _NotificationStateToken(this.token);
  

 final  String token;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStateTokenCopyWith<_NotificationStateToken> get copyWith => __$NotificationStateTokenCopyWithImpl<_NotificationStateToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateToken&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'NotificationState.token(token: $token)';
}


}

/// @nodoc
abstract mixin class _$NotificationStateTokenCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateTokenCopyWith(_NotificationStateToken value, $Res Function(_NotificationStateToken) _then) = __$NotificationStateTokenCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class __$NotificationStateTokenCopyWithImpl<$Res>
    implements _$NotificationStateTokenCopyWith<$Res> {
  __$NotificationStateTokenCopyWithImpl(this._self, this._then);

  final _NotificationStateToken _self;
  final $Res Function(_NotificationStateToken) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_NotificationStateToken(
null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NotificationStateError implements NotificationState {
  const _NotificationStateError(this.error);
  

 final  String error;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationStateErrorCopyWith<_NotificationStateError> get copyWith => __$NotificationStateErrorCopyWithImpl<_NotificationStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationStateError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NotificationState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$NotificationStateErrorCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateErrorCopyWith(_NotificationStateError value, $Res Function(_NotificationStateError) _then) = __$NotificationStateErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$NotificationStateErrorCopyWithImpl<$Res>
    implements _$NotificationStateErrorCopyWith<$Res> {
  __$NotificationStateErrorCopyWithImpl(this._self, this._then);

  final _NotificationStateError _self;
  final $Res Function(_NotificationStateError) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_NotificationStateError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
