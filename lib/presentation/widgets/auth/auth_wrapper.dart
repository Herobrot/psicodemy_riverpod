import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_auth_providers.dart';
import '../../screens/login_screens/login_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/tutor_screens/tutor_main_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isAuthLoadingProvider);
    final isAuth = ref.watch(isAuthenticatedProvider);
    final isTutor = ref.watch(isTutorProvider);
    final isAlumno = ref.watch(isAlumnoProvider);

    // Debug logs
    print('🔍 AuthWrapper - isLoading: $isLoading, isAuth: $isAuth, isTutor: $isTutor, isAlumno: $isAlumno');

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isAuth) {
      return const LoginScreen();
    }

    // Si el usuario está autenticado, redirigir según su tipo
    if (isTutor) {
      return const TutorMainScreen();
    } else if (isAlumno) {
      return const MainScreen();
    } else {
      // Si no se puede determinar el tipo, cerrar sesión automáticamente
      // Esto hará que el AuthWrapper vuelva a mostrar el LoginScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authActionsProvider).signOut();
      });
      
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('No se pudo determinar el tipo de usuario.'),
              SizedBox(height: 16),
              Text('Cerrando sesión...'),
            ],
          ),
        ),
      );
    }
  }
}