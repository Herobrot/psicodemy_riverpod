class ChatMessageModel {
  final String id;
  final String mensaje;
  final String estado;
  final DateTime fecha;
  final String usuarioId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAiResponse;
  final String? responseToMessageId;
  final String? conversationId;
  final String? recipientId;

  ChatMessageModel({
    required this.id,
    required this.mensaje,
    required this.estado,
    required this.fecha,
    required this.usuarioId,
    required this.createdAt,
    required this.updatedAt,
    required this.isAiResponse,
    this.responseToMessageId,
    this.conversationId,
    this.recipientId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      mensaje: json['mensaje'] ?? '',
      estado: json['estado'] ?? 'enviado',
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String()),
      usuarioId: json['usuario_id'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      isAiResponse: json['is_ai_response'] ?? false,
      responseToMessageId: json['response_to_message_id'],
      conversationId: json['conversation_id'],
      recipientId: json['recipient_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mensaje': mensaje,
      'estado': estado,
      'fecha': fecha.toIso8601String(),
      'usuario_id': usuarioId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_ai_response': isAiResponse,
      'response_to_message_id': responseToMessageId,
      'conversation_id': conversationId,
      'recipient_id': recipientId,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? mensaje,
    String? estado,
    DateTime? fecha,
    String? usuarioId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAiResponse,
    String? responseToMessageId,
    String? conversationId,
    String? recipientId,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      mensaje: mensaje ?? this.mensaje,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      usuarioId: usuarioId ?? this.usuarioId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAiResponse: isAiResponse ?? this.isAiResponse,
      responseToMessageId: responseToMessageId ?? this.responseToMessageId,
      conversationId: conversationId ?? this.conversationId,
      recipientId: recipientId ?? this.recipientId,
    );
  }
}
