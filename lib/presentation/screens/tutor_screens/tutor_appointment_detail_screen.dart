import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';

class TutorAppointmentDetailScreen extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  const TutorAppointmentDetailScreen({super.key, required this.appointment});

  @override
  ConsumerState<TutorAppointmentDetailScreen> createState() => _TutorAppointmentDetailScreenState();
}

class _TutorAppointmentDetailScreenState extends ConsumerState<TutorAppointmentDetailScreen> {
  late List<ChecklistItem> _checklist;

  @override
  void initState() {
    super.initState();
    _checklist = List<ChecklistItem>.from(widget.appointment.checklist);
  }

  void _toggleCompleted(int index) {
    setState(() {
      _checklist[index] = ChecklistItem(
        description: _checklist[index].description,
        completed: !_checklist[index].completed,
      );
    });
  }

  void _addChecklistItem() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Agregar tarea'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Descripción'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _checklist.add(ChecklistItem(description: controller.text.trim(), completed: false));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _editChecklistItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _checklist[index].description);
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Descripción'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _checklist[index] = ChecklistItem(description: controller.text.trim(), completed: _checklist[index].completed);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklist.removeAt(index);
    });
  }

  Future<void> _saveChecklist() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      final request = UpdateAppointmentRequest(
        estadoCita: widget.appointment.estadoCita,
        fechaCita: widget.appointment.fechaCita,
        checklist: _checklist,
        reason: widget.appointment.reason,
      );
      try {
        await ref.read(updateAppointmentProvider({
          'id': widget.appointment.id,
          'request': request,
        }).future);
        if (mounted) {
          Navigator.pop(context); // Cerrar loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checklist actualizado'), backgroundColor: Colors.green),
          );
          // Refrescar lista de citas
          ref.invalidate(appointmentListProvider);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          final errorMsg = e.toString().contains('no puede ser modificada en su estado actual')
              ? 'No puedes modificar la cita en su estado actual.'
              : 'Error al actualizar: $e';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e'), backgroundColor: Colors.red),
        );
      }
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
      case EstadoCita.noAsistio:
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
      case EstadoCita.noAsistio:
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Detalle de la cita',
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
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const NetworkImage('https://lh3.googleusercontent.com/a/default-user=s96-c'),
                child: user?.photoURL == null
                    ? Text(
                        user?.email?.isNotEmpty == true
                            ? user!.email![0].toUpperCase()
                            : 'T',
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
            // Información del alumno
            Container(
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
                      widget.appointment.idAlumno.isNotEmpty ? widget.appointment.idAlumno[0] : 'A',
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
                          'Información del alumno',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.appointment.idAlumno,
                          style: const TextStyle(color: Colors.white),
                        ),
                        // Aquí podrías mostrar más info del alumno si la tienes
                      ],
                    ),
                  ),
                ],
              ),
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
                    'Cita el ${widget.appointment.fechaCita.day} de ${_getMonthName(widget.appointment.fechaCita.month)} del ${widget.appointment.fechaCita.year}',
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
                        'Estado:',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Checklist editable
            const Text(
              'Tareas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_checklist.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'No hay tareas específicas definidas para esta cita',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              )
            else ...[
              ..._checklist.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.completed,
                          onChanged: (val) {
                            final idx = _checklist.indexOf(item);
                            _toggleCompleted(idx);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.description, style: const TextStyle(fontSize: 14))),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {
                            final idx = _checklist.indexOf(item);
                            _editChecklistItem(idx);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: () {
                            final idx = _checklist.indexOf(item);
                            _removeChecklistItem(idx);
                          },
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addChecklistItem,
                icon: const Icon(Icons.add),
                label: const Text('Agregar tarea'),
              ),
            ),
            if (widget.appointment.reason != null && widget.appointment.reason!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Razón: ${widget.appointment.reason}', style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChecklist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 