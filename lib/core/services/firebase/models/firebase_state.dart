import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_state.freezed.dart';

@freezed
class FirebaseState with _$FirebaseState {  
  const factory FirebaseState.uninitialized() = _Uninitialized;    
  const factory FirebaseState.initializing() = _Initializing;    
  const factory FirebaseState.initialized({
    required String appName,
    required String projectId,
    required DateTime initializedAt,
  }) = _Initialized;  
  const factory FirebaseState.error({
    required String message,
    String? code,
    required DateTime errorAt,
  }) = _Error;
}