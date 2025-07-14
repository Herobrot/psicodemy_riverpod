import 'package:json_annotation/json_annotation.dart';

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

  // Factores de errores comunes
  factory TutorException.serverError([String? message]) =>
      TutorException(
        type: 'serverError',
        message: message ?? 'Error interno del servidor',
      );

  factory TutorException.unauthorized([String? message]) =>
      TutorException(
        type: 'unauthorized',
        message: message ?? 'No autorizado',
      );

  factory TutorException.notFound([String? message]) =>
      TutorException(
        type: 'notFound',
        message: message ?? 'Tutores no encontrados',
      );

  factory TutorException.networkError([String? message]) =>
      TutorException(
        type: 'networkError',
        message: message ?? 'Error de conexión',
      );

  factory TutorException.emptyResponse([String? message]) =>
      TutorException(
        type: 'emptyResponse',
        message: message ?? 'No se encontraron tutores',
      );

  factory TutorException.parseError([String? message]) =>
      TutorException(
        type: 'parseError',
        message: message ?? 'Error al procesar la respuesta',
      );

  factory TutorException.unknown([String? message]) =>
      TutorException(
        type: 'unknown',
        message: message ?? 'Error desconocido',
      );

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