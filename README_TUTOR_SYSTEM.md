# Sistema de Tutores - Psicodemy

## Descripción

Se ha implementado un sistema completo de gestión de tutores para la aplicación Psicodemy. El sistema permite que los usuarios con tipo "tutor" accedan a una interfaz específica diseñada para gestionar las citas de sus alumnos.

## Características Implementadas

### 1. Redirección Automática por Tipo de Usuario

- **Tutores**: Son redirigidos a `TutorMainScreen` con acceso a la pantalla de gestión de citas
- **Alumnos**: Son redirigidos a `MainScreen` (pantalla original para alumnos)
- **Detección automática**: El sistema detecta el tipo de usuario basándose en el `CompleteUserModel`

### 2. Pantalla Principal de Tutor (`TutorHomeScreen`)

#### Componentes principales:
- **Tarjeta de bienvenida**: Saludo personalizado con información del tutor
- **Tarjetas de estadísticas**: Muestra citas de hoy, pendientes y completadas
- **Sección de citas pendientes**: Lista de citas que requieren atención
- **Sección de citas de hoy**: Citas programadas para el día actual

#### Características de la UI:
- Diseño moderno con gradientes y sombras
- Estados de carga y error manejados
- Colores dinámicos según el estado de las citas
- Información detallada de cada cita (estudiante, tema, hora, estado)

### 3. Arquitectura de Datos

#### Entidades:
- `AppointmentEntity`: Representa una cita con toda su información
- `AppointmentStatus`: Enum con estados (pendiente, confirmada, en progreso, completada, cancelada, reprogramada)

#### Repositorio:
- `AppointmentRepository`: Interfaz para operaciones de citas
- `AppointmentRepositoryImpl`: Implementación mock con datos de prueba

#### Casos de Uso:
- `AppointmentUseCases`: Lógica de negocio para gestión de citas
- Métodos para obtener citas por diferentes criterios
- Estadísticas y agrupación de datos

### 4. Gestión de Estado con Riverpod

#### Providers implementados:
- `appointmentStatsProvider`: Estadísticas de citas
- `pendingAppointmentsProvider`: Citas pendientes
- `todayAppointmentsProvider`: Citas de hoy
- `tutorAppointmentsProvider`: Todas las citas del tutor
- `appointmentActionsProvider`: Acciones sobre citas

#### Características:
- Actualización automática del estado
- Manejo de estados de carga y error
- Invalidación automática de providers relacionados

## Estructura de Archivos

```
lib/
├── domain/
│   ├── entities/
│   │   └── appointment_entity.dart          # Entidad de citas
│   ├── repositories/
│   │   └── appointment_repository_interface.dart  # Interfaz del repositorio
│   └── use_cases/
│       └── appointment_use_cases.dart       # Casos de uso
├── data/
│   └── repositories/
│       └── appointment_repository_impl.dart # Implementación mock
├── presentation/
│   ├── providers/
│   │   ├── appointment_providers.dart       # Providers de citas
│   │   └── simple_auth_providers.dart       # Providers de autenticación
│   ├── screens/
│   │   └── tutor_screens/
│   │       ├── tutor_home_screen.dart       # Pantalla principal de tutor
│   │       └── tutor_main_screen.dart       # Navegación de tutor
│   └── widgets/
│       └── auth/
│           └── auth_wrapper.dart            # Lógica de redirección
```

## Flujo de Autenticación

1. **Login**: El usuario se autentica normalmente
2. **Detección de tipo**: El sistema obtiene el `CompleteUserModel` del usuario
3. **Redirección**: 
   - Si `tipoUsuario == TipoUsuario.tutor` → `TutorMainScreen`
   - Si `tipoUsuario == TipoUsuario.alumno` → `MainScreen`
4. **Pantalla específica**: Cada tipo de usuario ve una interfaz optimizada para su rol

## Datos de Prueba

El sistema incluye datos mock para pruebas:

- **5 citas de ejemplo** con diferentes estados
- **Estudiantes variados** con diferentes temas de consulta
- **Fechas realistas** (hoy, mañana, pasadas)
- **Estados diversos** (pendiente, confirmada, en progreso, completada)

## Funcionalidades Futuras

### Pendientes de implementar:
- [ ] Menú lateral para tutores
- [ ] Pantalla de detalle de cita
- [ ] Funcionalidad de actualizar estado de citas
- [ ] Reprogramación de citas
- [ ] Notificaciones push para citas
- [ ] Integración con backend real
- [ ] Chat entre tutor y alumno
- [ ] Historial de citas completadas

### Mejoras sugeridas:
- [ ] Filtros avanzados para citas
- [ ] Búsqueda de estudiantes
- [ ] Exportación de reportes
- [ ] Calendario integrado
- [ ] Recordatorios automáticos

## Cómo Probar

1. **Registrar un usuario tutor**:
   - Usar código "TUTOR" durante el registro
   - El sistema automáticamente asignará tipo tutor

2. **Ver la interfaz de tutor**:
   - Después del login, serás redirigido a la pantalla de tutor
   - Verás las estadísticas y citas de ejemplo

3. **Probar la navegación**:
   - Usar la barra de navegación inferior
   - Navegar entre diferentes secciones

## Notas Técnicas

- **Estado de carga**: Simulado con delays para mostrar estados de UI
- **Datos mock**: Almacenados en memoria durante la sesión
- **Responsive**: Diseño adaptable a diferentes tamaños de pantalla
- **Performance**: Uso de `IndexedStack` para navegación eficiente

## Dependencias

- `flutter_riverpod`: Gestión de estado
- `firebase_auth`: Autenticación
- `json_annotation`: Serialización (preparado para futuro uso)

## Contribución

Para agregar nuevas funcionalidades:

1. Extender las entidades según sea necesario
2. Agregar métodos al repositorio
3. Implementar casos de uso
4. Crear providers para el estado
5. Actualizar la UI

El sistema está diseñado para ser escalable y fácil de mantener. 