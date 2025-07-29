import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment_entity.dart';
import '../providers/appointment_providers.dart';

// Widget para mostrar detalles de la cita y permitir cancelarla
class AppointmentDetailScreen extends ConsumerWidget {
  final AppointmentEntity appointment;
  const AppointmentDetailScreen({required this.appointment, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tutor: ${appointment.tutorId}'),
            Text('Fecha: ${appointment.scheduledDate}'),
            Text('Estado: ${appointment.statusText}'),
            if (appointment.notes != null) Text('Notas: ${appointment.notes}'),
            const Spacer(),
            if (appointment.status == AppointmentStatus.pending || appointment.status == AppointmentStatus.confirmed)
              ElevatedButton(
                onPressed: () async {
                  final actions = ref.read(appointmentActionsProvider);
                  await actions.cancelAppointment(appointment.id);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cancelar cita'),
              ),
          ],
        ),
      ),
    );
  }
} 