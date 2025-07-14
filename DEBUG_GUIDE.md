# Guía de Debugging - Problemas de Autenticación

## Problema Reportado
- Error: "Instance of 'Auth Failure'" en pantalla
- No hay información útil en consola
- La API funciona correctamente (se ve el menú después de reiniciar)

## Soluciones Implementadas

### 1. Logs de Debug Mejorados

Se han agregado logs detallados en varios niveles:

#### En la pantalla de login (`sign_in_screen.dart`):
```dart
print('🔐 Iniciando sesión con email: ${_emailController.text.trim()}');
print('❌ Error en inicio de sesión: $e');
print('❌ Tipo de error: ${e.runtimeType}');
print('🚨 Error mostrado al usuario: $errorMessage');
```

#### En el AuthRepository:
```dart
print('🔐 AuthRepository: Iniciando autenticación con credenciales');
print('📡 AuthRepository: Respuesta de API recibida');
print('✅ AuthRepository: Usuario creado: ${user.toString()}');
```

#### En el ApiService:
```dart
print('🌐 ApiService: Iniciando autenticación con credenciales');
print('📤 ApiService: Enviando petición a $_baseUrl/auth/validate');
print('📡 ApiService: Respuesta recibida');
print('🔍 ApiService: Procesando respuesta HTTP');
```

### 2. Manejo de Errores Mejorado

#### Extracción de mensajes de AuthFailure:
```dart
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
```

### 3. UI de Debug Mejorada

#### Widget de error con detalles:
- Muestra el error de forma más clara
- Botón "Ver detalles de debug" que abre un diálogo
- Información adicional sobre los datos ingresados

#### Limpieza automática de errores:
- Los errores se limpian automáticamente cuando el usuario escribe
- Mejor experiencia de usuario

## Cómo Usar el Debug

### 1. Habilitar Logs
Los logs están habilitados por defecto en `lib/core/constants/debug_config.dart`:
```dart
static const bool enableAuthLogs = true;
static const bool enableApiLogs = true;
static const bool enableRepositoryLogs = true;
```

### 2. Probar la Autenticación
1. Abrir la consola de Flutter/Dart
2. Intentar iniciar sesión
3. Revisar los logs que aparecen

### 3. Interpretar los Logs

#### Flujo normal exitoso:
```
🔐 Iniciando sesión con email: usuario@ejemplo.com
🌐 ApiService: Iniciando autenticación con credenciales
📤 ApiService: Enviando petición a https://api.rutasegura.xyz/auth/auth/validate
📡 ApiService: Respuesta recibida
🔍 ApiService: Procesando respuesta HTTP
✅ ApiService: Respuesta exitosa (200)
🔐 AuthRepository: Iniciando autenticación con credenciales
📡 AuthRepository: Respuesta de API recibida
✅ AuthRepository: Creando CompleteUserModel
✅ AuthRepository: Usuario creado: CompleteUserModel(...)
💾 AuthRepository: Guardando sesión de usuario
✅ AuthRepository: Sesión guardada exitosamente
✅ Inicio de sesión exitoso
```

#### Flujo con error:
```
🔐 Iniciando sesión con email: usuario@ejemplo.com
🌐 ApiService: Iniciando autenticación con credenciales
📤 ApiService: Enviando petición a https://api.rutasegura.xyz/auth/auth/validate
📡 ApiService: Respuesta recibida
🔍 ApiService: Procesando respuesta HTTP
❌ ApiService: Error 401 - No autorizado
❌ ApiService: Error en authenticateWithCredentials
❌ AuthRepository: Error en signInWithEmailAndPassword
❌ Error en inicio de sesión: AuthFailure(type: apiError, message: Credenciales inválidas)
❌ Tipo de error: AuthFailure
🚨 Error mostrado al usuario: Credenciales inválidas
```

## Posibles Causas del Problema

### 1. Problemas de Red
- Verificar conectividad a internet
- Verificar que la API esté accesible
- Revisar logs de red en consola

### 2. Problemas de Credenciales
- Verificar email y contraseña
- Verificar formato del email
- Verificar que el usuario exista en la base de datos

### 3. Problemas de API
- Verificar que el endpoint `/auth/validate` esté funcionando
- Verificar formato de la respuesta JSON
- Verificar códigos de estado HTTP

### 4. Problemas de Código Tutor
- Verificar que el código "TUTOR" sea válido
- Verificar formato del código
- Verificar permisos del usuario

## Comandos de Debug Útiles

### Verificar conectividad a la API:
```bash
curl -X POST https://api.rutasegura.xyz/auth/health
```

### Probar endpoint de autenticación:
```bash
curl -X POST https://api.rutasegura.xyz/auth/validate \
  -H "Content-Type: application/json" \
  -d '{"correo":"test@ejemplo.com","contraseña":"password123"}'
```

### Verificar logs de Flutter:
```bash
flutter logs
```

## Próximos Pasos

1. **Ejecutar la aplicación** con los nuevos logs
2. **Intentar iniciar sesión** y revisar la consola
3. **Identificar el punto exacto** donde falla el proceso
4. **Compartir los logs** para análisis adicional

## Configuración de Debug

### Deshabilitar logs (para producción):
```dart
// En lib/core/constants/debug_config.dart
static const bool enableAuthLogs = false;
static const bool enableApiLogs = false;
static const bool enableRepositoryLogs = false;
```

### Habilitar logs específicos:
```dart
// Solo logs de autenticación
static const bool enableAuthLogs = true;
static const bool enableApiLogs = false;
static const bool enableRepositoryLogs = false;
```

## Contacto

Si el problema persiste después de revisar los logs, comparte:
1. Los logs completos de la consola
2. El mensaje de error exacto que aparece en pantalla
3. Los datos que estás usando para el login
4. El estado de la API (si puedes verificarlo) 