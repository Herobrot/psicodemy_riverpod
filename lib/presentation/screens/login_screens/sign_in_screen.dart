import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/constants/enums/tipo_usuario.dart';
import '../../providers/simple_auth_providers.dart';
import '../../../core/services/auth/providers/google_sign_in_provider.dart';
import '../../providers/simple_auth_providers.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';
import '../main_screen.dart';
import '../tutor_screens/tutor_main_screen.dart';
import 'package:psicodemy/core/services/auth/repositories/auth_repository.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false;  
  String? _error;

  @override
  void initState() {
    super.initState();
    // Agregar listeners para limpiar errores cuando el usuario escriba
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);  
  }

  void _clearError() {
    if (_error != null) {
      setState(() {
        _error = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearError);
    _passwordController.removeListener(_clearError);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      print('🔐 Iniciando sesión con email: ${_emailController.text.trim()}');
      
      // Mostrar mensaje de progreso al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conectando con el servidor...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      final authService = ref.read(authServiceProvider);
      
      final completeUser = await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim()
      );

      print('✅ Inicio de sesión exitoso');
      print('Usuario objeto: $completeUser');
      print('🔍 Tipo de usuario: ${completeUser.tipoUsuario}');
      print('🔍 UserID: ${completeUser.userId}');
      print('🔍 UID: ${completeUser.uid}');
      
      // Si llegamos aquí, el inicio de sesión fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso'),
            backgroundColor: Colors.green,
          ),
        );
        // NO hacer navegación manual - dejar que AuthWrapper maneje la navegación
        // El AuthWrapper detectará automáticamente el cambio de estado y navegará
        print('🔍 SignInScreen: Dejando que AuthWrapper maneje la navegación');
        
        // Forzar actualización del estado de autenticación
        print('🔍 SignInScreen: Forzando actualización del estado...');
        ref.invalidate(currentCompleteUserProvider);
        
        // Pequeño delay para asegurar que el estado se actualice
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    } catch (e) {
      print('❌ Error en inicio de sesión: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      
      if (mounted) {
        // Si hay un error, cerrar sesión de Firebase para evitar navegación incorrecta
        try {
          final authActions = ref.read(authActionsProvider);
          await authActions.signOut();
        } catch (signOutError) {
          print('❌ Error al cerrar sesión después del error: $signOutError');
        }
        
        String errorMessage;
        
        // Manejar errores específicos
        if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Tiempo de espera agotado. Verifica tu conexión a internet e intenta nuevamente.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
        } else if (e.toString().contains('AuthFailure')) {
          // Extraer el mensaje del AuthFailure
          final errorString = e.toString();
          if (errorString.contains('message:')) {
            final startIndex = errorString.indexOf('message:') + 8;
            final endIndex = errorString.indexOf(')', startIndex);
            if (endIndex > startIndex) {
              errorMessage = errorString.substring(startIndex, endIndex).trim();
            } else {
              errorMessage = 'Error de autenticación: ${errorString.split('(').first.trim()}';
            }
          } else {
            errorMessage = 'Error de autenticación: ${errorString.split('(').first.trim()}';
          }
        } else {
          errorMessage = 'Error inesperado: ${e.toString()}';
        }
        
        setState(() {
          _error = errorMessage;
        });
        
        // Mostrar error en consola para debug
        print('🚨 Error mostrado al usuario: $errorMessage');
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!mounted) return;
    
    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      print('🔐 Iniciando sesión con Google...');
      
      // Mostrar mensaje de progreso al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conectando con Google...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      final authService = ref.read(authServiceProvider);
      
      final completeUser = await authService.signInWithGoogle();

      print('✅ Inicio de sesión con Google exitoso');
      print('Usuario objeto: $completeUser');
      print('🔍 Tipo de usuario: ${completeUser.tipoUsuario}');
      print('🔍 UserID: ${completeUser.userId}');
      print('🔍 UID: ${completeUser.uid}');
      
      // Si llegamos aquí, el inicio de sesión fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso con Google'),
            backgroundColor: Colors.green,
          ),
        );
        
        // NO hacer navegación manual - dejar que AuthWrapper maneje la navegación
        print('🔍 SignInScreen: Dejando que AuthWrapper maneje la navegación');
        
        // Forzar actualización del estado de autenticación
        print('🔍 SignInScreen: Forzando actualización del estado...');
        ref.invalidate(currentCompleteUserProvider);
        
        // Pequeño delay para asegurar que el estado se actualice
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    } catch (e) {
      print('❌ Error en inicio de sesión con Google: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      
      if (mounted) {
        // NO cerrar sesión automáticamente en caso de error
        // Solo mostrar el error al usuario
        
        String errorMessage;
        
        // Manejar errores específicos de Google Sign In
        if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Tiempo de espera agotado. Verifica tu conexión a internet e intenta nuevamente.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
        } else if (e.toString().contains('sign_in_canceled') || e.toString().contains('googleSignInCancelled')) {
          errorMessage = 'Inicio de sesión con Google cancelado por el usuario.';
        } else if (e.toString().contains('network_error') || e.toString().contains('networkError')) {
          errorMessage = 'Error de red durante el inicio de sesión con Google. Verifica tu conexión.';
        } else if (e.toString().contains('AuthFailure')) {
          // Extraer el mensaje del AuthFailure
          final errorString = e.toString();
          if (errorString.contains('message:')) {
            final startIndex = errorString.indexOf('message:') + 8;
            final endIndex = errorString.indexOf(')', startIndex);
            if (endIndex > startIndex) {
              errorMessage = errorString.substring(startIndex, endIndex).trim();
            } else {
              errorMessage = 'Error de autenticación con Google: ${errorString.split('(').first.trim()}';
            }
          } else {
            errorMessage = 'Error de autenticación con Google: ${errorString.split('(').first.trim()}';
          }
        } else if (e.toString().contains('PigeonUserDetails')) {
          errorMessage = 'Error interno de Google Sign In. Intenta de nuevo.';
        } else {
          errorMessage = 'Error inesperado con Google Sign In: ${e.toString()}';
        }
        
        setState(() {
          _error = errorMessage;
        });
        
        // Mostrar error en consola para debug
        print('🚨 Error mostrado al usuario: $errorMessage');
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 32),
                  
                  // Campo de correo
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!value.contains('@')) {
                        return 'Por favor ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de contraseña
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !_showPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),                  
                  
                  // Link de contraseña olvidada
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),
                  
                  // Mostrar error si existe
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Error de autenticación',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              // Mostrar información de debug
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Información de Debug'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Error: $_error'),
                                      const SizedBox(height: 8),
                                      Text('Email: ${_emailController.text}'),
                                      const SizedBox(height: 8),
                                      const Text('Revisa la consola para más detalles.'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Ver detalles de debug'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Botón de iniciar sesión
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('O inicia sesión con'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón de Google
                  Center(
                    child: InkWell(
                      onTap: _isLoading ? null : _signInWithGoogle,
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'lib/src/shared_imgs/gl.webp',
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                  ),
                  
                  // Botón de debug temporal
                 
                  
                  const SizedBox(height: 16),
                  
                  // Link a registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes una cuenta? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.red, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
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