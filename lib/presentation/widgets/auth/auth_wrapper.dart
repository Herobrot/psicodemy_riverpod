import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_auth_providers.dart';
import '../../screens/login_screens/login_screen.dart';
import '../../screens/main_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isAuthLoadingProvider);
    final errorMsg = ref.watch(authErrorMessageProvider);
    final isAuth = ref.watch(isAuthenticatedProvider);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMsg != null) {
      // Le pasamos un callback que refresca el estado de auth
      return _errorScreen(
        context,
        errorMsg,
        () => ref.refresh(authStateChangesProvider),
      );
    }

    return isAuth ? const MainScreen() : const LoginScreen();
  }

  Widget _errorScreen(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error de autenticación',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,            // aquí uso el callback
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}