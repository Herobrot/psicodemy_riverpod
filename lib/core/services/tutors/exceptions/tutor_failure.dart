import 'package:json_annotation/json_annotation.dart';

part 'tutor_failure.g.dart';

@JsonSerializable()
class TutorFailure implements Exception {
  final String type;
  final String? message;

  const TutorFailure({required this.type, this.message});

  factory TutorFailure.serverError([String? message]) =>
      TutorFailure(type: 'serverError', message: message);

  factory TutorFailure.unauthorized([String? message]) =>
      TutorFailure(type: 'unauthorized', message: message);

  factory TutorFailure.notFound([String? message]) =>
      TutorFailure(type: 'notFound', message: message);

  factory TutorFailure.networkError([String? message]) =>
      TutorFailure(type: 'networkError', message: message);

  factory TutorFailure.emptyResponse([String? message]) =>
      TutorFailure(type: 'emptyResponse', message: message);

  factory TutorFailure.parseError([String? message]) =>
      TutorFailure(type: 'parseError', message: message);

  factory TutorFailure.unknown([String? message]) =>
      TutorFailure(type: 'unknown', message: message);

  factory TutorFailure.fromJson(Map<String, dynamic> json) =>
      _$TutorFailureFromJson(json);

  Map<String, dynamic> toJson() => _$TutorFailureToJson(this);

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    switch (type) {
      case 'serverError':
        return 'Error del servidor. Intenta de nuevo más tarde.';
      case 'unauthorized':
        return 'No autorizado. Verifica tus credenciales.';
      case 'notFound':
        return 'No se encontró el recurso solicitado.';
      case 'networkError':
        return 'Error de conexión. Verifica tu conexión a internet.';
      case 'emptyResponse':
        return 'No se encontraron tutores.';
      case 'parseError':
        return 'Error al procesar la respuesta.';
      case 'unknown':
      default:
        return 'Ha ocurrido un error inesperado. Intenta de nuevo.';
    }
  }
}
