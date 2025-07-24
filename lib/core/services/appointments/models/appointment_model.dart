import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

/// Estados posibles de una cita
enum EstadoCita {
  @JsonValue('pendiente')
  pendiente,
  @JsonValue('confirmada')
  confirmada,
  @JsonValue('cancelada')
  cancelada,
  @JsonValue('completada')
  completada,
  @JsonValue('no_asistio')
  noAsistio,
}

/// Modelo para un ítem de checklist
@JsonSerializable()
class ChecklistItem {
  final String description;
  final bool completed;

  const ChecklistItem({
    required this.description,
    required this.completed,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);
  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);
}

/// Alias de tipo para una lista de ChecklistItem
typedef Checklist = List<ChecklistItem>;

/// Modelo principal para las citas
@JsonSerializable()
class AppointmentModel {
  final String id;
  @JsonKey(name: 'id_tutor')
  final String idTutor;
  @JsonKey(name: 'id_alumno')
  final String idAlumno;
  @JsonKey(name: 'estado_cita')
  final EstadoCita estadoCita;
  @JsonKey(name: 'fecha_cita')
  final DateTime fechaCita;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @JsonKey(defaultValue: [], name: 'checklist')
  final Checklist checklist;
  @JsonKey(name: 'reason')
  final String? reason;

  const AppointmentModel({
    required this.id,
    required this.idTutor,
    required this.idAlumno,
    required this.estadoCita,
    required this.fechaCita,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.checklist = const [],
    this.reason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);

  @override
  String toString() {
    return 'AppointmentModel(id: $id, idTutor: $idTutor, idAlumno: $idAlumno, estadoCita: $estadoCita, fechaCita: $fechaCita)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentModel &&
        other.id == id &&
        other.idTutor == idTutor &&
        other.idAlumno == idAlumno;
  }

  @override
  int get hashCode {
    return id.hashCode ^ idTutor.hashCode ^ idAlumno.hashCode;
  }
}

/// Request para crear una nueva cita
@JsonSerializable()
class CreateAppointmentRequest {
  @JsonKey(name: 'id_tutor')
  final String idTutor;
  @JsonKey(name: 'id_alumno')
  final String idAlumno;
  @JsonKey(name: 'fecha_cita')
  final DateTime fechaCita;
  @JsonKey(defaultValue: [], name: 'checklist')
  final Checklist checklist;
  @JsonKey(name: 'reason')
  final String? reason;

  const CreateAppointmentRequest({
    required this.idTutor,
    required this.idAlumno,
    required this.fechaCita,
    this.checklist = const [],
    this.reason,
  });

  factory CreateAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppointmentRequestToJson(this);
}

/// Request para actualizar una cita completa
@JsonSerializable()
class UpdateAppointmentRequest {
  @JsonKey(name: 'estado_cita')
  final EstadoCita? estadoCita;
  @JsonKey(name: 'fecha_cita')
  final DateTime? fechaCita;
  @JsonKey(defaultValue: [], name: 'checklist')
  final Checklist? checklist;
  @JsonKey(name: 'reason')
  final String? reason;

  const UpdateAppointmentRequest({
    this.estadoCita,
    this.fechaCita,
    this.checklist,
    this.reason,
  });

  factory UpdateAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAppointmentRequestToJson(this);
}

/// Request para actualizar solo el estado de una cita
@JsonSerializable()
class UpdateStatusRequest {
  @JsonKey(name: 'estado_cita')
  final EstadoCita estadoCita;
  @JsonKey(name: 'userId')
  final String? userId;

  const UpdateStatusRequest({
    required this.estadoCita,
    this.userId,
  });

  factory UpdateStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStatusRequestToJson(this);
}

/// Metadatos de paginación
@JsonSerializable()
class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

/// Respuesta de éxito de la API
@JsonSerializable()
class AppointmentSuccessResponse {
  final dynamic data;
  final String message;
  final String status;
  final PaginationMeta? pagination;

  const AppointmentSuccessResponse({
    required this.data,
    required this.message,
    required this.status,
    this.pagination,
  });

  factory AppointmentSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSuccessResponseToJson(this);
}

/// Respuesta de error de la API
@JsonSerializable()
class AppointmentErrorResponse {
  final dynamic data;
  final String message;
  final String status;
  final AppointmentError error;

  const AppointmentErrorResponse({
    required this.data,
    required this.message,
    required this.status,
    required this.error,
  });

  factory AppointmentErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentErrorResponseToJson(this);
}

/// Detalles del error
@JsonSerializable()
class AppointmentError {
  final String code;
  final Map<String, dynamic>? details;

  const AppointmentError({
    required this.code,
    this.details,
  });

  factory AppointmentError.fromJson(Map<String, dynamic> json) =>
      _$AppointmentErrorFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentErrorToJson(this);
}

// Extensión para mostrar nombres legibles de EstadoCita
extension EstadoCitaExtension on EstadoCita {
  String get displayName {
    switch (this) {
      case EstadoCita.pendiente:
        return 'Pendiente';
      case EstadoCita.confirmada:
        return 'Confirmada';
      case EstadoCita.completada:
        return 'Completada';
      case EstadoCita.cancelada:
        return 'Cancelada';
      case EstadoCita.noAsistio:
        return 'No asistió';
    }
  }
}