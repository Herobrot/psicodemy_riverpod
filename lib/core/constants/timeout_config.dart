/// Configuración de timeouts para la aplicación
class TimeoutConfig {
  // Timeout para operaciones de Firebase Auth
  static const Duration firebaseAuth = Duration(seconds: 15);
  
  // Timeout para obtener tokens de Firebase
  static const Duration firebaseToken = Duration(seconds: 10);
  
  // Timeout para llamadas a la API
  static const Duration apiCall = Duration(seconds: 10);
  
  // Timeout para operaciones de almacenamiento
  static const Duration storage = Duration(seconds: 5);
  
  // Timeout para operaciones de red generales
  static const Duration network = Duration(seconds: 8);
} 