import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../state_notifiers/auth_state_notifier.dart';
import '../state_notifiers/auth_state.dart';
import '../widgets/auth/login_form.dart';
import '../widgets/auth/google_sign_in_button.dart';
import '../widgets/auth/auth_toggle_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoginMode = true;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado de login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(loginStateNotifierProvider, (previous, next) {
        next.when(
          initial: () {},
          loading: () {},
          success: () {
            // Resetear el estado del login después del éxito
            ref.read(loginStateNotifierProvider.notifier).resetState();
          },
          error: (message) {
            // Mostrar error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Resetear el estado después de mostrar el error
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                ref.read(loginStateNotifierProvider.notifier).resetState();
              }
            });
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isAuthLoadingProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo o título
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    _isLoginMode ? 'Iniciar Sesión' : 'Registrarse',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    _isLoginMode 
                        ? 'Ingresa tus credenciales para acceder'
                        : 'Crea una nueva cuenta para comenzar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Formulario de login/registro
                  LoginForm(
                    isLoginMode: _isLoginMode,
                    isLoading: isLoading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divisor
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de Google
                  GoogleSignInButton(isLoading: isLoading),
                  
                  const SizedBox(height: 24),
                  
                  // Botón para cambiar entre login y registro
                  AuthToggleButton(
                    isLoginMode: _isLoginMode,
                    onToggle: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                      });
                      // Resetear el estado cuando cambia el modo
                      ref.read(loginStateNotifierProvider.notifier).resetState();
                    },
                  ),
                  
                  // Mostrar errores de autenticación
                  authState.maybeWhen(
                    error: (message) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 1, 1),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}