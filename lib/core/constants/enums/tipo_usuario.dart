import 'package:freezed_annotation/freezed_annotation.dart';

enum TipoUsuario {
  @JsonValue('tutor')
  tutor,
  @JsonValue('alumno')
  alumno,
}
