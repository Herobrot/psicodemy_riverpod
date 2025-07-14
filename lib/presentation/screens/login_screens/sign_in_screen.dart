import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/services/api_service_provider.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codigoTutorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showCodigoTutor = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Agregar listeners para limpiar errores cuando el usuario escriba
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
    _codigoTutorController.addListener(_clearError);
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
    _codigoTutorController.removeListener(_clearError);
    _emailController.dispose();
    _passwordController.dispose();
    _codigoTutorController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      print('🔐 Iniciando sesión con email: ${_emailController.text.trim()}');
      final authService = ref.read(authServiceProvider);
      
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        codigoTutor: _codigoTutorController.text.trim().isNotEmpty 
            ? _codigoTutorController.text.trim() 
            : null,
      );

      print('✅ Inicio de sesión exitoso');
      // Si llegamos aquí, el inicio de sesión fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('❌ Error en inicio de sesión: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      
      String errorMessage;
      if (e.toString().contains('AuthFailure')) {
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
        errorMessage = e.toString();
      }
      
      setState(() {
        _error = errorMessage;
      });
      
      // Mostrar error en consola para debug
      print('🚨 Error mostrado al usuario: $errorMessage');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      await authService.signInWithGoogle(
        codigoTutor: _codigoTutorController.text.trim().isNotEmpty 
            ? _codigoTutorController.text.trim() 
            : null,
      );

      // Si llegamos aquí, el inicio de sesión fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso con Google'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _validateTutorCode() async {
    final codigo = _codigoTutorController.text.trim();
    if (codigo.isEmpty) return;

    try {
      final apiService = ref.read(apiServiceProvider);
      final isValid = await apiService.validateTutorCode(codigo);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isValid 
                ? 'Código válido: iniciarás sesión como TUTOR ✓' 
                : 'Código inválido: iniciarás sesión como ALUMNO ℹ️'
            ),
            backgroundColor: isValid ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al validar el código'),
            backgroundColor: Colors.red,
          ),
        );
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
                  
                  // Botón para mostrar/ocultar código de tutor
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showCodigoTutor = !_showCodigoTutor;
                      });
                    },
                    icon: Icon(_showCodigoTutor ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    label: const Text('¿Tienes código de institución?'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  
                  // Campo de código de tutor (condicional)
                  if (_showCodigoTutor) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _codigoTutorController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.school_outlined),
                        labelText: 'Código de Institución',
                        border: const OutlineInputBorder(),
                        hintText: 'Ingresa "TUTOR" si eres tutor',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.help_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Código de Institución'),
                                content: const Text(
                                  'Si tienes un código de institución válido, ingrésalo aquí para obtener permisos de tutor. '
                                  'Si no tienes código, iniciarás sesión como alumno.\n\n'
                                  'Código válido para tutores: TUTOR'
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Entendido'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) {
                        // Validar código automáticamente cuando sea "TUTOR"
                        if (value.toUpperCase() == 'TUTOR') {
                          _validateTutorCode();
                        }
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
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
                                      Text('Código tutor: ${_codigoTutorController.text}'),
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