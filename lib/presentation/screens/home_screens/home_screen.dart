import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/search_bar_home.dart';
import '../../../components/home_skeleton.dart';
import '../quotes_screens/quotes_screen.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/tutors/models/tutor_model.dart';
import '../../../core/services/appointments/repositories/appointment_repository.dart';
import '../../../core/services/appointments/appointment_service.dart';
import '../../../core/services/api_service_provider.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/services/tutors/repositories/tutor_repository.dart';
import '../../providers/appointment_providers.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../data/datasources/forum_api_service.dart';
import '../../../data/models/forum_post.dart';
import '../../screens/forum_screens/forum_screen.dart';

// Provider para obtener las citas del alumno actual
final myAppointmentsAsStudentProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final appointmentService = AppointmentService(apiService);
  final authService = ref.watch(authServiceProvider);
  final appointmentRepository = AppointmentRepository(appointmentService, authService);
  
  return await appointmentRepository.getMyAppointmentsAsStudent(
    estadoCita: EstadoCita.confirmada,
    fechaDesde: DateTime.now(),
    limit: 10,
  );
});

// Provider para obtener la próxima cita del alumno
final nextAppointmentProvider = FutureProvider<AppointmentModel?>((ref) async {
  final appointments = await ref.watch(myAppointmentsAsStudentProvider.future);
  print('appointments here: $appointments');
  
  if (appointments.isEmpty) return null;
  
  // Ordenar por fecha y obtener la más cercana
  appointments.sort((a, b) => a.fechaCita.compareTo(b.fechaCita));
  return appointments.first;
});

// Provider para obtener el tutor de una cita
final tutorForAppointmentProvider = FutureProvider.family<TutorModel?, String>((ref, tutorId) async {
  final tutorRepository = ref.watch(tutorRepositoryProvider);
  return await tutorRepository.getTutorById(tutorId);
});

// Widget para mostrar detalles de la cita y permitir cancelarla
class AppointmentDetailScreen extends ConsumerWidget {
  final AppointmentEntity appointment;
  const AppointmentDetailScreen({required this.appointment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tutor: ${appointment.tutorId}'),
            Text('Fecha: ${appointment.scheduledDate}'),
            Text('Estado: ${appointment.statusText}'),
            if (appointment.notes != null) Text('Notas: ${appointment.notes}'),
            const Spacer(),
            if (appointment.status == AppointmentStatus.pending || appointment.status == AppointmentStatus.confirmed)
              ElevatedButton(
                onPressed: () async {
                  final actions = ref.read(appointmentActionsProvider);
                  await actions.cancelAppointment(appointment.id);
                  Navigator.pop(context, true);
                },
                child: const Text('Cancelar cita'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

String? formatForumImageUrl(String? originalUrl) {
  if (originalUrl == null) return null;
  final idx = originalUrl.indexOf('/prueba');
  if (idx == -1) return originalUrl;
  final path = originalUrl.substring(idx + '/prueba'.length); // omite '/prueba'
  return 'https://pub-5d5ebeeeb5f14f0ca828d1fc5e53e0a2.r2.dev$path';
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
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
      body: Column(
        children: [
          const SearchBarHome(),
          Expanded(
            child: _isLoading ? const HomeSkeleton() : _buildHomeContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPersonalizedGreeting(),
          const SizedBox(height: 16),
          _buildCredentialCard(),
          const SizedBox(height: 16),
          _buildAppointmentCard(), // << Este es el botón que navegará
          const SizedBox(height: 16),
          _buildDoctorsSection(),
          const SizedBox(height: 16),
          _buildBootcampCard(),
          const SizedBox(height: 16),
          _buildAnniversaryCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPersonalizedGreeting() {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Usuario';
    
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
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
          const SizedBox(height: 8),
          const Text(
            '¿Cómo te sientes hoy?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Consumer(
      builder: (context, ref, child) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return const SizedBox.shrink();
        }
        final nextAppointmentAsync = ref.watch(nextStudentAppointmentProvider(user.uid));
        return nextAppointmentAsync.when(
          data: (appointment) {
            if (appointment == null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No tienes citas próximas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Agenda una nueva cita',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
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
                      child: const Text(
                        'AGENDAR →',
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            final timeUntilAppointment = appointment.scheduledDate.difference(DateTime.now());
            final hoursUntilAppointment = timeUntilAppointment.inHours;
            final daysUntilAppointment = timeUntilAppointment.inDays;
            String timeText;
            if (daysUntilAppointment > 0) {
              timeText = 'Faltan $daysUntilAppointment días para tu cita';
            } else if (hoursUntilAppointment > 0) {
              timeText = 'Faltan $hoursUntilAppointment horas para tu cita';
            } else {
              timeText = 'Tu cita es en menos de 1 hora';
            }
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentDetailScreen(appointment: appointment),
                  ),
                );
                if (result == true) {
                  ref.refresh(nextStudentAppointmentProvider(user.uid));
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tu cita',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            timeText,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
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
                      child: const Text(
                        'VER CITA →',
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cargando citas...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          error: (error, stack) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error al cargar citas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Intenta de nuevo más tarde',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
                  child: const Text(
                    'VER CITA →',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _buildCredentialCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8FA3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Obtén tu\nCredencial de\nEstudiante',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Y obtén los mejores\nDescuentos',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Solicitar', style: TextStyle(color: Color(0xFFFF6B9D), fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Color(0xFFFF6B9D), size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.network(
              'https://images.unsplash.com/photo-1556157382-97eda2d62296?w=200&h=200&fit=crop&crop=face',
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsSection() {
    // Reemplazamos la sección de doctores por publicaciones del foro
    return _buildForumPostsSection();
  }

  Widget _buildForumPostsSection() {
    return FutureBuilder<List<ForumPost>>(
      future: ForumApiService.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar publicaciones: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay publicaciones recientes.'));
        }
        final posts = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Publicaciones recientes del foro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...posts.take(2).map((post) => _buildForumPostCard(post)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildForumPostCard(ForumPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForumPostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    formatForumImageUrl(post.imageUrl!)!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 8),
              Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(post.authorName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBootcampCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B9D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BootCamp ISO4000', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                Text('26/10/26', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text('IR →', style: TextStyle(color: Color(0xFFFF6B9D), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnniversaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Aniversario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0x000ff333))),
                const SizedBox(height: 4),
                const Text('Celebremos juntos', style: TextStyle(fontSize: 14, color: Color(0x000ff666))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(16)),
                  child: const Text('Ver más →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=200&h=200&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
