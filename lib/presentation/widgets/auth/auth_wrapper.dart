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
    final currentUser = ref.watch(currentCompleteUserProvider);
    

    // Si está cargando, mostrar pantalla de carga
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Si no está autenticado, mostrar pantalla de login
    if (!isAuth) {
      return const LoginScreen();
    }

    // Si está autenticado pero el currentUser aún está cargando, mostrar pantalla de carga
    return currentUser.when(
      data: (user) {        
        // Si el usuario está autenticado pero no tenemos datos completos, mostrar carga
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando información del usuario...'),
                ],
              ),
            ),
          );
        }

        // Si el usuario está autenticado, redirigir según su tipo
        if (isTutor) {
          return const TutorMainScreen();
        } else if (isAlumno) {
          return const MainScreen();
        } else {
          // Si no se puede determinar el tipo, mostrar pantalla de carga
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando información del usuario...'),
                ],
              ),
            ),
          );
        }
      },
      loading: () {        
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando información del usuario...'),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {        
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error al cargar información del usuario'),
                SizedBox(height: 16),
                Text('Por favor, intenta iniciar sesión nuevamente'),
              ],
            ),
          ),
        );
      },
    );
  }
}
