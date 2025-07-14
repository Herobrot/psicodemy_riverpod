# 📚 Servicios de Citas y Tutores - Documentación

## 📋 Resumen

Se han implementado servicios completos para gestionar **citas** y **tutores** en la aplicación, siguiendo la arquitectura limpia del proyecto existente. Los servicios incluyen:

- ✅ **Servicio de Citas**: Gestión completa de citas (crear, obtener, actualizar, eliminar)
- ✅ **Servicio de Tutores**: Obtención y gestión de tutores desde la API
- ✅ **Arquitectura Clean**: Servicios, repositorios, modelos y providers
- ✅ **Cache inteligente**: Cache automático para tutores con expiración
- ✅ **Manejo de errores**: Excepciones específicas y manejo robusto
- ✅ **Providers de Riverpod**: Estados reactivos y gestión de datos

## 🏗️ Arquitectura

```
lib/core/services/
├── appointments/
│   ├── models/
│   │   └── appointment_model.dart      # Modelos de citas y requests
│   ├── exceptions/
│   │   └── appointment_exception.dart   # Excepciones específicas
│   ├── providers/
│   │   └── appointment_providers.dart   # Providers de Riverpod
│   ├── repositories/
│   │   ├── appointment_repository_interface.dart
│   │   └── appointment_repository.dart
│   └── appointment_service.dart         # Servicio principal
├── tutors/
│   ├── models/
│   │   └── tutor_model.dart            # Modelos de tutores
│   ├── exceptions/
│   │   └── tutor_exception.dart        # Excepciones específicas
│   ├── providers/
│   │   └── tutor_providers.dart        # Providers de Riverpod
│   ├── repositories/
│   │   ├── tutor_repository_interface.dart
│   │   └── tutor_repository.dart
│   └── tutor_service.dart              # Servicio principal
└── examples/
    └── appointments_and_tutors_example.dart  # Ejemplo de uso
```

## 🚀 Configuración de APIs

### URLs Base
- **Citas**: `https://api.rutasegura.xyz/s1/appointments`
- **Tutores**: `https://api.rutasegura.xyz/s1/auth/users/tutor`

### Autenticación
Los servicios utilizan JWT Bearer tokens almacenados en `FlutterSecureStorage` con la clave `auth_token`.

## 📝 Modelos Principales

### Citas (Appointments)

```dart
// Estados de cita
enum EstadoCita {
  pendiente,
  confirmada,
  cancelada,
  completada,
  no_asistio,
}

// Modelo principal
class AppointmentModel {
  final String id;
  final String idTutor;
  final String idAlumno;
  final EstadoCita estadoCita;
  final DateTime fechaCita;
  final String? toDo;
  final String? finishToDo;
  // ... más campos
}

// Para crear citas
class CreateAppointmentRequest {
  final String idTutor;
  final String idAlumno;
  final DateTime fechaCita;
  final String? toDo;
}
```

### Tutores

```dart
class TutorModel {
  final String id;        // Nuevo campo: ID único del tutor
  final String nombre;
  final String correo;
}

class TutorListResponse {
  final List<TutorModel> tutores;
  final int totalTutores;
  final bool isSuccess;
}
```

## 🔧 Uso Básico

### 1. Obtener Tutores

```dart
// En un Widget Consumer
Consumer(
  builder: (context, ref, child) {
    final tutorsAsync = ref.watch(tutorsProvider);
    
    return tutorsAsync.when(
      data: (tutors) => ListView.builder(
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          final tutor = tutors[index];
          return ListTile(
            title: Text(tutor.nombre),
            subtitle: Text(tutor.correo),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  },
)
```

### 2. Crear una Cita

```dart
Future<void> createAppointment(WidgetRef ref) async {
  try {
    final request = CreateAppointmentRequest(
      idTutor: 'tutor001',   // ID único del tutor
      idAlumno: 'alumno001', // ID único del alumno
      fechaCita: DateTime.now().add(Duration(days: 1)),
      toDo: 'Revisar álgebra básica',
    );

    final appointment = await ref.read(
      createAppointmentProvider(request).future
    );
    
    print('Cita creada: ${appointment.id}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 3. Gestionar Lista de Citas

```dart
// En un Widget Consumer
Consumer(
  builder: (context, ref, child) {
    final appointmentState = ref.watch(appointmentListProvider);
    
    if (appointmentState.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (appointmentState.error != null) {
      return Text('Error: ${appointmentState.error!.message}');
    }
    
    return Column(
      children: [
        // Botón para refrescar
        ElevatedButton(
          onPressed: () => ref.read(appointmentListProvider.notifier).refresh(),
          child: Text('Refrescar'),
        ),
        
        // Lista de citas
        Expanded(
          child: ListView.builder(
            itemCount: appointmentState.appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointmentState.appointments[index];
              return ListTile(
                title: Text('Cita ${appointment.id}'),
                subtitle: Text(appointment.estadoCita.displayName),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _confirmAppointment(ref, appointment.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  },
)
```

## 🔍 Providers Disponibles

### Tutores

```dart
// Obtener todos los tutores
final tutorsProvider = FutureProvider<List<TutorModel>>

// Buscar tutor por ID
final tutorByIdProvider = FutureProvider.family<TutorModel?, String>

// Buscar tutor por email
final tutorByEmailProvider = FutureProvider.family<TutorModel?, String>

// Buscar tutores por nombre
final searchTutorsProvider = FutureProvider.family<List<TutorModel>, String>

// Lista de tutores con estado
final tutorListProvider = StateNotifierProvider<TutorListNotifier, TutorListState>

// Estadísticas de tutores
final tutorStatsProvider = FutureProvider<Map<String, dynamic>>
```

### Citas

```dart
// Lista de citas con estado
final appointmentListProvider = StateNotifierProvider<AppointmentListNotifier, AppointmentListState>

// Crear cita
final createAppointmentProvider = FutureProvider.family<AppointmentModel, CreateAppointmentRequest>

// Obtener cita por ID
final appointmentByIdProvider = FutureProvider.family<AppointmentModel, String>

// Mis citas como tutor
final myAppointmentsAsTutorProvider = FutureProvider<List<AppointmentModel>>

// Mis citas como estudiante
final myAppointmentsAsStudentProvider = FutureProvider<List<AppointmentModel>>

// Confirmar cita
final confirmAppointmentProvider = FutureProvider.family<AppointmentModel, String>

// Cancelar cita
final cancelAppointmentProvider = FutureProvider.family<AppointmentModel, String>
```

## 📊 Funcionalidades Avanzadas

### 1. Filtrado de Citas

```dart
// Cargar citas filtradas
await ref.read(appointmentListProvider.notifier).loadAppointments(
  estadoCita: EstadoCita.confirmada,
  fechaDesde: DateTime.now(),
  fechaHasta: DateTime.now().add(Duration(days: 30)),
);
```

### 2. Verificación de Conflictos

```dart
final hasConflict = await ref.read(
  scheduleConflictProvider({
    'tutorId': 'tutor_123',
    'fechaCita': DateTime.now(),
  }).future
);
```

### 3. Próximo Horario Disponible

```dart
final nextSlot = await ref.read(
  nextAvailableSlotProvider({
    'tutorId': 'tutor_123',
    'fechaPreferida': DateTime.now(),
  }).future
);
```

### 4. Estadísticas

```dart
// Estadísticas de citas
final stats = await ref.read(
  appointmentStatsProvider({
    'tutorId': 'tutor_123',
    'fechaDesde': DateTime.now().subtract(Duration(days: 30)),
    'fechaHasta': DateTime.now(),
  }).future
);

print('Total citas: ${stats['total']}');
print('Completadas: ${stats['completada']}');
print('Canceladas: ${stats['cancelada']}');
```

## 🎯 Casos de Uso Comunes

### 1. Pantalla de Selección de Tutor

```dart
class TutorSelectionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar Tutor')),
      body: Consumer(
        builder: (context, ref, child) {
          final tutorState = ref.watch(tutorListProvider);
          
          return Column(
            children: [
              // Barra de búsqueda
              TextField(
                onChanged: (value) => ref.read(tutorListProvider.notifier).searchTutors(value),
                decoration: InputDecoration(
                  hintText: 'Buscar tutores...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              
              // Lista de tutores
              Expanded(
                child: ListView.builder(
                  itemCount: tutorState.tutors.length,
                  itemBuilder: (context, index) {
                    final tutor = tutorState.tutors[index];
                    return ListTile(
                      title: Text(tutor.nombre),
                      subtitle: Text(tutor.correo),
                      onTap: () => _selectTutor(tutor),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### 2. Calendario de Citas

```dart
class AppointmentCalendar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final appointmentState = ref.watch(appointmentListProvider);
        
        return TableCalendar(
          onDaySelected: (selectedDay, focusedDay) {
            // Cargar citas para el día seleccionado
            ref.read(appointmentListProvider.notifier).loadAppointments(
              fechaDesde: selectedDay,
              fechaHasta: selectedDay.add(Duration(days: 1)),
              refresh: true,
            );
          },
          eventLoader: (day) {
            // Mostrar citas del día
            return appointmentState.appointments
                .where((appointment) => isSameDay(appointment.fechaCita, day))
                .toList();
          },
        );
      },
    );
  }
}
```

## 🛠️ Configuración del Proyecto

### 1. Dependencias Requeridas

Las siguientes dependencias ya están incluidas en el `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  http: ^1.1.0
  flutter_secure_storage: ^9.2.4
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.9
  json_serializable: ^6.8.0
```

### 2. Generar Archivos .g.dart

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Configurar Providers en Main

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## 🔒 Seguridad

- **Autenticación**: Todos los endpoints requieren JWT token
- **Almacenamiento Seguro**: Tokens guardados en `FlutterSecureStorage`
- **Validación**: Validación de datos en modelos y requests
- **Manejo de Errores**: Excepciones específicas para cada tipo de error

## 🚨 Manejo de Errores

### Tipos de Errores

```dart
// Errores de citas
AppointmentException.unauthorized()
AppointmentException.validationError()
AppointmentException.conflictError()
AppointmentException.notFound()
AppointmentException.rateLimitExceeded()

// Errores de tutores
TutorException.unauthorized()
TutorException.notFound()
TutorException.networkError()
TutorException.emptyResponse()
```

### Manejo en UI

```dart
Consumer(
  builder: (context, ref, child) {
    final appointmentState = ref.watch(appointmentListProvider);
    
    if (appointmentState.error != null) {
      return ErrorWidget(
        error: appointmentState.error!,
        onRetry: () => ref.read(appointmentListProvider.notifier).loadAppointments(),
      );
    }
    
    // ... resto del widget
  },
)
```

## 📱 Ejemplo Completo

Revisa el archivo `lib/examples/appointments_and_tutors_example.dart` para ver un ejemplo completo funcionando que incluye:

- ✅ Lista de tutores con cache
- ✅ Lista de citas con paginación
- ✅ Búsqueda de tutores
- ✅ Creación de citas
- ✅ Estadísticas
- ✅ Health check del servicio
- ✅ Manejo de errores
- ✅ Estados de carga

## 🎉 ¡Listo para Usar!

Los servicios están completamente implementados y listos para usar. Puedes:

1. **Importar los providers** en tus pantallas
2. **Usar Consumer widgets** para mostrar datos
3. **Llamar métodos** para crear/actualizar citas
4. **Manejar errores** de forma elegante
5. **Aprovechar el cache** para mejor rendimiento

¿Tienes alguna pregunta o necesitas ayuda con algún caso de uso específico? ¡Estoy aquí para ayudarte! 🚀 