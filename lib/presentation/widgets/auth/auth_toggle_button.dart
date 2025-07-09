import 'package:flutter/material.dart';

class AuthToggleButton extends StatelessWidget {
  final bool isLoginMode;
  final VoidCallback onToggle;

  const AuthToggleButton({
    super.key,
    required this.isLoginMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginMode ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: onToggle,
          child: Text(
            isLoginMode ? 'Regístrate' : 'Inicia Sesión',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}