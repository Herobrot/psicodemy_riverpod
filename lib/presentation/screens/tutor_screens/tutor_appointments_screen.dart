import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';

class TutorAppointmentsScreen extends ConsumerStatefulWidget {
  const TutorAppointmentsScreen({super.key});

  @override
  ConsumerState<TutorAppointmentsScreen> createState() => _TutorAppointmentsScreenState();
}

class _TutorAppointmentsScreenState extends ConsumerState<TutorAppointmentsScreen> {
  String? _selectedAlumnoId;
  AppointmentModel? _selectedAppointment;
  bool _showHistorial = false;

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(myAppointmentsAsTutorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas como Tutor'),
        actions: [
          IconButton(
            icon: Icon(_showHistorial ? Icons.list : Icons.history),
            tooltip: _showHistorial ? 'Ver todas' : 'Ver historial por alumno',
            onPressed: () {
              setState(() {
                _showHistorial = !_showHistorial;
                _selectedAlumnoId = null;
              });
            },
          ),
        ],
      ),
      body: appointmentsAsync.when(
        data: (appointments) {
          final alumnos = {
            for (var a in appointments) a.idAlumno: a
          };
          List<AppointmentModel> filtered = appointments;
          if (_showHistorial && _selectedAlumnoId != null) {
            filtered = appointments.where((a) => a.idAlumno == _selectedAlumnoId).toList();
          }
          filtered.sort((a, b) => b.fechaCita.compareTo(a.fechaCita));

          return Column(
            children: [
              if (_showHistorial)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedAlumnoId,
                    hint: const Text('Selecciona un alumno'),
                    items: alumnos.entries.map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text('Alumno: ${entry.key}'),
                    )).toList(),
                    onChanged: (value) {
                      setState(() => _selectedAlumnoId = value);
                    },
                  ),
                ),
              Expanded(
                child: filtered.isEmpty
                  ? const Center(child: Text('No hay citas para mostrar'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => _buildAppointmentCard(filtered[i]),
                    ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar citas: $e')),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text('Alumno: ${appointment.idAlumno}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${_formatDate(appointment.fechaCita)}'),
            Text('Estado: ${appointment.estadoCita.displayName}'),
            if (appointment.toDo != null && appointment.toDo!.isNotEmpty)
              Text('Por hacer: ${appointment.toDo!}', style: const TextStyle(fontSize: 12)),
            if (appointment.finishToDo != null && appointment.finishToDo!.isNotEmpty)
              Text('Hecho: ${appointment.finishToDo!}', style: const TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _showAppointmentDetail(appointment),
        ),
      ),
    );
  }

  void _showAppointmentDetail(AppointmentModel appointment) {
    setState(() => _selectedAppointment = appointment);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AppointmentDetailSheet(
        appointment: appointment,
        onStatusChanged: (newStatus) async {
          await ref.read(updateAppointmentStatusProvider({
            'id': appointment.id,
            'estado': newStatus,
          }).future);
          ref.refresh(myAppointmentsAsTutorProvider);
          Navigator.pop(context);
        },
        onEditTodo: (toDo, finishToDo) async {
          await ref.read(updateAppointmentProvider({
            'id': appointment.id,
            'request': UpdateAppointmentRequest(
              toDo: toDo,
              finishToDo: finishToDo,
            ),
          }).future);
          ref.refresh(myAppointmentsAsTutorProvider);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _AppointmentDetailSheet extends StatefulWidget {
  final AppointmentModel appointment;
  final Future<void> Function(EstadoCita) onStatusChanged;
  final Future<void> Function(String?, String?) onEditTodo;

  const _AppointmentDetailSheet({
    required this.appointment,
    required this.onStatusChanged,
    required this.onEditTodo,
  });

  @override
  State<_AppointmentDetailSheet> createState() => _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState extends State<_AppointmentDetailSheet> {
  late TextEditingController _todoController;
  late TextEditingController _finishTodoController;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController(text: widget.appointment.toDo);
    _finishTodoController = TextEditingController(text: widget.appointment.finishToDo);
  }

  @override
  void dispose() {
    _todoController.dispose();
    _finishTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = widget.appointment.estadoCita;
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalle de la cita', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Alumno: ${widget.appointment.idAlumno}'),
            Text('Fecha: ${widget.appointment.fechaCita}'),
            Text('Estado: ${estado.displayName}'),
            const Divider(),
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(labelText: 'Por hacer (to-do)'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _finishTodoController,
              decoration: const InputDecoration(labelText: 'Hecho (finish to-do)'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (estado == EstadoCita.pendiente) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.onStatusChanged(EstadoCita.confirmada),
                      child: const Text('Confirmar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.onStatusChanged(EstadoCita.cancelada),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => widget.onEditTodo(
                _todoController.text,
                _finishTodoController.text,
              ),
              child: const Text('Guardar tareas'),
            ),
          ],
        ),
      ),
    );
  }
} 