import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/appointments/models/appointment_model.dart';
import '../core/services/appointments/providers/appointment_providers.dart';
import '../core/services/tutors/models/tutor_model.dart';
import '../core/services/tutors/providers/tutor_providers.dart';

/// Ejemplo de cómo usar los servicios de citas y tutores
class AppointmentsAndTutorsExample extends ConsumerStatefulWidget {
  const AppointmentsAndTutorsExample({super.key});

  @override
  ConsumerState<AppointmentsAndTutorsExample> createState() => _AppointmentsAndTutorsExampleState();
}

class _AppointmentsAndTutorsExampleState extends ConsumerState<AppointmentsAndTutorsExample> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar
    Future.microtask(() {
      ref.read(tutorListProvider.notifier).loadTutors();
      ref.read(appointmentListProvider.notifier).loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas y Tutores'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Tutores
            _buildTutorsSection(),
            const SizedBox(height: 24),
            // Sección de Citas
            _buildAppointmentsSection(),
            const SizedBox(height: 24),
            // Acciones de ejemplo
            _buildExampleActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tutores',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(tutorListProvider.notifier).refreshTutors();
                  },
                  child: const Text('Refrescar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final tutorState = ref.watch(tutorListProvider);
                
                if (tutorState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (tutorState.error != null) {
                  return Column(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${tutorState.error!.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(tutorListProvider.notifier).loadTutors();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  );
                }
                
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Total: ${tutorState.tutors.length} tutores'),
                        const Spacer(),
                        if (tutorState.hasCache)
                          const Icon(Icons.cached, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...tutorState.tutors.take(3).map((tutor) => 
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(tutor.nombre[0]),
                        ),
                        title: Text(tutor.nombre),
                        subtitle: Text(tutor.correo),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    if (tutorState.tutors.length > 3)
                      Text('... y ${tutorState.tutors.length - 3} más'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Citas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(appointmentListProvider.notifier).refresh();
                  },
                  child: const Text('Refrescar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final appointmentState = ref.watch(appointmentListProvider);
                
                if (appointmentState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (appointmentState.error != null) {
                  return Column(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${appointmentState.error!.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(appointmentListProvider.notifier).loadAppointments();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  );
                }
                
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Total: ${appointmentState.appointments.length} citas'),
                        const Spacer(),
                        if (appointmentState.hasMore)
                          const Icon(Icons.more_horiz, color: Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...appointmentState.appointments.take(3).map((appointment) => 
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(appointment.estadoCita),
                          child: Icon(
                            _getStatusIcon(appointment.estadoCita),
                            color: Colors.white,
                          ),
                        ),
                        title: Text('Cita ${appointment.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estado: ${appointment.estadoCita.displayName}'),
                            Text('Fecha: ${appointment.fechaCita.day}/${appointment.fechaCita.month}/${appointment.fechaCita.year}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    if (appointmentState.appointments.length > 3)
                      Text('... y ${appointmentState.appointments.length - 3} más'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones de ejemplo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _showTutorSearch(),
                  child: const Text('Buscar Tutores'),
                ),
                ElevatedButton(
                  onPressed: () => _showCreateAppointment(),
                  child: const Text('Crear Cita'),
                ),
                ElevatedButton(
                  onPressed: () => _showTutorStats(),
                  child: const Text('Estadísticas'),
                ),
                ElevatedButton(
                  onPressed: () => _showHealthCheck(),
                  child: const Text('Health Check'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTutorSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar Tutores'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre del tutor',
                hintText: 'Ingresa el nombre...',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ref.read(tutorListProvider.notifier).searchTutors(value);
                }
              },
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final tutorState = ref.watch(tutorListProvider);
                return Text('Resultados: ${tutorState.tutors.length}');
              },
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

  void _showCreateAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Cita'),
        content: const Text(
          'Aquí puedes implementar un formulario para crear una nueva cita.\n\n'
          'Ejemplo de uso:\n'
          '1. Seleccionar tutor\n'
          '2. Seleccionar fecha y hora\n'
          '3. Agregar descripción\n'
          '4. Crear cita usando CreateAppointmentRequest',
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

  void _showTutorStats() async {
    final stats = await ref.read(tutorStatsProvider.future);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Estadísticas de Tutores'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total de tutores: ${stats['totalTutors']}'),
              Text('Tutores activos: ${stats['activeTutors']}'),
              Text('Cache válido: ${stats['cacheValid']}'),
              Text('Última actualización: ${stats['lastUpdated']}'),
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

  void _showHealthCheck() async {
    try {
      final isHealthy = await ref.read(appointmentServiceHealthProvider.future);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Estado del Servicio'),
            content: Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.error,
                  color: isHealthy ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(isHealthy ? 'Servicio funcionando correctamente' : 'Servicio con problemas'),
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al verificar el servicio: $e')),
        );
      }
    }
  }

  Color _getStatusColor(EstadoCita estado) {
    switch (estado) {
      case EstadoCita.pendiente:
        return Colors.orange;
      case EstadoCita.confirmada:
        return Colors.blue;
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
        return Icons.check;
      case EstadoCita.completada:
        return Icons.done_all;
      case EstadoCita.cancelada:
        return Icons.cancel;
      case EstadoCita.no_asistio:
        return Icons.person_off;
    }
  }
}

/// Ejemplo de cómo usar los servicios programáticamente
class AppointmentServiceUsageExample {
  /// Ejemplo de cómo crear una cita
  static Future<void> createAppointmentExample(WidgetRef ref) async {
    try {
      final request = CreateAppointmentRequest(
        idTutor: 'tutor001', // Ahora usando el ID del tutor
        idAlumno: 'alumno001', // Ahora usando el ID del alumno
        fechaCita: DateTime.now().add(const Duration(days: 1)),
        toDo: 'Revisar álgebra básica',
      );

      final appointment = await ref.read(createAppointmentProvider(request).future);
      print('Cita creada: ${appointment.id}');
    } catch (e) {
      print('Error al crear cita: $e');
    }
  }

  /// Ejemplo de cómo obtener tutores
  static Future<void> getTutorsExample(WidgetRef ref) async {
    try {
      final tutors = await ref.read(tutorsProvider.future);
      print('Tutores obtenidos: ${tutors.length}');
      
      for (final tutor in tutors) {
        print('- ${tutor.nombre} (${tutor.correo})');
      }
    } catch (e) {
      print('Error al obtener tutores: $e');
    }
  }

  /// Ejemplo de cómo buscar un tutor específico por ID
  static Future<void> findTutorByIdExample(WidgetRef ref, String id) async {
    try {
      final tutor = await ref.read(tutorByIdProvider(id).future);
      
      if (tutor != null) {
        print('Tutor encontrado: ${tutor.nombre} (${tutor.id})');
      } else {
        print('Tutor no encontrado');
      }
    } catch (e) {
      print('Error al buscar tutor: $e');
    }
  }

  /// Ejemplo de cómo buscar un tutor específico por email
  static Future<void> findTutorByEmailExample(WidgetRef ref, String email) async {
    try {
      final tutor = await ref.read(tutorByEmailProvider(email).future);
      
      if (tutor != null) {
        print('Tutor encontrado: ${tutor.nombre} (${tutor.id})');
      } else {
        print('Tutor no encontrado');
      }
    } catch (e) {
      print('Error al buscar tutor: $e');
    }
  }

  /// Ejemplo de cómo filtrar citas
  static Future<void> filterAppointmentsExample(WidgetRef ref) async {
    try {
      // Cargar citas del tutor actual
      await ref.read(appointmentListProvider.notifier).loadAppointments(
        estadoCita: EstadoCita.confirmada,
        fechaDesde: DateTime.now(),
        fechaHasta: DateTime.now().add(const Duration(days: 30)),
      );
      
      final state = ref.read(appointmentListProvider);
      print('Citas confirmadas próximas: ${state.appointments.length}');
    } catch (e) {
      print('Error al filtrar citas: $e');
    }
  }
} 