import 'package:json_annotation/json_annotation.dart';
import 'tutor_failure.dart';

part 'tutor_exception.g.dart';

/// Excepción base para errores de tutores
@JsonSerializable()
class TutorException implements Exception {
  final String type;
  final String message;
  final String? details;

  const TutorException({
    required this.type,
    required this.message,
    this.details,
  });

  // Factory para crear desde TutorFailure
  factory TutorException.fromFailure(TutorFailure failure) => TutorException(
    type: failure.type,
    message: failure.message ?? '',
    details: null,
  );

  // Factories delegando a TutorFailure y usando fromFailure
  factory TutorException.serverError([String? message]) =>
      TutorException.fromFailure(TutorFailure.serverError(message));

  factory TutorException.unauthorized([String? message]) =>
      TutorException.fromFailure(TutorFailure.unauthorized(message));

  factory TutorException.notFound([String? message]) =>
      TutorException.fromFailure(TutorFailure.notFound(message));

  factory TutorException.networkError([String? message]) =>
      TutorException.fromFailure(TutorFailure.networkError(message));

  factory TutorException.emptyResponse([String? message]) =>
      TutorException.fromFailure(TutorFailure.emptyResponse(message));

  factory TutorException.parseError([String? message]) =>
      TutorException.fromFailure(TutorFailure.parseError(message));

  factory TutorException.unknown([String? message]) =>
      TutorException.fromFailure(TutorFailure.unknown(message));

  factory TutorException.fromJson(Map<String, dynamic> json) =>
      _$TutorExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$TutorExceptionToJson(this);

  @override
  String toString() {
    return 'TutorException(type: $type, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TutorException &&
        other.type == type &&
        other.message == message &&
        other.details == details;
  }

  @override
  int get hashCode {
    return type.hashCode ^ message.hashCode ^ details.hashCode;
  }
} 