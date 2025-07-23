import 'package:flutter/material.dart';
import '../../../core/services/appointments/models/appointment_model.dart';

class FiltroCitasWidget extends StatelessWidget {
  final EstadoCita estadoSeleccionado;
  final ValueChanged<EstadoCita> onEstadoChanged;
  final String textoBusqueda;
  final ValueChanged<String> onTextoBusquedaChanged;
  final List<EstadoCita> estadosDisponibles;

  const FiltroCitasWidget({
    super.key,
    required this.estadoSeleccionado,
    required this.onEstadoChanged,
    required this.textoBusqueda,
    required this.onTextoBusquedaChanged,
    required this.estadosDisponibles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Dropdown para estado
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<EstadoCita>(
              value: estadoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: estadosDisponibles.map((estado) => DropdownMenuItem(
                value: estado,
                child: Text(estado.displayName),
              )).toList(),
              onChanged: (nuevoEstado) {
                if (nuevoEstado != null) onEstadoChanged(nuevoEstado);
              },
            ),
          ),
          const SizedBox(width: 12),
          // TextField para búsqueda por ID de alumno
          Expanded(
            flex: 3,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por ID de alumno',
                border: OutlineInputBorder(),
                isDense: true,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onTextoBusquedaChanged,
              controller: TextEditingController(text: textoBusqueda),
            ),
          ),
        ],
      ),
    );
  }
} 