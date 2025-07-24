import 'package:flutter/material.dart';
import '../../../core/services/appointments/models/appointment_model.dart';

class TutorAppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel appointment;
  const TutorAppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<TutorAppointmentDetailScreen> createState() => _TutorAppointmentDetailScreenState();
}

class _TutorAppointmentDetailScreenState extends State<TutorAppointmentDetailScreen> {
  late List<ChecklistItem> _checklist;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _checklist = List<ChecklistItem>.from(widget.appointment.checklist);
    _reasonController = TextEditingController(text: widget.appointment.reason ?? '');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alumno: ${widget.appointment.idAlumno}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Fecha: ${widget.appointment.fechaCita}'),
            const SizedBox(height: 16),
            if (widget.appointment.reason != null && widget.appointment.reason!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('Razón: ${widget.appointment.reason}', style: const TextStyle(color: Colors.red)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Checklist de tareas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addChecklistItem,
                  tooltip: 'Agregar tarea',
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
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
            // Aquí podrías agregar un botón para guardar cambios si lo deseas
          ],
        ),
      ),
    );
  }
} 