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
      // Si no se puede determinar el tipo, mostrar opción para volver al login y redirigir automáticamente tras 5 segundos
      Future.delayed(const Duration(seconds: 5), () {
        if (context.mounted) {
          ref.read(authActionsProvider).signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      });
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('No se pudo determinar el tipo de usuario.'),
              const SizedBox(height: 16),
              const Text('Serás redirigido automáticamente al inicio de sesión.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(authActionsProvider).signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Volver al inicio de sesión'),
              ),
            ],
          ),
        ),
      );
    }
  }
}