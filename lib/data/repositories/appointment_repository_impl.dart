import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository_interface.dart';
import '../../core/services/appointments/appointment_service.dart';
import '../../core/services/appointments/models/appointment_model.dart';
import '../../core/services/auth/repositories/secure_storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/auth/models/complete_user_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentService _appointmentService;

  AppointmentRepositoryImpl(this._appointmentService);

  @override
  Future<List<AppointmentEntity>> getTutorAppointments(String tutorId) async {
    // Ignorar el parámetro tutorId y obtener siempre el userId de la API desde el storage
    String? realTutorId;
    final storage = SecureStorageRepositoryImpl(const FlutterSecureStorage());
    final savedUserData = await storage.read('complete_user_data');
    if (savedUserData != null) {
      try {
        final userData = CompleteUserModel.fromJson(savedUserData);
        realTutorId = userData.userId;
      } catch (e) {
        // Si falla, dejar realTutorId como null
      }
    }
    final List<AppointmentModel> models = await _appointmentService.getAppointments(idTutor: realTutorId);
    return models.map((m) => AppointmentEntity(
      id: m.id,
      tutorId: m.idTutor,
      studentId: m.idAlumno,
      studentName: m.idAlumno, // Si tienes el nombre real, cámbialo aquí
      topic: m.reason ?? '',
      scheduledDate: m.fechaCita,
      timeSlot: '${m.fechaCita.hour.toString().padLeft(2, '0')}:${m.fechaCita.minute.toString().padLeft(2, '0')}',
      status: _mapEstadoCitaToAppointmentStatus(m.estadoCita),
      notes: m.reason,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      completedAt: null,
    )).toList();
  }

  AppointmentStatus _mapEstadoCitaToAppointmentStatus(EstadoCita estado) {
    switch (estado) {
      case EstadoCita.pendiente:
        return AppointmentStatus.pending;
      case EstadoCita.confirmada:
        return AppointmentStatus.confirmed;
      case EstadoCita.completada:
        return AppointmentStatus.completed;
      case EstadoCita.cancelada:
        return AppointmentStatus.cancelled;
      case EstadoCita.noAsistio:
        return AppointmentStatus.cancelled;
    }
  }

  @override
  Future<List<AppointmentEntity>> getPendingAppointments(String tutorId) async {
    final List<AppointmentModel> models = await _appointmentService.getAppointments(
      idTutor: tutorId,
      estadoCita: EstadoCita.pendiente,
    );
    return models.map((m) => AppointmentEntity(
      id: m.id,
      tutorId: m.idTutor,
      studentId: m.idAlumno,
      studentName: '',
      topic: '',
      scheduledDate: m.fechaCita,
      timeSlot: '',
      status: _mapEstadoCitaToAppointmentStatus(m.estadoCita),
      notes: m.reason,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      completedAt: null,
    )).toList();
  }

  @override
  Future<List<AppointmentEntity>> getTodayAppointments(String tutorId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final List<AppointmentModel> models = await _appointmentService.getAppointments(
      idTutor: tutorId,
      fechaDesde: start,
      fechaHasta: end,
    );
    return models.map((m) => AppointmentEntity(
      id: m.id,
      tutorId: m.idTutor,
      studentId: m.idAlumno,
      studentName: '',
      topic: '',
      scheduledDate: m.fechaCita,
      timeSlot: '',
      status: _mapEstadoCitaToAppointmentStatus(m.estadoCita),
      notes: m.reason,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      completedAt: null,
    )).toList();
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String appointmentId) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<AppointmentEntity> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<AppointmentEntity> rescheduleAppointment(String appointmentId, DateTime newDate, String newTimeSlot) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<Map<String, int>> getAppointmentStats(String tutorId) async {
    final appointments = await getTutorAppointments(tutorId);
    final now = DateTime.now();
    int hoy = 0;
    int pendientes = 0;
    int completadas = 0;

    for (final cita in appointments) {
      if (cita.scheduledDate.year == now.year &&
          cita.scheduledDate.month == now.month &&
          cita.scheduledDate.day == now.day) {
        hoy++;
      }
      if (cita.status == AppointmentStatus.pending || cita.status == AppointmentStatus.confirmed) {
        pendientes++;
      }
      if (cita.status == AppointmentStatus.completed) {
        completadas++;
      }
    }

    return {
      'Hoy': hoy,
      'Pendiente': pendientes,
      'Completada': completadas,
    };
  }

  @override
  Future<List<AppointmentEntity>> getStudentAppointments(String studentId) async {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }

  @override
  Future<List<AppointmentEntity>> getStudentAppointmentsFiltered({
    required String studentId,
    required AppointmentStatus estadoCita,
    required DateTime fechaDesde,
    int limit = 10,
  }) async {
    // Mapear AppointmentStatus a EstadoCita
    EstadoCita estado;
    switch (estadoCita) {
      case AppointmentStatus.pending:
        estado = EstadoCita.pendiente;
        break;
      case AppointmentStatus.confirmed:
        estado = EstadoCita.confirmada;
        break;
      case AppointmentStatus.completed:
        estado = EstadoCita.completada;
        break;
      case AppointmentStatus.cancelled:
        estado = EstadoCita.cancelada;
        break;
      case AppointmentStatus.inProgress:
        estado = EstadoCita.pendiente;
        break;
      case AppointmentStatus.rescheduled:
        estado = EstadoCita.pendiente;
        break;
    }
    final List<AppointmentModel> models = await _appointmentService.getAppointments(
      idAlumno: studentId,
      estadoCita: estado,
      fechaDesde: fechaDesde,
      limit: limit,
    );
    return models.map((m) => AppointmentEntity(
      id: m.id,
      tutorId: m.idTutor,
      studentId: m.idAlumno,
      studentName: '',
      topic: '',
      scheduledDate: m.fechaCita,
      timeSlot: '',
      status: _mapEstadoCitaToAppointmentStatus(m.estadoCita),
      notes: m.reason,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      completedAt: null,
    )).toList();
  }

  @override
  Stream<List<AppointmentEntity>> watchTutorAppointments(String tutorId) {
    // TODO: Implementar usando AppointmentService
    throw UnimplementedError();
  }
} 