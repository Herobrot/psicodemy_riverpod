class AppointmentEntity {
  final String id;
  final String tutorId;
  final String studentId;
  final String studentName;
  final String topic;
  final DateTime scheduledDate;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const AppointmentEntity({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.studentName,
    required this.topic,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  // Método para verificar si la cita es de hoy
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
           scheduledDate.month == now.month &&
           scheduledDate.day == now.day;
  }

  // Método para verificar si la cita es de mañana
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return scheduledDate.year == tomorrow.year &&
           scheduledDate.month == tomorrow.month &&
           scheduledDate.day == tomorrow.day;
  }

  // Método para obtener el estado como string
  String get statusText {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pendiente';
      case AppointmentStatus.confirmed:
        return 'Confirmada';
      case AppointmentStatus.inProgress:
        return 'En progreso';
      case AppointmentStatus.completed:
        return 'Completada';
      case AppointmentStatus.cancelled:
        return 'Cancelada';
      case AppointmentStatus.rescheduled:
        return 'Reprogramada';
    }
  }

  // Método para obtener el color del estado
  int get statusColor {
    switch (status) {
      case AppointmentStatus.pending:
        return 0xFFFF9800; // Orange
      case AppointmentStatus.confirmed:
        return 0xFF2196F3; // Blue
      case AppointmentStatus.inProgress:
        return 0xFF4CAF50; // Green
      case AppointmentStatus.completed:
        return 0xFF4CAF50; // Green
      case AppointmentStatus.cancelled:
        return 0xFFF44336; // Red
      case AppointmentStatus.rescheduled:
        return 0xFF9C27B0; // Purple
    }
  }

  @override
  String toString() {
    return 'AppointmentEntity(id: $id, studentName: $studentName, topic: $topic, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentEntity &&
        other.id == id &&
        other.tutorId == tutorId &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.topic == topic &&
        other.scheduledDate == scheduledDate &&
        other.timeSlot == timeSlot &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tutorId.hashCode ^
        studentId.hashCode ^
        studentName.hashCode ^
        topic.hashCode ^
        scheduledDate.hashCode ^
        timeSlot.hashCode ^
        status.hashCode;
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

// Extensión para facilitar el trabajo con AppointmentStatus
extension AppointmentStatusExtension on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pendiente';
      case AppointmentStatus.confirmed:
        return 'Confirmada';
      case AppointmentStatus.inProgress:
        return 'En progreso';
      case AppointmentStatus.completed:
        return 'Completada';
      case AppointmentStatus.cancelled:
        return 'Cancelada';
      case AppointmentStatus.rescheduled:
        return 'Reprogramada';
    }
  }

  String get jsonValue {
    switch (this) {
      case AppointmentStatus.pending:
        return 'pending';
      case AppointmentStatus.confirmed:
        return 'confirmed';
      case AppointmentStatus.inProgress:
        return 'in_progress';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.rescheduled:
        return 'rescheduled';
    }
  }
} 