import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth/auth_service.dart';
import '../../../core/services/api_service_provider.dart';
import '../../../core/types/tipo_usuario.dart';
import 'sign_in_screen.dart';
import '../main_screen.dart';
import '../tutor_screens/tutor_main_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _codigoTutorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _codigoTutorController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      final completeUser = await authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        codigoTutor: _codigoTutorController.text.trim().isNotEmpty 
            ? _codigoTutorController.text.trim() 
            : null,
      );

      // Si llegamos aquí, el registro fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar a la pantalla correspondiente basándose en el tipo de usuario
        _navigateToAppropriateScreen(completeUser);
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

  Future<void> _signUpWithGoogle() async {
    setState(() { 
      _isLoading = true; 
      _error = null; 
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      final completeUser = await authService.signInWithGoogle();

      // Si llegamos aquí, el registro fue exitoso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso con Google'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar a la pantalla correspondiente basándose en el tipo de usuario
        _navigateToAppropriateScreen(completeUser);
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
                ? 'Código válido: serás registrado como TUTOR ✓' 
                : 'Código inválido: serás registrado como ALUMNO ℹ️'
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

  void _navigateToAppropriateScreen(dynamic completeUser) {
    // Determinar el tipo de usuario y navegar
    if (completeUser.tipoUsuario == TipoUsuario.tutor) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TutorMainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
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
                    'Crea una cuenta',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de confirmar contraseña
                  TextFormField(
                    controller: _confirmController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Confirmar Contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !_showConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de código de tutor (opcional)
                  TextFormField(
                    controller: _codigoTutorController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.school_outlined),
                      labelText: 'Código de Institución (opcional)',
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
                                'Si no tienes código, se te registrará como alumno.\n\n'
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
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Al hacer clic en crear cuenta, usted está de acuerdo con las políticas de uso.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.left,
                  ),
                  
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Botón de crear cuenta
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUpWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Crear cuenta', style: TextStyle(color: Colors.white)),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('O regístrate con'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón de Google
                  Center(
                    child: InkWell(
                      onTap: _isLoading ? null : _signUpWithGoogle,
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
                  
                  // Link a inicio de sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes una cuenta? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const SignInScreen()),
                          );
                        },
                        child: const Text(
                          'Iniciar sesión',
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