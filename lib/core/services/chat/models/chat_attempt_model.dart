class ChatAttemptModel {
  final String id;
  final String estudianteId;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final double? duracionMinutos;
  final int mensajesEnviados;
  final String estado;

  ChatAttemptModel({
    required this.id,
    required this.estudianteId,
    required this.fechaInicio,
    this.fechaFin,
    this.duracionMinutos,
    required this.mensajesEnviados,
    required this.estado,
  });

  factory ChatAttemptModel.fromJson(Map<String, dynamic> json) {
    return ChatAttemptModel(
      id: json['id'] ?? '',
      estudianteId: json['estudiante_id'] ?? '',
      fechaInicio: DateTime.parse(json['fecha_inicio'] ?? DateTime.now().toIso8601String()),
      fechaFin: json['fecha_fin'] != null 
          ? DateTime.parse(json['fecha_fin']) 
          : null,
      duracionMinutos: json['duracion_minutos']?.toDouble(),
      mensajesEnviados: json['mensajes_enviados'] ?? 0,
      estado: json['estado'] ?? 'activo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estudiante_id': estudianteId,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'duracion_minutos': duracionMinutos,
      'mensajes_enviados': mensajesEnviados,
      'estado': estado,
    };
  }

  ChatAttemptModel copyWith({
    String? id,
    String? estudianteId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    double? duracionMinutos,
    int? mensajesEnviados,
    String? estado,
  }) {
    return ChatAttemptModel(
      id: id ?? this.id,
      estudianteId: estudianteId ?? this.estudianteId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      mensajesEnviados: mensajesEnviados ?? this.mensajesEnviados,
      estado: estado ?? this.estado,
    );
  }
} 