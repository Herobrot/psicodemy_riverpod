import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../appointment_service.dart';
import '../models/appointment_model.dart';
import '../../api_service_provider.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AppointmentService(apiService);
});

final appointmentListProvider = FutureProvider<List<AppointmentModel>>((
  ref,
) async {
  final service = ref.watch(appointmentServiceProvider);
  return await service.getAppointments();
});

final appointmentByIdProvider = FutureProvider.family<AppointmentModel, String>(
  (ref, id) async {
    final service = ref.watch(appointmentServiceProvider);
    return await service.getAppointmentById(id);
  },
);

final createAppointmentProvider =
    FutureProvider.family<AppointmentModel, CreateAppointmentRequest>((
      ref,
      request,
    ) async {
      final service = ref.watch(appointmentServiceProvider);
      return await service.createAppointment(request);
    });

final updateAppointmentProvider =
    FutureProvider.family<AppointmentModel, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final service = ref.watch(appointmentServiceProvider);
      return await service.updateAppointment(params['id'], params['request']);
    });

final updateAppointmentStatusProvider =
    FutureProvider.family<AppointmentModel, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final service = ref.watch(appointmentServiceProvider);
      return await service.updateAppointmentStatus(
        params['id'],
        params['request'],
      );
    });

final deleteAppointmentProvider = FutureProvider.family<bool, String>((
  ref,
  id,
) async {
  final service = ref.watch(appointmentServiceProvider);
  return await service.deleteAppointment(id);
});

final healthCheckProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(appointmentServiceProvider);
  return await service.healthCheck();
});

final detailedHealthCheckProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final service = ref.watch(appointmentServiceProvider);
  return await service.detailedHealthCheck();
});

final scheduleConflictProvider =
    FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
      final service = ref.watch(appointmentServiceProvider);
      return await service.hasScheduleConflict(
        params['tutorId'],
        params['fechaCita'],
        excludeAppointmentId: params['excludeAppointmentId'],
      );
    });
