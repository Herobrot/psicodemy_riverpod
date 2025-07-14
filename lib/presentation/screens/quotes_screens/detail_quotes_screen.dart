import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';
import '../../../core/services/tutors/providers/tutor_providers.dart';

class DetalleCitaScreen extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  
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
        title: Text(
          'Cita - ${widget.appointment.estadoCita.displayName}', 
          style: const TextStyle(
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
                final tutorAsync = ref.watch(tutorByIdProvider(widget.appointment.idTutor));
                
                return tutorAsync.when(
                  data: (tutor) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.appointment.estadoCita),
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
                              color: _getStatusColor(widget.appointment.estadoCita),
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
                                minimumSize: const Size(100, 35),
                              ),
                              child: Text(
                                'WhatsApp',
                                style: TextStyle(
                                  color: _getStatusColor(widget.appointment.estadoCita),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: tutor != null ? () => _contactTutor(tutor.correo, 'email') : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(100, 35),
                              ),
                              child: Text(
                                'Correo',
                                style: TextStyle(
                                  color: _getStatusColor(widget.appointment.estadoCita),
                                  fontSize: 12,
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
                        Text('Cargando información del tutor...'),
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
                        Text(
                          'Error al cargar información del tutor',
                          style: TextStyle(color: Colors.white),
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
                    'Tu cita es el ${widget.appointment.fechaCita.day} de ${_getMonthName(widget.appointment.fechaCita.month)} del ${widget.appointment.fechaCita.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hora: ${widget.appointment.fechaCita.hour.toString().padLeft(2, '0')}:${widget.appointment.fechaCita.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(widget.appointment.estadoCita),
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estado: ${widget.appointment.estadoCita.displayName}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Tareas por hacer
            const Text(
              'Por Hacer',
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
                widget.appointment.toDo?.isNotEmpty == true
                    ? '• ${widget.appointment.toDo}'
                    : 'No hay tareas específicas definidas para esta cita',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.appointment.toDo?.isNotEmpty == true 
                      ? Colors.black87 
                      : Colors.grey.shade600,
                  fontStyle: widget.appointment.toDo?.isNotEmpty == true 
                      ? FontStyle.normal 
                      : FontStyle.italic,
                ),
              ),
            ),
            
            // Tareas completadas (si existen)
            if (widget.appointment.finishToDo?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              const Text(
                'Tareas Completadas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  '✓ ${widget.appointment.finishToDo}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
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
        if (widget.appointment.estadoCita == EstadoCita.pendiente) ...[
          Row(
            children: [
              
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateAppointmentStatus(EstadoCita.cancelada),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar Cita'),
                ),
              ),
            ],
          ),
        ] else if (widget.appointment.estadoCita == EstadoCita.confirmada) ...[
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
                const Text(
                  'Cita confirmada - Contacta al tutor para cancelar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ] else if (widget.appointment.estadoCita == EstadoCita.completada) ...[
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
                const Text(
                  'Cita completada exitosamente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ] else if (widget.appointment.estadoCita == EstadoCita.cancelada) ...[
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
                const Text(
                  'Esta cita fue cancelada',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _updateAppointmentStatus(EstadoCita newStatus) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await ref.read(
        updateAppointmentStatusProvider({
          'id': widget.appointment.id,
          'estado': newStatus,
        }).future,
      );

      if (mounted) {
        Navigator.pop(context); // Cerrar loading
        Navigator.pop(context); // Volver a la pantalla anterior

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cita actualizada a: ${newStatus.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refrescar la lista de citas
      ref.read(appointmentListProvider.notifier).refresh();

    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _contactTutor(String email, String method) {
    // Aquí puedes implementar la lógica para contactar al tutor
    String message = '';
    
    if (method == 'whatsapp') {
      message = 'Contactar por WhatsApp no implementado aún';
    } else if (method == 'email') {
      message = 'Puedes contactar al tutor en: $email';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Color _getStatusColor(EstadoCita estado) {
    switch (estado) {
      case EstadoCita.pendiente:
        return Colors.orange;
      case EstadoCita.confirmada:
        return const Color(0xFF5CC9C0);
      case EstadoCita.completada:
        return Colors.green;
      case EstadoCita.cancelada:
        return Colors.red;
      case EstadoCita.no_asistio:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(EstadoCita estado) {
    switch (estado) {
      case EstadoCita.pendiente:
        return Icons.schedule;
      case EstadoCita.confirmada:
        return Icons.check_circle;
      case EstadoCita.completada:
        return Icons.done_all;
      case EstadoCita.cancelada:
        return Icons.cancel;
      case EstadoCita.no_asistio:
        return Icons.person_off;
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
