import 'package:json_annotation/json_annotation.dart';

part 'appointment_exception.g.dart';

/// Excepción base para errores de citas
@JsonSerializable()
class AppointmentException implements Exception {
  final String type;
  final String message;
  final String? details;

  const AppointmentException({
    required this.type,
    required this.message,
    this.details,
  });

  // Constructor simple para crear excepciones con solo un mensaje
  const AppointmentException.simple(this.message)
    : type = 'error',
      details = null;

  // Factores de errores comunes
  factory AppointmentException.serverError([String? message]) =>
      AppointmentException(
        type: 'serverError',
        message: message ?? 'Error interno del servidor',
      );

  factory AppointmentException.unauthorized([String? message]) =>
      AppointmentException(
        type: 'unauthorized',
        message: message ?? 'No autorizado',
      );

  factory AppointmentException.validationError([String? message]) =>
      AppointmentException(
        type: 'validationError',
        message: message ?? 'Error de validación',
      );

  factory AppointmentException.conflictError([String? message]) =>
      AppointmentException(
        type: 'conflictError',
        message: message ?? 'Conflicto de horario',
      );

  factory AppointmentException.notFound([String? message]) =>
      AppointmentException(
        type: 'notFound',
        message: message ?? 'Cita no encontrada',
      );

  factory AppointmentException.rateLimitExceeded([String? message]) =>
      AppointmentException(
        type: 'rateLimitExceeded',
        message: message ?? 'Demasiadas peticiones',
      );

  factory AppointmentException.networkError([String? message]) =>
      AppointmentException(
        type: 'networkError',
        message: message ?? 'Error de conexión',
      );

  factory AppointmentException.invalidDate([String? message]) =>
      AppointmentException(
        type: 'invalidDate',
        message: message ?? 'Fecha inválida',
      );

  factory AppointmentException.alreadyDeleted([String? message]) =>
      AppointmentException(
        type: 'alreadyDeleted',
        message: message ?? 'La cita ya ha sido eliminada',
      );

  factory AppointmentException.cannotModify([String? message]) =>
      AppointmentException(
        type: 'cannotModify',
        message: message ?? 'No se puede modificar esta cita',
      );

  factory AppointmentException.unknown([String? message]) =>
      AppointmentException(
        type: 'unknown',
        message: message ?? 'Error desconocido',
      );

  factory AppointmentException.fromJson(Map<String, dynamic> json) =>
      _$AppointmentExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentExceptionToJson(this);

  @override
  String toString() {
    return 'AppointmentException(type: $type, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentException &&
        other.type == type &&
        other.message == message &&
        other.details == details;
  }

  @override
  int get hashCode {
    return type.hashCode ^ message.hashCode ^ details.hashCode;
  }
}
