import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/appointment_providers.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import 'tutor_appointment_detail_screen.dart';
import '../../widgets/user_name_display.dart';

class TutorHomeScreen extends ConsumerStatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  ConsumerState<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends ConsumerState<TutorHomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final tutorId = user?.uid ?? 'tutor1';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/src/shared_imgs/chat.png',
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.psychology,
                  size: 28,
                  color: Color(0xFF4CAF50),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Psicodemy - Tutor',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTutorContent(tutorId),
    );
  }

  Widget _buildTutorContent(String tutorId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 16),
          _buildStatsCards(tutorId),
          const SizedBox(height: 16),
          _buildPendingAppointmentsSection(tutorId),
          const SizedBox(height: 16),
          _buildTodayAppointmentsSection(tutorId),
          const SizedBox(height: 16),
          _buildAllAppointmentsSection(tutorId), // <-- Nueva sección
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Tutor';
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    final allAppointmentsAsync = ref.watch(tutorAppointmentsProvider(''));

    return allAppointmentsAsync.when(
      data: (appointments) {
        final now = DateTime.now();
        final total = appointments.length;
        final hoy = appointments
            .where(
              (a) =>
                  a.scheduledDate.year == now.year &&
                  a.scheduledDate.month == now.month &&
                  a.scheduledDate.day == now.day,
            )
            .length;
        final pendientes = appointments
            .where((a) => a.status == AppointmentStatus.pending)
            .length;
        final completadas = appointments
            .where((a) => a.status == AppointmentStatus.completed)
            .length;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5CC9C0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Se eliminaron las estadísticas de citas aquí
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF5CC9C0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Error al cargar citas: $e',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatsCards(String tutorId) {
    print('stats cards tutorId: $tutorId');
    final statsAsync = ref.watch(appointmentStatsProvider(tutorId));

    return statsAsync.when(
      data: (stats) => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Citas Hoy',
              '${stats['Hoy'] ?? 0}',
              Icons.calendar_today,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pendientes',
              '${stats['Pendiente'] ?? 0}',
              Icons.pending,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completadas',
              '${stats['Completada'] ?? 0}',
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
      loading: () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Citas Hoy',
              '...',
              Icons.calendar_today,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pendientes',
              '...',
              Icons.pending,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completadas',
              '...',
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
      error: (error, stack) => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Citas Hoy',
              '0',
              Icons.calendar_today,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pendientes',
              '0',
              Icons.pending,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completadas',
              '0',
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingAppointmentsSection(String tutorId) {
    final pendingAppointmentsAsync = ref.watch(
      pendingAppointmentsProvider(tutorId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Citas Pendientes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        pendingAppointmentsAsync.when(
          data: (appointments) => appointments.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No hay citas pendientes',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              : Column(
                  children: appointments
                      .map((appointment) => _buildAppointmentCard(appointment))
                      .toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildTodayAppointmentsSection(String tutorId) {
    final todayAppointmentsAsync = ref.watch(
      todayAppointmentsProvider(tutorId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Citas de Hoy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        todayAppointmentsAsync.when(
          data: (appointments) => appointments.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No hay citas programadas para hoy',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              : Column(
                  children: appointments
                      .map(
                        (appointment) =>
                            _buildTodayAppointmentCard(appointment),
                      )
                      .toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildAllAppointmentsSection(String tutorId) {
    final allAppointmentsAsync = ref.watch(tutorAppointmentsProvider(tutorId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Todas las citas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        allAppointmentsAsync.when(
          data: (appointments) {
            print('TOTAL CITAS DEL TUTOR: ${appointments.length}');
            for (final cita in appointments) {
              print('CITA: ' + cita.toString());
            }
            return appointments.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No hay citas registradas',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  )
                : Column(
                    children: appointments
                        .map(
                          (appointment) => _buildAppointmentCard(appointment),
                        )
                        .toList(),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(AppointmentEntity appointment) {
    final color = Color(appointment.statusColor);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TutorAppointmentDetailScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(appointment.status),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserNameDisplay(
                    userId: appointment.studentId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    appointment.topic,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${appointment.scheduledDate.day}/${appointment.scheduledDate.month}/${appointment.scheduledDate.year} - '
                    '${appointment.scheduledDate.hour.toString().padLeft(2, '0')}:${appointment.scheduledDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (appointment.notes != null &&
                      appointment.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        appointment.notes!,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
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
                  color: color,
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

  IconData _getStatusIcon(AppointmentStatus status) {
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

  Widget _buildTodayAppointmentCard(AppointmentEntity appointment) {
    final color = Color(appointment.statusColor);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TutorAppointmentDetailScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.person, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.timeSlot,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  UserNameDisplay(
                    userId: appointment.studentId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    appointment.topic,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appointment.statusText,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hoy';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1) {
      return 'Mañana';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Conversión de AppointmentEntity a AppointmentModel para DetalleCitaScreen
  AppointmentModel _entityToModel(AppointmentEntity entity) {
    // Mapear el estado
    EstadoCita estado;
    switch (entity.status) {
      case AppointmentStatus.pending:
        estado = EstadoCita.pendiente;
        break;
      case AppointmentStatus.confirmed:
        estado = EstadoCita.confirmada;
        break;
      case AppointmentStatus.completed:
        estado = EstadoCita.completada;
        break;
      case AppointmentStatus.cancelled:
        estado = EstadoCita.cancelada;
        break;
      case AppointmentStatus.inProgress:
        estado = EstadoCita.pendiente;
        break;
      case AppointmentStatus.rescheduled:
        estado = EstadoCita.pendiente;
        break;
    }
    return AppointmentModel(
      id: entity.id,
      idTutor: entity.tutorId,
      idAlumno: entity.studentId,
      estadoCita: estado,
      fechaCita: entity.scheduledDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt ?? entity.createdAt,
      deletedAt: null,
      checklist: const [],
      reason: entity.notes,
    );
  }
}
