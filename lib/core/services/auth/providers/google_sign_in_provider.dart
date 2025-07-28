import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    // Configuración específica para Android
    // No necesitamos especificar clientId para Android cuando usamos google-services.json
    // clientId: '958948241114-eiivkd2td3homt3l10puoh33gd58dj3k.apps.googleusercontent.com',
    // Configuración para iOS (si es necesario)
    // iosClientId: 'TU_IOS_CLIENT_ID.apps.googleusercontent.com',
    // Configuración adicional
    scopes: [
      'email',
      'profile',
    ],
  );
});