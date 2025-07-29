import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/api_service_provider.dart';
import '../../widgets/user_name_display.dart';

class TutorAppointmentDetailScreen extends ConsumerStatefulWidget {
  final AppointmentEntity appointment;
  const TutorAppointmentDetailScreen({super.key, required this.appointment});

  @override
  ConsumerState<TutorAppointmentDetailScreen> createState() =>
      _TutorAppointmentDetailScreenState();
}

class _TutorAppointmentDetailScreenState
    extends ConsumerState<TutorAppointmentDetailScreen> {
  late List<ChecklistItem> _checklist;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    // Inicializar checklist vacío por ahora, ya que AppointmentEntity no tiene checklist
    _checklist = [];
    _reasonController = TextEditingController(
      text: widget.appointment.notes ?? '',
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _toggleCompleted(int index) {
    setState(() {
      _checklist[index] = ChecklistItem(
        description: _checklist[index].description,
        completed: !_checklist[index].completed,
      );
    });
    // Actualizar en la API
    _updateChecklist();
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
                    _checklist.add(
                      ChecklistItem(
                        description: controller.text.trim(),
                        completed: false,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  // Actualizar en la API
                  _updateChecklist();
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
        final controller = TextEditingController(
          text: _checklist[index].description,
        );
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
                    _checklist[index] = ChecklistItem(
                      description: controller.text.trim(),
                      completed: _checklist[index].completed,
                    );
                  });
                  Navigator.pop(context);
                  // Actualizar en la API
                  _updateChecklist();
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
    // Actualizar en la API
    _updateChecklist();
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Cita'),
          content: const Text(
            '¿Estás seguro de que deseas cancelar esta cita? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateAppointmentStatus('cancelada');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cita'),
          content: const Text(
            '¿Estás seguro de que deseas confirmar esta cita?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateAppointmentStatus('confirmada');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showCompleteAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marcar como Completa'),
          content: const Text(
            '¿Estás seguro de que deseas marcar esta cita como completa?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateAppointmentStatus('completada');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, Completar'),
            ),
          ],
        );
      },
    );
  }

  void _showNoShowAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marcar como No Asistió'),
          content: const Text(
            '¿Estás seguro de que deseas marcar esta cita como "No Asistió"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateAppointmentStatus('no_asistio');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, No Asistió'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAppointmentStatus(String status) async {
    try {
      final apiService = ref.read(apiServiceProvider);

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Actualizar estado de la cita
      await apiService.updateAppointmentStatus(widget.appointment.id, {
        'estado_cita': status,
      });

      // Cerrar indicador de carga
      Navigator.of(context).pop();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita marcada como $status exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar de vuelta a la pantalla anterior
      Navigator.of(context).pop(true);
    } catch (_) {
      // Cerrar indicador de carga si está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cita'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateChecklist() async {
    try {
      final apiService = ref.read(apiServiceProvider);

      // Convertir checklist a formato de API
      final checklistData = _checklist
          .map(
            (item) => {
              'description': item.description,
              'completed': item.completed,
            },
          )
          .toList();

      // Actualizar cita con nuevo checklist
      await apiService.updateAppointmentStatus(widget.appointment.id, {
        'checklist': checklistData,
      });
          
    } catch (_) {         
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar checklist'),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('Error al actualizar checklist:');
    }
  }

  Widget _buildActionButtons() {
    // Obtener el estado actual de la cita
    final currentStatus = widget.appointment.statusText.toLowerCase();

    switch (currentStatus) {
      case 'pendiente':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCancelConfirmationDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancelar Cita'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showConfirmAppointmentDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirmar Cita'),
              ),
            ),
          ],
        );

      case 'confirmada':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCompleteAppointmentDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Marcar como Completa'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showNoShowAppointmentDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('No Asistió'),
              ),
            ),
          ],
        );

      case 'completada':
      case 'cancelada':
      case 'no_asistio':
        return const SizedBox.shrink(); // No mostrar botones para estos estados

      default:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCancelConfirmationDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancelar Cita'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showConfirmAppointmentDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirmar Cita'),
              ),
            ),
          ],
        );
    }
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
                    : const NetworkImage(
                        'https://lh3.googleusercontent.com/a/default-user=s96-c',
                      ),
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
            // Información del alumno usando UserNameDisplay
            Row(
              children: [
                const Text(
                  'Alumno: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: UserNameDisplay(
                    userId: widget.appointment.studentId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflowVisible: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${_formatDate(widget.appointment.scheduledDate)}',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Hora: ${widget.appointment.timeSlot.isNotEmpty ? widget.appointment.timeSlot : '${widget.appointment.scheduledDate.hour.toString().padLeft(2, '0')}:${widget.appointment.scheduledDate.minute.toString().padLeft(2, '0')}'}',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Tema: ${widget.appointment.topic.isNotEmpty ? widget.appointment.topic : 'Sin tema especificado'}',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(widget.appointment.statusColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.appointment.statusText,
                style: TextStyle(
                  color: Color(widget.appointment.statusColor),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.appointment.notes != null &&
                widget.appointment.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Notas: ${widget.appointment.notes}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Checklist de tareas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addChecklistItem,
                  tooltip: 'Agregar tarea',
                ),
              ],
            ),
            Expanded(
              child: _checklist.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay tareas en el checklist',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _checklist.length,
                      itemBuilder: (context, index) {
                        final item = _checklist[index];
                        return ListTile(
                          leading: Checkbox(
                            value: item.completed,
                            onChanged: (_) => _toggleCompleted(index),
                          ),
                          title: Text(item.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editChecklistItem(index),
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeChecklistItem(index),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            // Botones de acción según el estado actual
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
