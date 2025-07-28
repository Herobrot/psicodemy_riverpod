import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../screens/splash_screens/onboarding_screen.dart';
import 'auth/auth_wrapper.dart';

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstTimeAsync = ref.watch(isFirstTimeProvider);
    
    return isFirstTimeAsync.when(
      data: (isFirstTime) {
        try {
          if (isFirstTime) {
            // Primera vez - mostrar onboarding
            return const OnboardingScreen();
          } else {
            // No es primera vez - ir al flujo de autenticación
            return const AuthWrapper();
          }
        } catch (e) {
          print('❌ AppWrapper - Error in data handling: $e');
          return _buildErrorScreen(context, ref, 'Error al cargar la aplicación');
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando...'),
            ],
          ),
        ),
      ),
      error: (error, stack) {
        print('❌ AppWrapper - Error: $error');
        print('❌ AppWrapper - Stack trace: $stack');
        return _buildErrorScreen(context, ref, 'Error al inicializar la aplicación');
      },
    );
  }

  Widget _buildErrorScreen(BuildContext context, WidgetRef ref, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Por favor, intenta de nuevo',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Refresh the provider
                ref.invalidate(isFirstTimeProvider);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
} 