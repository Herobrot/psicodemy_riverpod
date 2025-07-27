import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';
import '../../../core/services/tutors/models/tutor_model.dart';
import '../../../core/services/tutors/providers/tutor_providers.dart';
import 'detail_quotes_screen.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../presentation/providers/appointment_providers.dart';
import '../../../presentation/providers/simple_auth_providers.dart';

// Nuevo provider para obtener todas las citas del alumno actual
final allStudentAppointmentsProvider = FutureProvider.family<List<AppointmentEntity>, String>((ref, userId) async {
  if (userId.isEmpty) return <AppointmentEntity>[];
  final useCases = ref.watch(appointmentUseCasesProvider);
  final pendientes = await useCases.getStudentAppointmentsFiltered(
    studentId: userId,
    estadoCita: AppointmentStatus.pending,
    fechaDesde: DateTime.now(),
    limit: 50,
  );
  final confirmadas = await useCases.getStudentAppointmentsFiltered(
    studentId: userId,
    estadoCita: AppointmentStatus.confirmed,
    fechaDesde: DateTime.now(),
    limit: 50,
  );
  final completadas = await useCases.getStudentAppointmentsFiltered(
    studentId: userId,
    estadoCita: AppointmentStatus.completed,
    fechaDesde: DateTime.now(),
    limit: 50,
  );
  final canceladas = await useCases.getStudentAppointmentsFiltered(
    studentId: userId,
    estadoCita: AppointmentStatus.cancelled,
    fechaDesde: DateTime.now(),
    limit: 50,
  );
  final todas = <AppointmentEntity>[...pendientes, ...confirmadas, ...completadas, ...canceladas];
  todas.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  return todas;
});

// Provider para obtener el userId de la API del usuario actual
final currentUserIdProvider = Provider<String>((ref) {
  final completeUserAsync = ref.watch(currentCompleteUserProvider);
  return completeUserAsync.when(
    data: (completeUser) {
      // Usar userId de la API si está disponible, sino usar uid de Firebase como fallback
      return completeUser?.userId ?? completeUser?.uid ?? '';
    },
    loading: () => '',
    error: (_, __) => '',
  );
});

class CitasScreen extends ConsumerStatefulWidget {
  const CitasScreen({super.key});

  @override
  ConsumerState<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends ConsumerState<CitasScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isScheduling = false;

  TutorModel? _selectedTutor;
  TimeOfDay? _selectedTime;
  String _razonCita = '';
  List<ChecklistItem> _checklistCita = [];

  // 1. Agregar variables de estado para el desplegable, búsqueda y paginación
  bool _showCalendar = false;
  String _searchTutor = '';
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // Cargar tutores y citas del alumno al inicializar
    Future.microtask(() {
      ref.read(tutorListProvider.notifier).loadTutors();
      // Usar el userId de la API en lugar del uid de Firebase
      final userId = ref.read(currentUserIdProvider);
      ref.refresh(allStudentAppointmentsProvider(userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = ref.watch(currentUserIdProvider);
    final appointmentsAsync = ref.watch(allStudentAppointmentsProvider(userId));
    final theme = Theme.of(context);
    
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
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
                    const SizedBox(height: 16),
                    // Botón destacado para agendar cita
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(_showCalendar ? Icons.close : Icons.add, size: 28),
                        label: Text(
                          _showCalendar ? 'Cerrar agendado' : 'Agendar nueva cita',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            _showCalendar = !_showCalendar;
                          });
                        },
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: _showCalendar
                          ? Container(
                              key: const ValueKey('calendar_area'),
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F0FF),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.12),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Agendar cita',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red, size: 28),
                                        tooltip: 'Cerrar',
                                        onPressed: () {
                                          setState(() {
                                            _showCalendar = false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final calendarUserId = ref.watch(currentUserIdProvider);
                                      final appointmentsAsync = ref.watch(allStudentAppointmentsProvider(calendarUserId));
                                      return appointmentsAsync.when(
                                        data: (appointments) => TableCalendar(
                                          firstDay: DateTime.now(),
                                          lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
                                          focusedDay: _focusedDay,
                                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                          eventLoader: (day) {
                                            return appointments.where((appointment) => isSameDay(appointment.scheduledDate, day)).toList();
                                          },
                                          onDaySelected: (selectedDay, focusedDay) {
                                            setState(() {
                                              _selectedDay = selectedDay;
                                              _focusedDay = focusedDay;
                                            });
                                            _selectedTutor = null;
                                            _selectedTime = null;
                                            _razonCita = '';
                                            _checklistCita = [];
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
                                        ),
                                        loading: () => const Center(child: CircularProgressIndicator()),
                                        error: (e, _) => Center(child: Text('Error:  [${e.toString()}')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    // Filtros y búsqueda
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Buscar por nombre de tutor',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchTutor = value;
                                _currentPage = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAppointmentsList(),
                    const SizedBox(height: 20),
                  ],
                ),
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
                        AppointmentChecklistForm(
                          onChanged: (reason, checklist) {
                            _razonCita = reason;
                            _checklistCita = checklist;
                          },
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
      builder: (dialogContext) {
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
                            onPressed: () => Navigator.pop(dialogContext),
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
                          onPressed: _selectedTime != null
                              ? () {
                                  Navigator.pop(dialogContext);
                                  _agendarCita();
                                }
                              : null,
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
    
    if (_selectedTutor == null || _selectedTime == null || _selectedDay == null) {
      Future.delayed(Duration.zero, () {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Por favor completa todos los campos'),
            backgroundColor: Colors.red,
          ),
        );
      });
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

      // Crear la cita
      final request = CreateAppointmentRequest(
        idTutor: _selectedTutor!.id,
        idAlumno: ref.read(currentUserIdProvider),
        fechaCita: fechaCita,
        checklist: _checklistCita,
        reason: _razonCita.isNotEmpty ? _razonCita : null,
      );

      await ref.read(createAppointmentProvider(request).future);

      // Actualizar la lista de citas del alumno
      ref.refresh(allStudentAppointmentsProvider(ref.read(currentUserIdProvider)));

      setState(() => _isScheduling = false);

      Future.delayed(Duration.zero, () {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('¡Cita creada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
      });

      // Limpiar selecciones
      _selectedTutor = null;
      _selectedTime = null;
      _selectedDay = null;
      _razonCita = '';
      _checklistCita = [];

    } catch (e, stack) {
      setState(() => _isScheduling = false);
      
      String errorMessage = 'Error al crear la cita';
      if (e.toString().contains('unauthorized')) {
        errorMessage = 'No tienes permisos para crear citas';
      } else if (e.toString().contains('validation')) {
        errorMessage = 'Datos inválidos. Verifica la información';
      } else if (e.toString().contains('conflict')) {
        errorMessage = 'Conflicto de horario';
      }

      // Imprimir el error y el stacktrace para depuración
      print('🚨 Error en _agendarCita: $e');
      print('🚨 Stacktrace: $stack');

      Future.delayed(Duration.zero, () {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      });
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
        final userId = ref.watch(currentUserIdProvider);
        final appointmentsAsync = ref.watch(allStudentAppointmentsProvider(userId));
        
        // Buscar la próxima cita confirmada del alumno actual
        final now = DateTime.now();
        final upcomingAppointments = appointmentsAsync.when(
          data: (appointments) => appointments
              .where((appointment) => 
                  appointment.scheduledDate.isAfter(now) && 
                  appointment.status == AppointmentStatus.confirmed)
              .toList(),
          loading: () => [],
          error: (e, _) => [],
        );
        
        upcomingAppointments.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
        
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
        final hoursUntil = nextAppointment.scheduledDate.difference(now).inHours;
        
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
                        'Próxima cita',
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

  // Modificar _buildAppointmentsList para usar el nuevo provider y AppointmentEntity
  Widget _buildAppointmentsList() {
    return Consumer(
      builder: (context, ref, child) {
        final userId = ref.watch(currentUserIdProvider);
        final appointmentsAsync = ref.watch(allStudentAppointmentsProvider(userId));
        final tutorState = ref.watch(tutorListProvider);
        return appointmentsAsync.when(
          data: (appointments) {
            // Crear un mapa de idTutor a nombre
            final Map<String, String> tutorNames = {
              for (var t in tutorState.tutors) t.id: t.nombre
            };
            // Filtro por nombre de tutor
            final filtered = appointments.where((a) =>
              (tutorNames[a.tutorId]?.toLowerCase() ?? '').contains(_searchTutor.toLowerCase())
            ).toList();
            // Ordenar por fecha descendente
            filtered.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
            // Paginación
            final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
            final start = (_currentPage - 1) * _pageSize;
            final end = (_currentPage * _pageSize).clamp(0, filtered.length);
            final pageItems = filtered.sublist(start, end);
            if (appointments.isEmpty) {
              // No hay citas en absoluto
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
            if (filtered.isEmpty) {
              // Hay citas, pero el filtro no encontró coincidencias
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No hay coincidencias para tu búsqueda',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                ...pageItems.map((appointment) => _buildAppointmentCardEntity(appointment)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                      color: _currentPage > 1 ? Colors.blue : Colors.grey,
                    ),
                    Text('Página $_currentPage de $totalPages'),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                      color: _currentPage < totalPages ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Container(
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
                  e.toString(),
                  style: TextStyle(color: Colors.red.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(allStudentAppointmentsProvider(ref.read(currentUserIdProvider)));
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Nuevo método para mostrar AppointmentEntity
  Widget _buildAppointmentCardEntity(AppointmentEntity appointment) {
    return GestureDetector(
      onTap: () {
        // TODO: Navegar a detalle de cita si es necesario
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getStatusColorEntity(appointment.status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIconEntity(appointment.status),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cita',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${appointment.scheduledDate.day}/${appointment.scheduledDate.month}/${appointment.scheduledDate.year} - ${appointment.scheduledDate.hour.toString().padLeft(2, '0')}:${appointment.scheduledDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (appointment.notes != null && appointment.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        appointment.notes!,
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
                  color: _getStatusColorEntity(appointment.status),
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

  Color _getStatusColorEntity(AppointmentStatus status) {
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

  IconData _getStatusIconEntity(AppointmentStatus status) {
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
}

class AppointmentChecklistForm extends StatefulWidget {
  final void Function(String reason, List<ChecklistItem> checklist) onChanged;
  const AppointmentChecklistForm({super.key, required this.onChanged});

  @override
  State<AppointmentChecklistForm> createState() => _AppointmentChecklistFormState();
}

class _AppointmentChecklistFormState extends State<AppointmentChecklistForm> {
  final TextEditingController _reasonController = TextEditingController();
  final List<ChecklistItem> _checklist = [];

  void _addTask() {
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
                  widget.onChanged(_reasonController.text, _checklist);
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

  void _editTask(int index) {
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
                  widget.onChanged(_reasonController.text, _checklist);
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

  void _removeTask(int index) {
    setState(() {
      _checklist.removeAt(index);
    });
    widget.onChanged(_reasonController.text, _checklist);
  }

  void _toggleCompleted(int index) {
    setState(() {
      _checklist[index] = ChecklistItem(
        description: _checklist[index].description,
        completed: !_checklist[index].completed,
      );
    });
    widget.onChanged(_reasonController.text, _checklist);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            labelText: 'Razón de la cita (opcional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          onChanged: (_) => widget.onChanged(_reasonController.text, _checklist),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tareas a realizar', style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTask,
              tooltip: 'Agregar tarea',
            ),
          ],
        ),
        if (_checklist.isEmpty)
          const Text('No hay tareas agregadas.'),
        ..._checklist.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return ListTile(
            leading: Checkbox(
              value: item.completed,
              onChanged: (_) => _toggleCompleted(i),
            ),
            title: Text(item.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTask(i),
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeTask(i),
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}