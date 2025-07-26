import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/auth/models/complete_user_model.dart';
import '../../../core/services/auth/repositories/secure_storage_repository.dart';
import '../../../core/services/appointments/models/appointment_model.dart';
import '../../../core/services/appointments/providers/appointment_providers.dart';
import '../../../core/services/users/user_mapping_service.dart';
import '../../widgets/filtro_citas_widget.dart';
import '../../widgets/user_name_display.dart';
import 'tutor_appointment_detail_screen.dart';

class TutorAppointmentsScreen extends ConsumerStatefulWidget {
  const TutorAppointmentsScreen({super.key});

  @override
  ConsumerState<TutorAppointmentsScreen> createState() => _TutorAppointmentsScreenState();
}

class _TutorAppointmentsScreenState extends ConsumerState<TutorAppointmentsScreen> {
  String? _selectedAlumnoId;
  String? realTutorId;
  

  AppointmentModel? _selectedAppointment;
  bool _showFiltroAvanzado = false;
  bool _isRefreshing = false;
  DateTime? _lastRefreshTime;

  // Paginación local
  int _currentPage = 1;
  static const int _pageSize = 6;

  // Estado para filtros
  EstadoCita _estadoFiltro = EstadoCita.confirmada;
  String _busquedaAlumno = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = SecureStorageRepositoryImpl(const FlutterSecureStorage());
    final savedUserData = await storage.read('complete_user_data');
    if (savedUserData != null) {
      try {
        final userData = CompleteUserModel.fromJson(savedUserData);
        setState(() {
          realTutorId = userData.userId;
        });
      } catch (e) {
      }
    }
    print('realTutorId: $realTutorId');
  }

  // Método para recargar las citas
  void _refreshAppointments() {
    print('🔄 Recargando citas...');
    
    setState(() {
      _isRefreshing = true;
    });
    
    ref.refresh(appointmentListProvider);
    
    // Mostrar feedback al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recargando citas...'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );
    
    // Resetear el estado de carga después de un breve delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    });
  }

  // Método para limpiar filtros
  void _clearFilters() {
    setState(() {
      _estadoFiltro = EstadoCita.confirmada;
      _busquedaAlumno = '';
      _currentPage = 1;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtros limpiados'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Método para resetear paginación
  void _resetPagination() {
    setState(() {
      _currentPage = 1;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Volviendo a la primera página'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Método para actualizar nombres de usuarios
  void _refreshUserNames() {
    final userMappingService = ref.read(userMappingServiceProvider);
    userMappingService.clearCache();
    
    // Invalidar todos los providers de nombres de usuario
    ref.invalidate(userNameProvider);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Actualizando nombres de usuarios...'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {  
    final allAppointmentsAsync = ref.watch(appointmentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas como Tutor'),
        actions: [
          IconButton(
            icon: Icon(_showFiltroAvanzado ? Icons.filter_alt_off : Icons.filter_alt),
            tooltip: _showFiltroAvanzado ? 'Ocultar filtros avanzados' : 'Mostrar filtros avanzados',
            onPressed: () {
              setState(() {
                _showFiltroAvanzado = !_showFiltroAvanzado;
              });
            },
          ),
          IconButton(
            icon: _isRefreshing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Recargar citas',
            onPressed: _isRefreshing ? null : _refreshAppointments,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  _refreshAppointments();
                  break;
                case 'clear_filters':
                  _clearFilters();
                  break;
                case 'reset_pagination':
                  _resetPagination();
                  break;
                case 'refresh_users':
                  _refreshUserNames();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Recargar citas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_filters',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Limpiar filtros'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset_pagination',
                child: Row(
                  children: [
                    Icon(Icons.first_page, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Ir a primera página'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh_users',
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Actualizar nombres'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: allAppointmentsAsync.when(
        data: (appointments) {
          // Filtrar citas del tutor actual
          List<AppointmentModel> filtered = appointments.where((appointment) => 
            appointment.idTutor == realTutorId
          ).toList();

          // Aplicar filtros de estado y búsqueda por ID de alumno
          filtered = filtered
              .where((a) => a.estadoCita == _estadoFiltro)
              .where((a) => a.idAlumno.contains(_busquedaAlumno))
              .toList();

          // Si quieres mantener el filtro por alumno específico, puedes dejar esto opcional
          // if (_selectedAlumnoId != null) {
          //   filtered = filtered.where((a) => a.idAlumno == _selectedAlumnoId).toList();
          // } 
          filtered.sort((a, b) => b.fechaCita.compareTo(a.fechaCita));

          // Paginación local
          final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999);
          final start = (_currentPage - 1) * _pageSize;
          final end = (_currentPage * _pageSize).clamp(0, filtered.length);
          final pageItems = filtered.sublist(start, end);

          return Column(
            children: [
              if (_showFiltroAvanzado)
                Column(
                  children: [
                    FiltroCitasWidget(
                      estadoSeleccionado: _estadoFiltro,
                      onEstadoChanged: (nuevoEstado) {
                        setState(() {
                          _estadoFiltro = nuevoEstado;
                          _currentPage = 1;
                        });
                      },
                      textoBusqueda: _busquedaAlumno,
                      onTextoBusquedaChanged: (nuevoTexto) {
                        setState(() {
                          _busquedaAlumno = nuevoTexto;
                          _currentPage = 1;
                        });
                      },
                      estadosDisponibles: EstadoCita.values,
                    ),
                    // Botón de recarga adicional en el área de filtros
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isRefreshing ? null : _refreshAppointments,
                              icon: _isRefreshing 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.refresh, size: 18),
                              label: Text(_isRefreshing ? 'Recargando...' : 'Recargar citas'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Limpiar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              _HeaderSection(
                total: filtered.length,
                currentPage: _currentPage,
                totalPages: totalPages,
                onPrev: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
                onNext: _currentPage < totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
              // Si quieres mantener el filtro por alumno específico, puedes dejar esto opcional
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: DropdownButtonFormField<String>(
              //     value: _selectedAlumnoId,
              //     hint: const Text('Selecciona un alumno'),
              //     items: alumnos.entries.map((entry) => DropdownMenuItem(
              //       value: entry.key,
              //       child: Text('Alumno: ${entry.key}'),
              //     )).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         _selectedAlumnoId = value;
              //         _currentPage = 1;
              //       });
              //     },
              //   ),
              // ),
              Expanded(
                child: pageItems.isEmpty
                  ? const Center(child: Text('No hay citas para mostrar'))
                  : ListView.separated(
                      itemCount: pageItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemBuilder: (context, i) => _buildAppointmentCard(pageItems[i]),
                    ),
              ),
              if (filtered.isNotEmpty)
                _PaginationControls(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPrev: _currentPage > 1
                      ? () => setState(() => _currentPage--)
                      : null,
                  onNext: _currentPage < totalPages
                      ? () => setState(() => _currentPage++)
                      : null,
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
    Color estadoColor;
    IconData estadoIcon;
    switch (appointment.estadoCita) {
      case EstadoCita.pendiente:
        estadoColor = Colors.orange;
        estadoIcon = Icons.hourglass_empty_rounded;
        break;
      case EstadoCita.confirmada:
        estadoColor = Colors.blue;
        estadoIcon = Icons.check_circle_outline;
        break;
      case EstadoCita.completada:
        estadoColor = Colors.green;
        estadoIcon = Icons.verified;
        break;
      case EstadoCita.cancelada:
        estadoColor = Colors.red;
        estadoIcon = Icons.cancel_outlined;
        break;
      case EstadoCita.noAsistio:
        estadoColor = Colors.grey;
        estadoIcon = Icons.block;
        break;
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(appointment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: estadoColor.withValues(alpha: 0.15),
                radius: 28,
                child: Icon(estadoIcon, color: estadoColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserNameDisplay(
                          userId: appointment.idAlumno,
                          prefix: 'Alumno: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(_formatDate(appointment.fechaCita)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          label: Text(appointment.estadoCita.displayName),
                          backgroundColor: estadoColor.withValues(alpha: 0.15),
                          labelStyle: TextStyle(color: estadoColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (appointment.checklist.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            Icon(Icons.list_alt, size: 16, color: Colors.orange[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Tareas: ${appointment.checklist.where((item) => !item.completed).length} pendientes, ${appointment.checklist.where((item) => item.completed).length} completadas',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () => _navigateToDetail(appointment),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(AppointmentModel appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorAppointmentDetailScreen(appointment: appointment),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _AppointmentDetailSheet extends ConsumerStatefulWidget {
  final AppointmentModel appointment;
  final Future<void> Function(EstadoCita) onStatusChanged;
  final Future<void> Function(String?, String?) onEditTodo;

  const _AppointmentDetailSheet({
    required this.appointment,
    required this.onStatusChanged,
    required this.onEditTodo,
  });

  @override
  ConsumerState<_AppointmentDetailSheet> createState() => _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState extends ConsumerState<_AppointmentDetailSheet> {
  late TextEditingController _todoController;
  late TextEditingController _finishTodoController;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController(text: widget.appointment.checklist.where((item) => !item.completed).map((item) => item.description).join(', '));
    _finishTodoController = TextEditingController(text: widget.appointment.checklist.where((item) => item.completed).map((item) => item.description).join(', '));
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
    Color estadoColor;
    IconData estadoIcon;
    switch (estado) {
      case EstadoCita.pendiente:
        estadoColor = Colors.orange;
        estadoIcon = Icons.hourglass_empty_rounded;
        break;
      case EstadoCita.confirmada:
        estadoColor = Colors.blue;
        estadoIcon = Icons.check_circle_outline;
        break;
      case EstadoCita.completada:
        estadoColor = Colors.green;
        estadoIcon = Icons.verified;
        break;
      case EstadoCita.cancelada:
        estadoColor = Colors.red;
        estadoIcon = Icons.cancel_outlined;
        break;
      case EstadoCita.noAsistio:
        estadoColor = Colors.grey;
        estadoIcon = Icons.block;
        break;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(
          left: 0, right: 0, top: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: estadoColor.withValues(alpha: 0.15),
                          radius: 28,
                          child: Icon(estadoIcon, color: estadoColor, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alumno:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                            UserNameDisplay(
                              userId: widget.appointment.idAlumno,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(_formatDate(widget.appointment.fechaCita)),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(estado.displayName),
                          backgroundColor: estadoColor.withValues(alpha: 0.15),
                          labelStyle: TextStyle(color: estadoColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        labelText: 'Por hacer (to-do)',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.list_alt),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _finishTodoController,
                      decoration: const InputDecoration(
                        labelText: 'Hecho (finish to-do)',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.check),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Guardar tareas'),
                            onPressed: () => widget.onEditTodo(
                              _todoController.text,
                              _finishTodoController.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildEstadoActions(context, estado, estadoColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildEstadoActions(BuildContext context, EstadoCita estado, Color estadoColor) {
    final actions = <Widget>[];
    // Acciones según el estado actual
    if (estado == EstadoCita.pendiente) {
      actions.addAll([
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Confirmar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => widget.onStatusChanged(EstadoCita.confirmada),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => widget.onStatusChanged(EstadoCita.cancelada),
          ),
        ),
      ]);
    } else if (estado == EstadoCita.confirmada) {
      actions.addAll([
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.verified),
            label: const Text('Completar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => widget.onStatusChanged(EstadoCita.completada),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.block),
            label: const Text('No asistió'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () => widget.onStatusChanged(EstadoCita.noAsistio),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => widget.onStatusChanged(EstadoCita.cancelada),
          ),
        ),
      ]);
    }
    // Si la cita está completada, cancelada o no asistió, no hay acciones.
    if (actions.isEmpty) {
      return Center(
        child: Text(
          'No hay acciones disponibles para este estado.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    return Row(children: actions);
  }
}

// COMPONENTES AUXILIARES

class _HeaderSection extends StatelessWidget {
  final int total;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _HeaderSection({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            'Total: $total',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrev,
            color: onPrev != null ? Colors.blue : Colors.grey,
          ),
          Text('Página $currentPage de $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            color: onNext != null ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrev,
            color: onPrev != null ? Colors.blue : Colors.grey,
          ),
          Text('Página $currentPage de $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            color: onNext != null ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
} 