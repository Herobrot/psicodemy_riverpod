class DebugConfig {
  // Habilitar/deshabilitar logs de debug
  static const bool enableAuthLogs = true;
  static const bool enableApiLogs = true;
  static const bool enableRepositoryLogs = true;
  
  // Configuración de la API
  static const String apiBaseUrl = 'https://api.rutasegura.xyz/auth';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration authTimeout = Duration(seconds: 60);
  
  // Configuración de retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Configuración de cache
  static const Duration userCacheDuration = Duration(hours: 1);
  static const Duration tokenCacheDuration = Duration(hours: 24);
}

// Función helper para logs condicionales
void debugLog(String message, {bool force = false}) {
  if (DebugConfig.enableAuthLogs || force) {
    print('🔍 DEBUG: $message');
  }
}

void authLog(String message) {
  if (DebugConfig.enableAuthLogs) {
    print('🔐 AUTH: $message');
  }
}

void apiLog(String message) {
  if (DebugConfig.enableApiLogs) {
    print('🌐 API: $message');
  }
}

void repoLog(String message) {
  if (DebugConfig.enableRepositoryLogs) {
    print('📦 REPO: $message');
  }
} 