import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../forum_screens/forum_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../home_screens/home_screen.dart';
import 'detail_quotes_screen.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isScheduling = true;

  final List<String> _tutores = ['Alonso', 'Diana', 'Horacio'];
  String? _selectedTutor;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScheduling = false;
      });
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
          ? const Center(child: CircularProgressIndicator())
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
                  TableCalendar(
                    firstDay: DateTime.utc(2022, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _selectedTutor = null;
                      _selectedTime = null;
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAppointmentCard('Tutoria con Ali', '24/10/26'),
                  _buildAppointmentCard('Tutoria con Ali', '20/10/26'),
                  _buildAppointmentCard('Tutoria con Ali', '19/10/26'),
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
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Selecciona al tutor deseado'),
                  value: _selectedTutor,
                  items: _tutores.map((tutor) {
                    return DropdownMenuItem<String>(
                      value: tutor,
                      child: Text(tutor),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedTutor = value),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showTimeDialog();
                    },
                    child: const Text('Next'),
                  ),
                )
              ],
            ),
          ),
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
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _agendarCita() {
    Navigator.pop(context);
    setState(() => _isScheduling = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isScheduling = false);
      final success = _selectedTutor != null && _selectedTime != null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Cita generada con éxito'
              : 'No se agendó la cita, intente de nuevo'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    });
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DetalleCitaScreen()),
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu cita con el Mtro Ali',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Faltan 25 Horas para tu cita.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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
  }

  Widget _buildAppointmentCard(String title, String date) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DetalleCitaScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF5CC9C0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
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
                'VER →',
                style: TextStyle(
                  color: Color(0xFF5CC9C0),
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
}
