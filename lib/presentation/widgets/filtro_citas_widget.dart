import 'package:flutter/material.dart';
import '../../../core/services/appointments/models/appointment_model.dart';

class FiltroCitasWidget extends StatefulWidget {
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
  State<FiltroCitasWidget> createState() => _FiltroCitasWidgetState();
}

class _FiltroCitasWidgetState extends State<FiltroCitasWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.textoBusqueda);
  }

  @override
  void didUpdateWidget(FiltroCitasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textoBusqueda != widget.textoBusqueda) {
      _searchController.text = widget.textoBusqueda;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es muy pequeño, apilar verticalmente
          if (constraints.maxWidth < 400) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown para estado
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<EstadoCita>(
                      value: widget.estadoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: widget.estadosDisponibles.map((estado) => DropdownMenuItem(
                        value: estado,
                        child: Text(
                          estado.displayName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )).toList(),
                      onChanged: (nuevoEstado) {
                        if (nuevoEstado != null) widget.onEstadoChanged(nuevoEstado);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TextField para búsqueda por ID de alumno
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar alumno',
                        hintText: 'ID del alumno',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                      onChanged: widget.onTextoBusquedaChanged,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Si hay suficiente espacio, usar layout horizontal
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Dropdown para estado
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<EstadoCita>(
                    value: widget.estadoSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: widget.estadosDisponibles.map((estado) => DropdownMenuItem(
                      value: estado,
                      child: Text(
                        estado.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    onChanged: (nuevoEstado) {
                      if (nuevoEstado != null) widget.onEstadoChanged(nuevoEstado);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // TextField para búsqueda por ID de alumno
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar alumno',
                      hintText: 'ID del alumno',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixIcon: Icon(Icons.search, size: 20),
                    ),
                    onChanged: widget.onTextoBusquedaChanged,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 