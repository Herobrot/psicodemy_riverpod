// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firebase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FirebaseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirebaseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FirebaseState()';
}


}

/// @nodoc
class $FirebaseStateCopyWith<$Res>  {
$FirebaseStateCopyWith(FirebaseState _, $Res Function(FirebaseState) __);
}


/// Adds pattern-matching-related methods to [FirebaseState].
extension FirebaseStatePatterns on FirebaseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Uninitialized value)?  uninitialized,TResult Function( _Initializing value)?  initializing,TResult Function( _Initialized value)?  initialized,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Uninitialized() when uninitialized != null:
return uninitialized(_that);case _Initializing() when initializing != null:
return initializing(_that);case _Initialized() when initialized != null:
return initialized(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Uninitialized value)  uninitialized,required TResult Function( _Initializing value)  initializing,required TResult Function( _Initialized value)  initialized,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Uninitialized():
return uninitialized(_that);case _Initializing():
return initializing(_that);case _Initialized():
return initialized(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Uninitialized value)?  uninitialized,TResult? Function( _Initializing value)?  initializing,TResult? Function( _Initialized value)?  initialized,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Uninitialized() when uninitialized != null:
return uninitialized(_that);case _Initializing() when initializing != null:
return initializing(_that);case _Initialized() when initialized != null:
return initialized(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  uninitialized,TResult Function()?  initializing,TResult Function( String appName,  String projectId,  DateTime initializedAt)?  initialized,TResult Function( String message,  String? code,  DateTime errorAt)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Uninitialized() when uninitialized != null:
return uninitialized();case _Initializing() when initializing != null:
return initializing();case _Initialized() when initialized != null:
return initialized(_that.appName,_that.projectId,_that.initializedAt);case _Error() when error != null:
return error(_that.message,_that.code,_that.errorAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  uninitialized,required TResult Function()  initializing,required TResult Function( String appName,  String projectId,  DateTime initializedAt)  initialized,required TResult Function( String message,  String? code,  DateTime errorAt)  error,}) {final _that = this;
switch (_that) {
case _Uninitialized():
return uninitialized();case _Initializing():
return initializing();case _Initialized():
return initialized(_that.appName,_that.projectId,_that.initializedAt);case _Error():
return error(_that.message,_that.code,_that.errorAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  uninitialized,TResult? Function()?  initializing,TResult? Function( String appName,  String projectId,  DateTime initializedAt)?  initialized,TResult? Function( String message,  String? code,  DateTime errorAt)?  error,}) {final _that = this;
switch (_that) {
case _Uninitialized() when uninitialized != null:
return uninitialized();case _Initializing() when initializing != null:
return initializing();case _Initialized() when initialized != null:
return initialized(_that.appName,_that.projectId,_that.initializedAt);case _Error() when error != null:
return error(_that.message,_that.code,_that.errorAt);case _:
  return null;

}
}

}

/// @nodoc


class _Uninitialized implements FirebaseState {
  const _Uninitialized();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Uninitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FirebaseState.uninitialized()';
}


}




/// @nodoc


class _Initializing implements FirebaseState {
  const _Initializing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initializing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FirebaseState.initializing()';
}


}




/// @nodoc


class _Initialized implements FirebaseState {
  const _Initialized({required this.appName, required this.projectId, required this.initializedAt});
  

 final  String appName;
 final  String projectId;
 final  DateTime initializedAt;

/// Create a copy of FirebaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitializedCopyWith<_Initialized> get copyWith => __$InitializedCopyWithImpl<_Initialized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initialized&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.initializedAt, initializedAt) || other.initializedAt == initializedAt));
}


@override
int get hashCode => Object.hash(runtimeType,appName,projectId,initializedAt);

@override
String toString() {
  return 'FirebaseState.initialized(appName: $appName, projectId: $projectId, initializedAt: $initializedAt)';
}


}

/// @nodoc
abstract mixin class _$InitializedCopyWith<$Res> implements $FirebaseStateCopyWith<$Res> {
  factory _$InitializedCopyWith(_Initialized value, $Res Function(_Initialized) _then) = __$InitializedCopyWithImpl;
@useResult
$Res call({
 String appName, String projectId, DateTime initializedAt
});




}
/// @nodoc
class __$InitializedCopyWithImpl<$Res>
    implements _$InitializedCopyWith<$Res> {
  __$InitializedCopyWithImpl(this._self, this._then);

  final _Initialized _self;
  final $Res Function(_Initialized) _then;

/// Create a copy of FirebaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? projectId = null,Object? initializedAt = null,}) {
  return _then(_Initialized(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,initializedAt: null == initializedAt ? _self.initializedAt : initializedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _Error implements FirebaseState {
  const _Error({required this.message, this.code, required this.errorAt});
  

 final  String message;
 final  String? code;
 final  DateTime errorAt;

/// Create a copy of FirebaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&(identical(other.errorAt, errorAt) || other.errorAt == errorAt));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,errorAt);

@override
String toString() {
  return 'FirebaseState.error(message: $message, code: $code, errorAt: $errorAt)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FirebaseStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? code, DateTime errorAt
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of FirebaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,Object? errorAt = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,errorAt: null == errorAt ? _self.errorAt : errorAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
