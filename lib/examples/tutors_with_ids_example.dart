import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/appointments/models/appointment_model.dart';
import '../core/services/appointments/providers/appointment_providers.dart';
import '../core/services/tutors/models/tutor_model.dart';
import '../core/services/tutors/providers/tutor_providers.dart';

/// Ejemplo de cómo usar tutores con IDs únicos
class TutorsWithIdsExample extends ConsumerStatefulWidget {
  const TutorsWithIdsExample({super.key});

  @override
  ConsumerState<TutorsWithIdsExample> createState() => _TutorsWithIdsExampleState();
}

class _TutorsWithIdsExampleState extends ConsumerState<TutorsWithIdsExample> {
  String? selectedTutorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutores con IDs - Ejemplo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de tutores con IDs
            _buildTutorsList(),
            const SizedBox(height: 24),
            
            // Buscar tutor por ID
            _buildSearchTutorById(),
            const SizedBox(height: 24),
            
            // Crear cita con ID de tutor
            _buildCreateAppointmentWithId(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Tutores con IDs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final tutorsAsync = ref.watch(tutorsProvider);
                
                return tutorsAsync.when(
                  data: (tutors) => Column(
                    children: tutors.map((tutor) => _buildTutorCard(tutor)).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorCard(TutorModel tutor) {
    final isSelected = selectedTutorId == tutor.id;
    
    return Card(
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            tutor.nombre[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(tutor.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${tutor.id}'),
            Text('Email: ${tutor.correo}'),
          ],
        ),
        trailing: isSelected 
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
        onTap: () {
          setState(() {
            selectedTutorId = isSelected ? null : tutor.id;
          });
        },
      ),
    );
  }

  Widget _buildSearchTutorById() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buscar Tutor por ID',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (selectedTutorId != null) ...[
              Text('ID seleccionado: $selectedTutorId'),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final tutorAsync = ref.watch(tutorByIdProvider(selectedTutorId!));
                  
                  return tutorAsync.when(
                    data: (tutor) => tutor != null
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✓ Tutor encontrado',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Nombre: ${tutor.nombre}'),
                              Text('Email: ${tutor.correo}'),
                              Text('ID: ${tutor.id}'),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            '✗ Tutor no encontrado',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        'Error: $error',
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              const Text('Selecciona un tutor de la lista para ver su información'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAppointmentWithId() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crear Cita con ID de Tutor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (selectedTutorId != null) ...[
              Text('Tutor seleccionado: $selectedTutorId'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _createExampleAppointment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Crear Cita de Ejemplo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ] else ...[
              const Text('Selecciona un tutor para crear una cita de ejemplo'),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _createExampleAppointment() async {
    if (selectedTutorId == null) return;

    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final request = CreateAppointmentRequest(
        idTutor: selectedTutorId!, // Usando el ID del tutor seleccionado
        idAlumno: 'alumno001', // ID de ejemplo del alumno
        fechaCita: DateTime.now().add(const Duration(days: 1)),
        toDo: 'Cita de ejemplo creada desde la demo de IDs',
      );

      final appointment = await ref.read(createAppointmentProvider(request).future);

      Navigator.pop(context); // Cerrar loading

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Cita Creada!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID de la cita: ${appointment.id}'),
                Text('ID del tutor: ${appointment.idTutor}'),
                Text('ID del alumno: ${appointment.idAlumno}'),
                Text('Estado: ${appointment.estadoCita.displayName}'),
                Text('Fecha: ${appointment.fechaCita.day}/${appointment.fechaCita.month}/${appointment.fechaCita.year}'),
                if (appointment.toDo != null)
                  Text('Tareas: ${appointment.toDo}'),
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
      Navigator.pop(context); // Cerrar loading

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Clase de utilidad para trabajar con IDs de tutores
class TutorIdUtils {
  /// Buscar tutor por ID usando el provider
  static Future<TutorModel?> findTutorById(WidgetRef ref, String id) async {
    try {
      return await ref.read(tutorByIdProvider(id).future);
    } catch (e) {
      print('Error al buscar tutor por ID $id: $e');
      return null;
    }
  }

  /// Buscar tutor por email usando el provider
  static Future<TutorModel?> findTutorByEmail(WidgetRef ref, String email) async {
    try {
      return await ref.read(tutorByEmailProvider(email).future);
    } catch (e) {
      print('Error al buscar tutor por email $email: $e');
      return null;
    }
  }

  /// Crear cita usando ID de tutor
  static Future<AppointmentModel?> createAppointmentWithTutorId(
    WidgetRef ref, {
    required String tutorId,
    required String alumnoId,
    required DateTime fechaCita,
    String? toDo,
  }) async {
    try {
      final request = CreateAppointmentRequest(
        idTutor: tutorId,
        idAlumno: alumnoId,
        fechaCita: fechaCita,
        toDo: toDo,
      );

      return await ref.read(createAppointmentProvider(request).future);
    } catch (e) {
      print('Error al crear cita: $e');
      return null;
    }
  }

  /// Validar si un ID de tutor existe
  static Future<bool> validateTutorId(WidgetRef ref, String id) async {
    try {
      final tutor = await findTutorById(ref, id);
      return tutor != null;
    } catch (e) {
      return false;
    }
  }

  /// Obtener información resumida de un tutor
  static Future<String> getTutorSummary(WidgetRef ref, String id) async {
    try {
      final tutor = await findTutorById(ref, id);
      if (tutor != null) {
        return '${tutor.nombre} (${tutor.correo})';
      } else {
        return 'Tutor no encontrado';
      }
    } catch (e) {
      return 'Error al obtener información del tutor';
    }
  }
} 