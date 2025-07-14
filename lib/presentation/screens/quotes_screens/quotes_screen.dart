import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';
import '../../../core/services/tutors/models/tutor_model.dart';
import '../../../core/services/tutors/providers/tutor_providers.dart';
import 'detail_quotes_screen.dart';

class CitasScreen extends ConsumerStatefulWidget {
  const CitasScreen({super.key});

  @override
  ConsumerState<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends ConsumerState<CitasScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isScheduling = false;

  TutorModel? _selectedTutor;
  TimeOfDay? _selectedTime;
  String _todoText = '';

  @override
  void initState() {
    super.initState();
    // Cargar tutores y citas del alumno al inicializar
    Future.microtask(() {
      ref.read(tutorListProvider.notifier).loadTutors();
      ref.read(appointmentListProvider.notifier).loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            // TODO: Implementar menú lateral
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/src/shared_imgs/chat.png',
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.psychology, size: 28, color: Color(0xFF4CAF50));
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Psicodemy',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
      body: _isScheduling
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creando cita...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  _buildMainAppointmentCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'CALENDARIO DE CITAS',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      final appointmentState = ref.watch(appointmentListProvider);
                      
                      return TableCalendar(
                        firstDay: DateTime.utc(2022, 1, 1),
                        lastDay: DateTime.utc(2026, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        eventLoader: (day) {
                          // Mostrar citas del día
                          return appointmentState.appointments
                              .where((appointment) => isSameDay(appointment.fechaCita, day))
                              .toList();
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          _selectedTutor = null;
                          _selectedTime = null;
                          _todoText = '';
                          _showTutorDialog();
                        },
                        calendarFormat: CalendarFormat.month,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Color(0xFF5CC9C0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAppointmentsList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  void _showTutorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Text(
                          '¿Quieres agendar una cita el ${_selectedDay!.day} de ${_getMonthName(_selectedDay!.month)} del ${_selectedDay!.year}?',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            final tutorState = ref.watch(tutorListProvider);
                            
                            if (tutorState.isLoading) {
                              return const CircularProgressIndicator();
                            }
                            
                            if (tutorState.error != null) {
                              return Column(
                                children: [
                                  Text(
                                    'Error al cargar tutores: ${tutorState.error!.message}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(tutorListProvider.notifier).loadTutors();
                                    },
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              );
                            }
                            
                            if (tutorState.tutors.isEmpty) {
                              return const Text('No hay tutores disponibles');
                            }
                            
                            return DropdownButtonFormField<TutorModel>(
                              decoration: const InputDecoration(
                                labelText: 'Selecciona al tutor deseado',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedTutor,
                              isExpanded: true,
                              menuMaxHeight: 200,
                              items: tutorState.tutors.map((tutor) {
                                return DropdownMenuItem<TutorModel>(
                                  value: tutor,
                                  child: Container(
                                    constraints: const BoxConstraints(maxHeight: 60),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          tutor.nombre,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedTutor = value);
                                setStateDialog(() {});
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Describe qué quieres trabajar (opcional)',
                            border: OutlineInputBorder(),
                            hintText: 'Ej: Revisar álgebra básica',
                          ),
                          maxLines: 2,
                          onChanged: (value) => _todoText = value,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: _selectedTutor != null ? () {
                                Navigator.pop(context);
                                _showTimeDialog();
                              } : null,
                              child: const Text('Siguiente'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTimeDialog() {
    _selectedTime = null;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Text(
                          '¿Quieres agendar una cita el ${_selectedDay!.day} de ${_getMonthName(_selectedDay!.month)} del ${_selectedDay!.year}?',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedTime = picked;
                              });
                              setStateDialog(() {});
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Selecciona un horario disponible'),
                            child: Text(_selectedTime?.format(context) ?? 'hh:mm aa'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _selectedTime != null ? _agendarCita : null,
                          child: const Text('Agendar Cita'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _agendarCita() async {
    Navigator.pop(context);
    
    if (_selectedTutor == null || _selectedTime == null || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isScheduling = true);

    try {
      // Crear la fecha y hora de la cita
      final fechaCita = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Verificar conflictos de horario
      final hasConflict = await ref.read(
        scheduleConflictProvider({
          'tutorId': _selectedTutor!.id, // Usando el ID del tutor
          'fechaCita': fechaCita,
        }).future,
      );

      if (hasConflict) {
        setState(() => _isScheduling = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El tutor no está disponible en ese horario'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Crear la cita
      final request = CreateAppointmentRequest(
        idTutor: _selectedTutor!.id, // Usando el ID del tutor
        idAlumno: FirebaseAuth.instance.currentUser?.uid ?? '',
        fechaCita: fechaCita,
        toDo: _todoText.isNotEmpty ? _todoText : null,
      );

      final appointment = await ref.read(createAppointmentProvider(request).future);

      // Actualizar la lista de citas
      ref.read(appointmentListProvider.notifier).addAppointmentToList(appointment);

      setState(() => _isScheduling = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cita creada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Limpiar selecciones
      _selectedTutor = null;
      _selectedTime = null;
      _selectedDay = null;
      _todoText = '';

    } catch (e) {
      setState(() => _isScheduling = false);
      
      String errorMessage = 'Error al crear la cita';
      if (e.toString().contains('unauthorized')) {
        errorMessage = 'No tienes permisos para crear citas';
      } else if (e.toString().contains('validation')) {
        errorMessage = 'Datos inválidos. Verifica la información';
      } else if (e.toString().contains('conflict')) {
        errorMessage = 'Conflicto de horario';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  Widget _buildMainAppointmentCard() {
    return Consumer(
      builder: (context, ref, child) {
        final appointmentState = ref.watch(appointmentListProvider);
        
        // Buscar la próxima cita confirmada
        final now = DateTime.now();
        final upcomingAppointments = appointmentState.appointments
            .where((appointment) => 
                appointment.fechaCita.isAfter(now) && 
                appointment.estadoCita == EstadoCita.confirmada)
            .toList();
        
        upcomingAppointments.sort((a, b) => a.fechaCita.compareTo(b.fechaCita));
        
        if (upcomingAppointments.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No tienes citas próximas',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Agenda una nueva cita seleccionando una fecha',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.add, color: Colors.white),
              ],
            ),
          );
        }
        
        final nextAppointment = upcomingAppointments.first;
        final hoursUntil = nextAppointment.fechaCita.difference(now).inHours;
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetalleCitaScreen(appointment: nextAppointment),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próxima cita - ${nextAppointment.estadoCita.displayName}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        hoursUntil > 0 
                          ? 'Faltan $hoursUntil horas para tu cita'
                          : 'Tu cita es hoy',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'VER CITA →',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsList() {
    return Consumer(
      builder: (context, ref, child) {
        final appointmentState = ref.watch(appointmentListProvider);
        
        if (appointmentState.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (appointmentState.error != null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.error, color: Colors.red.shade600, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Error al cargar citas',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointmentState.error!.message,
                  style: TextStyle(color: Colors.red.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(appointmentListProvider.notifier).refresh();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        
        if (appointmentState.appointments.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No tienes citas programadas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Selecciona una fecha en el calendario para crear tu primera cita',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: appointmentState.appointments
              .take(5) // Mostrar solo las últimas 5 citas
              .map((appointment) => _buildAppointmentCard(appointment))
              .toList(),
        );
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleCitaScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getStatusColor(appointment.estadoCita),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(appointment.estadoCita),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cita - ${appointment.estadoCita.displayName}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${appointment.fechaCita.day}/${appointment.fechaCita.month}/${appointment.fechaCita.year} - ${appointment.fechaCita.hour.toString().padLeft(2, '0')}:${appointment.fechaCita.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (appointment.toDo != null && appointment.toDo!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        appointment.toDo!,
                        style: const TextStyle(color: Colors.white60, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'VER →',
                style: TextStyle(
                  color: _getStatusColor(appointment.estadoCita),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}