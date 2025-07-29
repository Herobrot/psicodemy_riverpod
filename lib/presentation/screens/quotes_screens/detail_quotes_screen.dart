import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';
import '../../../core/services/tutors/providers/tutor_providers.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../providers/appointment_providers.dart';

class DetalleCitaScreen extends ConsumerStatefulWidget {
  final AppointmentEntity appointment;
  
  const DetalleCitaScreen({
    super.key,
    required this.appointment,
  });

  @override
  ConsumerState<DetalleCitaScreen> createState() => _DetalleCitaScreenState();
}

class _DetalleCitaScreenState extends ConsumerState<DetalleCitaScreen> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cita',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // TODO: Ir a perfil
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: user?.photoURL != null 
                  ? NetworkImage(user!.photoURL!)
                  : const NetworkImage('https://lh3.googleusercontent.com/a/default-user=s96-c'),
                child: user?.photoURL == null 
                  ? Text(
                      user?.email?.isNotEmpty == true 
                        ? user!.email![0].toUpperCase() 
                        : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del tutor
            Consumer(
              builder: (context, ref, child) {
                final tutorAsync = ref.watch(tutorByIdProvider(widget.appointment.tutorId));
                
                return tutorAsync.when(
                  data: (tutor) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.appointment.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            tutor?.nombre.isNotEmpty == true ? tutor!.nombre[0] : 'T',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(widget.appointment.status),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Información del tutor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tutor?.nombre ?? 'Tutor no encontrado',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                tutor?.correo ?? '',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: tutor != null ? () => _contactTutor(tutor.correo, 'whatsapp') : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(80, 30),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: Text(
                                'WhatsApp',
                                style: TextStyle(
                                  color: _getStatusColor(widget.appointment.status),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: tutor != null ? () => _contactTutor(tutor.correo, 'email') : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(80, 30),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: Text(
                                'Correo',
                                style: TextStyle(
                                  color: _getStatusColor(widget.appointment.status),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  loading: () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Cargando información del tutor...'),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error al cargar información del tutor',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Información de la cita
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu cita es el ${widget.appointment.scheduledDate.day} de ${_getMonthName(widget.appointment.scheduledDate.month)} del ${widget.appointment.scheduledDate.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hora: ${widget.appointment.scheduledDate.hour.toString().padLeft(2, '0')}:${widget.appointment.scheduledDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(widget.appointment.status),
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Estado: ${widget.appointment.statusText}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Información adicional
            if (widget.appointment.topic.isNotEmpty) ...[
              const Text(
                'Tema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  widget.appointment.topic,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Notas
            if (widget.appointment.notes != null && widget.appointment.notes!.isNotEmpty) ...[
              const Text(
                'Notas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  widget.appointment.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            const Spacer(),
            
            // Botones de acción
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (widget.appointment.status == AppointmentStatus.pending) ...[
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateAppointmentStatus(AppointmentStatus.cancelled),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar Cita'),
                ),
              ),
            ],
          ),
        ] else if (widget.appointment.status == AppointmentStatus.confirmed) ...[
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateAppointmentStatus(AppointmentStatus.cancelled),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar Cita'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cita confirmada - Contacta al tutor si necesitas reprogramar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.appointment.status == AppointmentStatus.completed) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'Cita completada exitosamente',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.appointment.status == AppointmentStatus.cancelled) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'Esta cita fue cancelada',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _updateAppointmentStatus(AppointmentStatus newStatus) async {
    try {
      // Mostrar diálogo de confirmación para cancelar
      if (newStatus == AppointmentStatus.cancelled) {
        final shouldCancel = await _showCancelConfirmationDialog();
        if (!shouldCancel) return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Usar el provider de acciones para cancelar la cita
      final actions = ref.read(appointmentActionsProvider);
      await actions.cancelAppointment(widget.appointment.id);

      if (mounted) {
        Navigator.pop(context); // Cerrar loading
        Navigator.pop(context); // Volver a la pantalla anterior

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita cancelada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cancelar la cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showCancelConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Cita'),
          content: const Text(
            '¿Estás seguro de que deseas cancelar esta cita? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, Cancelar'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _contactTutor(String email, String method) {
    if (method == 'whatsapp') {
      _openWhatsApp(email);
    } else if (method == 'email') {
      _openEmail(email);
    }
  }

  void _openWhatsApp(String email) {
    // Por ahora mostramos un mensaje, pero se puede implementar con url_launcher
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funcionalidad de WhatsApp en desarrollo. Contacta al tutor por correo electrónico.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _openEmail(String email) {
    // Por ahora mostramos el correo, pero se puede implementar con url_launcher
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contactar al Tutor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Puedes contactar al tutor en:'),
              const SizedBox(height: 8),
              SelectableText(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return const Color(0xFF5CC9C0);
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.inProgress:
        return Colors.blueGrey;
      case AppointmentStatus.rescheduled:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Icons.schedule;
      case AppointmentStatus.confirmed:
        return Icons.check_circle;
      case AppointmentStatus.completed:
        return Icons.done_all;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
      case AppointmentStatus.inProgress:
        return Icons.timelapse;
      case AppointmentStatus.rescheduled:
        return Icons.update;
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month];
  }
}
