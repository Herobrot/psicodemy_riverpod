# Pruebas Unitarias - ApiService

Este directorio contiene las pruebas unitarias para el servicio `ApiService` de la aplicación Psicodemy.

## Archivos de Pruebas

### `api_service_test.dart`
Contiene las pruebas unitarias completas para el `ApiService`, incluyendo:

- **Constructor y configuración**: Pruebas de inicialización del servicio
- **validateTutorCode**: Validación de códigos de tutor
- **authenticateWithFirebase**: Autenticación con Firebase
- **authenticateWithCredentials**: Autenticación tradicional
- **healthCheck**: Verificación de estado de servicios
- **detailedHealthCheck**: Verificación detallada de servicios
- **Error Handling**: Manejo de errores HTTP (400, 401, 500)
- **Manejo de errores de red**: SocketException, ClientException
- **Headers y configuración**: Verificación de headers HTTP
- **Timeout y configuración**: Verificación de timeouts

### `api_service_test.mocks.dart`
Archivo generado automáticamente por Mockito que contiene los mocks de las dependencias:
- `MockClient` para http.Client
- `MockFlutterSecureStorage` para FlutterSecureStorage

## Dependencias de Testing

Las siguientes dependencias están configuradas en `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  freezed: ^3.1.0
```

## Ejecutar las Pruebas

### Ejecutar todas las pruebas
```bash
flutter test
```

### Ejecutar solo las pruebas del ApiService
```bash
flutter test test/api_service_test.dart
```

### Ejecutar con cobertura
```bash
flutter test --coverage
```

### Generar reporte de cobertura
```bash
genhtml coverage/lcov.info -o coverage/html
```

## Generar Mocks

Si necesitas regenerar los mocks después de cambios en las dependencias:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Cobertura de Pruebas

Las pruebas cubren los siguientes aspectos del `ApiService`:

### ✅ Métodos Probados
- `validateTutorCode()` - Validación de códigos de tutor
- `authenticateWithFirebase()` - Autenticación con Firebase
- `authenticateWithCredentials()` - Autenticación tradicional
- `healthCheck()` - Health check de servicios
- `detailedHealthCheck()` - Health check detallado

### ✅ Casos de Error Probados
- Errores HTTP (400, 401, 500)
- Errores de red (SocketException, ClientException)
- Respuestas vacías
- JSON inválido
- Timeouts

### ⚠️ Métodos No Probados (Requieren Autenticación)
Los siguientes métodos requieren autenticación Firebase y no están incluidos en las pruebas unitarias básicas:
- `getUserProfile()`
- `getUsersList()`
- `createAppointment()`
- `getAppointments()`
- `getAppointmentById()`
- `updateAppointment()`
- `updateAppointmentStatus()`
- `deleteAppointment()`
- `getTutorsFromApi()`
- Métodos de chat (`sendChatMessage`, `getChatHistory`, etc.)
- Métodos de conversaciones (`sendPrivateMessage`, `getUserConversations`, etc.)

## Estructura de las Pruebas

Cada grupo de pruebas sigue el patrón AAA (Arrange-Act-Assert):

```dart
group('Nombre del Grupo', () {
  test('descripción del test', () async {
    // Arrange - Configurar mocks y datos de prueba
    when(mockClient.post(...)).thenAnswer(...);
    
    // Act - Ejecutar el método a probar
    final result = await apiService.methodName();
    
    // Assert - Verificar el resultado
    expect(result, equals(expectedValue));
  });
});
```

## Mocking

Las pruebas utilizan Mockito para crear mocks de las dependencias:

```dart
@GenerateMocks([
  http.Client,
  FlutterSecureStorage,
])
```

### Configuración de Mocks
```dart
setUp(() {
  mockClient = MockClient();
  mockSecureStorage = MockFlutterSecureStorage();
  
  apiService = ApiService(
    client: mockClient,
    secureStorage: mockSecureStorage,
  );
});
```

### Verificación de Llamadas
```dart
verify(mockClient.post(
  Uri.parse('$baseUrl/auth/firebase'),
  headers: anyNamed('headers'),
  body: anyNamed('body'),
)).called(1);
```

## Mejoras Futuras

1. **Pruebas de Integración**: Agregar pruebas que requieran autenticación real
2. **Pruebas de Performance**: Medir tiempos de respuesta
3. **Pruebas de Edge Cases**: Casos límite y valores extremos
4. **Pruebas de Seguridad**: Validar manejo seguro de tokens
5. **Pruebas de Concurrencia**: Múltiples llamadas simultáneas

## Notas Importantes

- Las pruebas están diseñadas para ser independientes y no requieren servicios externos
- Los mocks simulan respuestas HTTP reales
- El timeout configurado es de 30 segundos por defecto
- Las pruebas manejan tanto casos exitosos como casos de error
- Se utiliza inyección de dependencias para facilitar el testing 