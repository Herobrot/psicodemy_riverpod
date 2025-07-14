import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository_interface.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  // Datos mock para pruebas
  final List<AppointmentEntity> _mockAppointments = [
    AppointmentEntity(
      id: '1',
      tutorId: 'tutor1',
      studentId: 'student1',
      studentName: 'María González',
      topic: 'Problemas de ansiedad',
      scheduledDate: DateTime.now(),
      timeSlot: '14:30',
      status: AppointmentStatus.pending,
      notes: 'Primera sesión',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppointmentEntity(
      id: '2',
      tutorId: 'tutor1',
      studentId: 'student2',
      studentName: 'Carlos Rodríguez',
      topic: 'Estrés académico',
      scheduledDate: DateTime.now(),
      timeSlot: '16:00',
      status: AppointmentStatus.pending,
      notes: 'Seguimiento',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AppointmentEntity(
      id: '3',
      tutorId: 'tutor1',
      studentId: 'student3',
      studentName: 'Ana Martínez',
      topic: 'Autoestima',
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '10:00',
      status: AppointmentStatus.confirmed,
      notes: 'Nueva paciente',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    AppointmentEntity(
      id: '4',
      tutorId: 'tutor1',
      studentId: 'student4',
      studentName: 'Juan Pérez',
      topic: 'Depresión',
      scheduledDate: DateTime.now(),
      timeSlot: '09:00',
      status: AppointmentStatus.completed,
      notes: 'Sesión completada',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppointmentEntity(
      id: '5',
      tutorId: 'tutor1',
      studentId: 'student5',
      studentName: 'Laura Sánchez',
      topic: 'Ansiedad social',
      scheduledDate: DateTime.now(),
      timeSlot: '11:00',
      status: AppointmentStatus.inProgress,
      notes: 'En progreso',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<List<AppointmentEntity>> getTutorAppointments(String tutorId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAppointments.where((appointment) => appointment.tutorId == tutorId).toList();
  }

  @override
  Future<List<AppointmentEntity>> getPendingAppointments(String tutorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAppointments.where((appointment) => 
      appointment.tutorId == tutorId && 
      appointment.status == AppointmentStatus.pending
    ).toList();
  }

  @override
  Future<List<AppointmentEntity>> getTodayAppointments(String tutorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAppointments.where((appointment) => 
      appointment.tutorId == tutorId && 
      appointment.isToday
    ).toList();
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockAppointments.firstWhere((appointment) => appointment.id == appointmentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newAppointment = AppointmentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tutorId: appointment.tutorId,
      studentId: appointment.studentId,
      studentName: appointment.studentName,
      topic: appointment.topic,
      scheduledDate: appointment.scheduledDate,
      timeSlot: appointment.timeSlot,
      status: appointment.status,
      notes: appointment.notes,
      createdAt: DateTime.now(),
    );
    _mockAppointments.add(newAppointment);
    return newAppointment;
  }

  @override
  Future<AppointmentEntity> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockAppointments.indexWhere((appointment) => appointment.id == appointmentId);
    if (index != -1) {
      final appointment = _mockAppointments[index];
      final updatedAppointment = AppointmentEntity(
        id: appointment.id,
        tutorId: appointment.tutorId,
        studentId: appointment.studentId,
        studentName: appointment.studentName,
        topic: appointment.topic,
        scheduledDate: appointment.scheduledDate,
        timeSlot: appointment.timeSlot,
        status: status,
        notes: appointment.notes,
        createdAt: appointment.createdAt,
        updatedAt: DateTime.now(),
        completedAt: status == AppointmentStatus.completed ? DateTime.now() : appointment.completedAt,
      );
      _mockAppointments[index] = updatedAppointment;
      return updatedAppointment;
    }
    throw Exception('Appointment not found');
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    await updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
  }

  @override
  Future<AppointmentEntity> rescheduleAppointment(String appointmentId, DateTime newDate, String newTimeSlot) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockAppointments.indexWhere((appointment) => appointment.id == appointmentId);
    if (index != -1) {
      final appointment = _mockAppointments[index];
      final updatedAppointment = AppointmentEntity(
        id: appointment.id,
        tutorId: appointment.tutorId,
        studentId: appointment.studentId,
        studentName: appointment.studentName,
        topic: appointment.topic,
        scheduledDate: newDate,
        timeSlot: newTimeSlot,
        status: AppointmentStatus.rescheduled,
        notes: appointment.notes,
        createdAt: appointment.createdAt,
        updatedAt: DateTime.now(),
        completedAt: appointment.completedAt,
      );
      _mockAppointments[index] = updatedAppointment;
      return updatedAppointment;
    }
    throw Exception('Appointment not found');
  }

  @override
  Future<Map<String, int>> getAppointmentStats(String tutorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final appointments = await getTutorAppointments(tutorId);
    
    final stats = <String, int>{};
    for (final status in AppointmentStatus.values) {
      stats[status.displayName] = appointments.where((a) => a.status == status).length;
    }
    
    // Agregar estadísticas adicionales
    stats['Total'] = appointments.length;
    stats['Hoy'] = appointments.where((a) => a.isToday).length;
    stats['Esta semana'] = appointments.where((a) {
      final now = DateTime.now();
      final weekFromNow = now.add(const Duration(days: 7));
      return a.scheduledDate.isAfter(now) && a.scheduledDate.isBefore(weekFromNow);
    }).length;
    
    return stats;
  }

  @override
  Stream<List<AppointmentEntity>> watchTutorAppointments(String tutorId) {
    // Simular stream en tiempo real
    return Stream.periodic(const Duration(seconds: 5), (_) {
      return _mockAppointments.where((appointment) => appointment.tutorId == tutorId).toList();
    });
  }
} 