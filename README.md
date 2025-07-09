# flutter_application_1_a

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# psicodemy
lib/
├── core/
│   ├── services/               # Capa de servicios
│   │   └── auth/               # Servicios específicos de autenticación
│   │       ├── auth_service.dart
│   │       ├── exceptions/      # Manejo de errores personalizados
│   │       └── models/          # Modelos usados para la autenticación (Firebase y Auth_State)
│   │       └── providers/       # Providers relacionados con auth
│   │       └── repositories/    # Interfaz e implementación (Auth y Secure_Storage)
│   │       └── use_cases/       # Casos de uso
│   ├── constants/
│   ├── utils/
│   ├── network/
│   └── shared_preferences/
├── data/
│   ├── models/          # Modelos de datos
│   ├── repositories/    # Implementaciones concretas
│   └── datasources/     # Firebase/API/local
├── domain/
│   ├── entities/        # Entidades abstractas
│   ├── repositories/    # Interfaces de repositorios
│   └── use_cases/       # Casos de uso
└── presentation/
│   ├── providers/       # Todos los providers de Riverpod
│   ├── screens/         # Pantallas
│   ├── widgets/         # Componentes de pantallas (Widgets)
│   │   └── auth/        # Widgets especificos de autenticación
│   └── state_notifiers/ # StateNotifiers para lógica compleja
└── main.dart