// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    ChecklistItem(
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$ChecklistItemToJson(ChecklistItem instance) =>
    <String, dynamic>{
      'description': instance.description,
      'completed': instance.completed,
    };

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: json['id'] as String,
      idTutor: json['id_tutor'] as String,
      idAlumno: json['id_alumno'] as String,
      estadoCita: $enumDecode(_$EstadoCitaEnumMap, json['estado_cita']),
      fechaCita: DateTime.parse(json['fecha_cita'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      checklist:
          (json['checklist'] as List<dynamic>?)
              ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_tutor': instance.idTutor,
      'id_alumno': instance.idAlumno,
      'estado_cita': _$EstadoCitaEnumMap[instance.estadoCita]!,
      'fecha_cita': instance.fechaCita.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'checklist': instance.checklist,
      'reason': instance.reason,
    };

const _$EstadoCitaEnumMap = {
  EstadoCita.pendiente: 'pendiente',
  EstadoCita.confirmada: 'confirmada',
  EstadoCita.cancelada: 'cancelada',
  EstadoCita.completada: 'completada',
  EstadoCita.noAsistio: 'no_asistio',
};

CreateAppointmentRequest _$CreateAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => CreateAppointmentRequest(
  idTutor: json['id_tutor'] as String,
  idAlumno: json['id_alumno'] as String,
  fechaCita: DateTime.parse(json['fecha_cita'] as String),
  checklist:
      (json['checklist'] as List<dynamic>?)
          ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$CreateAppointmentRequestToJson(
  CreateAppointmentRequest instance,
) => <String, dynamic>{
  'id_tutor': instance.idTutor,
  'id_alumno': instance.idAlumno,
  'fecha_cita': instance.fechaCita.toIso8601String(),
  'checklist': instance.checklist,
  'reason': instance.reason,
};

UpdateAppointmentRequest _$UpdateAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => UpdateAppointmentRequest(
  estadoCita: $enumDecodeNullable(_$EstadoCitaEnumMap, json['estado_cita']),
  fechaCita: json['fecha_cita'] == null
      ? null
      : DateTime.parse(json['fecha_cita'] as String),
  checklist:
      (json['checklist'] as List<dynamic>?)
          ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$UpdateAppointmentRequestToJson(
  UpdateAppointmentRequest instance,
) => <String, dynamic>{
  'estado_cita': _$EstadoCitaEnumMap[instance.estadoCita],
  'fecha_cita': instance.fechaCita?.toIso8601String(),
  'checklist': instance.checklist,
  'reason': instance.reason,
};

UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) =>
    UpdateStatusRequest(
      estadoCita: $enumDecode(_$EstadoCitaEnumMap, json['estado_cita']),
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$UpdateStatusRequestToJson(
  UpdateStatusRequest instance,
) => <String, dynamic>{
  'estado_cita': _$EstadoCitaEnumMap[instance.estadoCita]!,
  'userId': instance.userId,
};

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrev: json['hasPrev'] as bool,
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };

AppointmentSuccessResponse _$AppointmentSuccessResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentSuccessResponse(
  data: json['data'],
  message: json['message'] as String,
  status: json['status'] as String,
  pagination: json['pagination'] == null
      ? null
      : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentSuccessResponseToJson(
  AppointmentSuccessResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'message': instance.message,
  'status': instance.status,
  'pagination': instance.pagination,
};

AppointmentErrorResponse _$AppointmentErrorResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentErrorResponse(
  data: json['data'],
  message: json['message'] as String,
  status: json['status'] as String,
  error: AppointmentError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentErrorResponseToJson(
  AppointmentErrorResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'message': instance.message,
  'status': instance.status,
  'error': instance.error,
};

AppointmentError _$AppointmentErrorFromJson(Map<String, dynamic> json) =>
    AppointmentError(
      code: json['code'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AppointmentErrorToJson(AppointmentError instance) =>
    <String, dynamic>{'code': instance.code, 'details': instance.details};
