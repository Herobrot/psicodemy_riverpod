import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_notifiers/auth_state_notifier.dart';

class GoogleSignInButton extends ConsumerWidget {
  final bool isLoading;

  const GoogleSignInButton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => _signInWithGoogle(ref),
        icon: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Image.asset(
                'assets/images/google_logo.png', // Asegúrate de agregar el logo de Google
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si no tienes el logo de Google
                  return const Icon(Icons.login, color: Colors.red);
                },
              ),
        label: Text(
          'Continuar con Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLoading ? Colors.grey : Colors.black87,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isLoading ? Colors.grey[300]! : Colors.grey[400]!,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(WidgetRef ref) async {
    await ref.read(loginStateNotifierProvider.notifier).signInWithGoogle();
  }
}
