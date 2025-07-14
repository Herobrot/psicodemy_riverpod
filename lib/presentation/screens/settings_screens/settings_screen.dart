import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_auth_providers.dart';
import '../../screens/login_screens/sign_in_screen.dart';
import 'package:psicodemy/core/services/auth/repositories/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Perfil del usuario
            _buildUserProfile(user?.email ?? 'Usuario'),
            
            const SizedBox(height: 32),
            
            // Configuraciones de cuenta
            _buildSection(
              title: 'Cuenta',
              items: [
                _buildSettingItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  subtitle: 'Editar información personal',
                  onTap: () {
                    // TODO: Ir a perfil
                  },
                ),
                _buildSettingItem(
                  icon: Icons.security,
                  title: 'Privacidad y Seguridad',
                  subtitle: 'Gestionar privacidad',
                  onTap: () {
                    // TODO: Ir a privacidad
                  },
                ),
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notificaciones',
                  subtitle: 'Configurar alertas',
                  onTap: () {
                    // TODO: Ir a notificaciones
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Configuraciones de la app
            _buildSection(
              title: 'Aplicación',
              items: [
                _buildSettingItem(
                  icon: Icons.palette,
                  title: 'Apariencia',
                  subtitle: 'Tema, fuente y colores',
                  onTap: () {
                    _showThemeDialog(context);
                  },
                ),
                _buildSettingItem(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () {
                    // TODO: Cambiar idioma
                  },
                ),
                _buildSettingItem(
                  icon: Icons.storage,
                  title: 'Almacenamiento',
                  subtitle: 'Gestionar caché y datos',
                  onTap: () {
                    _showStorageDialog(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Configuraciones de bienestar
            _buildSection(
              title: 'Bienestar',
              items: [
                _buildSettingItem(
                  icon: Icons.schedule,
                  title: 'Recordatorios',
                  subtitle: 'Configurar recordatorios diarios',
                  onTap: () {
                    // TODO: Configurar recordatorios
                  },
                ),
                _buildSettingItem(
                  icon: Icons.auto_awesome,
                  title: 'Citas Diarias',
                  subtitle: 'Personalizar citas inspiracionales',
                  onTap: () {
                    // TODO: Configurar citas
                  },
                ),
                _buildSettingItem(
                  icon: Icons.insights,
                  title: 'Estadísticas',
                  subtitle: 'Ver progreso y métricas',
                  onTap: () {
                    // TODO: Ver estadísticas
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Soporte
            _buildSection(
              title: 'Soporte',
              items: [
                _buildSettingItem(
                  icon: Icons.help,
                  title: 'Ayuda y Soporte',
                  subtitle: 'FAQ y contacto',
                  onTap: () {
                    // TODO: Ir a ayuda
                  },
                ),
                _buildSettingItem(
                  icon: Icons.bug_report,
                  title: 'Reportar Problema',
                  subtitle: 'Enviar feedback',
                  onTap: () {
                    // TODO: Reportar problema
                  },
                ),
                _buildSettingItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  subtitle: 'Versión y términos',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Botón de cerrar sesión
            _buildSignOutButton(context, ref),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(String email) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF4CAF50),
            child: Text(
              email.isNotEmpty ? email[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email.split('@')[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Editar perfil
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF4CAF50),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirmed = await _showSignOutDialog(context);
          if (confirmed == true) {
            await ref.read(authActionsProvider).signOut();
            // Invalidar providers relacionados con el usuario
            ref.invalidate(currentCompleteUserProvider);
            ref.invalidate(currentUserTypeProvider);
            ref.invalidate(isTutorProvider);
            ref.invalidate(isAlumnoProvider);
            ref.invalidate(authRepositoryProvider);
            // Navegar a la pantalla de login y limpiar la pila
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool?> _showSignOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apariencia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Claro'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Cambiar a tema claro
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Oscuro'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Cambiar a tema oscuro
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_mode),
              title: const Text('Sistema'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Usar tema del sistema
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Almacenamiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Caché: 12.5 MB'),
            Text('Datos offline: 3.2 MB'),
            Text('Imágenes: 8.1 MB'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Limpiar caché
                },
                child: const Text('Limpiar Caché'),
              ),
            ),
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
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Psicodemy',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Psicodemy. Todos los derechos reservados.',
      children: [
        const Text(
          'Una aplicación para el bienestar mental y el crecimiento personal.',
        ),
      ],
    );
  }
} 