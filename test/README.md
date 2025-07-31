# Pruebas Unitarias - Psicodemy

Este directorio contiene las pruebas unitarias y de widget para la aplicación Psicodemy.

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

### `sign_in_screen_test.dart`
Contiene las pruebas de widget completas para `SignInScreen`, incluyendo:

- **Renderizado de la interfaz**: Verificación de elementos UI
- **Interacciones del usuario**: Escritura en campos, toques en botones
- **Validación de formulario**: Errores de validación
- **Navegación**: Navegación entre pantallas
- **Estructura del widget**: Verificación de estructura de widgets
- **Colores y estilos**: Verificación de diseño visual
- **Interacciones complejas**: Múltiples interacciones simultáneas
- **Accesibilidad**: Labels y textos accesibles
- **Validación de entrada**: Formato de email y contraseñas
- **Estados de botones**: Verificación de estados habilitado/deshabilitado
- **Layout y espaciado**: Verificación de espaciado y ScrollView

### `api_service_test.mocks.dart`
Archivo generado automáticamente por Mockito que contiene los mocks de las dependencias:
- `MockClient` para http.Client
- `MockFlutterSecureStorage` para FlutterSecureStorage

### `sign_in_screen_test.mocks.dart`
Archivo generado automáticamente por Mockito que contiene los mocks de las dependencias:
- `MockAuthService` para AuthService

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

### Ejecutar solo las pruebas de widget
```bash
flutter test test/sign_in_screen_test.dart
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

### ✅ Pruebas Unitarias (ApiService)
- `validateTutorCode()` - Validación de códigos de tutor
- `authenticateWithFirebase()` - Autenticación con Firebase
- `authenticateWithCredentials()` - Autenticación tradicional
- `healthCheck()` - Health check de servicios
- `detailedHealthCheck()` - Health check detallado

### ✅ Pruebas de Widget (SignInScreen)
- **27 pruebas exitosas** que cubren:
  - Renderizado de interfaz (4 pruebas)
  - Interacciones del usuario (3 pruebas)
  - Validación de formulario (3 pruebas)
  - Navegación (2 pruebas)
  - Estructura del widget (3 pruebas)
  - Colores y estilos (2 pruebas)
  - Interacciones complejas (2 pruebas)
  - Accesibilidad (2 pruebas)
  - Validación de entrada (2 pruebas)
  - Estados de botones (2 pruebas)
  - Layout y espaciado (2 pruebas)

### ✅ Casos de Error Probados
- Errores HTTP (400, 401, 500)
- Errores de red (SocketException, ClientException)
- Respuestas vacías
- JSON inválido
- Timeouts
- Validación de formularios
- Estados de UI

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

### Pruebas Unitarias (Patrón AAA)
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

### Pruebas de Widget
```dart
group('Nombre del Grupo', () {
  testWidgets('descripción del test', (WidgetTester tester) async {
    // Arrange - Configurar widget y mocks
    await tester.pumpWidget(createTestWidget());
    
    // Act - Interactuar con el widget
    await tester.enterText(find.byType(TextFormField), 'texto');
    await tester.tap(find.text('Botón'));
    await tester.pump();
    
    // Assert - Verificar el resultado
    expect(find.text('Resultado esperado'), findsOneWidget);
  });
});
```

## Mocking

### Para Pruebas Unitarias
```dart
@GenerateMocks([
  http.Client,
  FlutterSecureStorage,
])
```

### Para Pruebas de Widget
```dart
@GenerateMocks([
  AuthService,
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

### Pruebas Unitarias
1. **Pruebas de Integración**: Agregar pruebas que requieran autenticación real
2. **Pruebas de Performance**: Medir tiempos de respuesta
3. **Pruebas de Edge Cases**: Casos límite y valores extremos
4. **Pruebas de Seguridad**: Validar manejo seguro de tokens
5. **Pruebas de Concurrencia**: Múltiples llamadas simultáneas

### Pruebas de Widget
1. **Pruebas de Integración**: Probar flujos completos de usuario
2. **Pruebas de Performance**: Medir tiempos de renderizado
3. **Pruebas de Accesibilidad**: Verificar soporte completo de accesibilidad
4. **Pruebas de Responsive**: Probar en diferentes tamaños de pantalla
5. **Pruebas de Gestos**: Verificar gestos complejos y animaciones

## Notas Importantes

### Pruebas Unitarias
- Las pruebas están diseñadas para ser independientes y no requieren servicios externos
- Los mocks simulan respuestas HTTP reales
- El timeout configurado es de 30 segundos por defecto
- Las pruebas manejan tanto casos exitosos como casos de error
- Se utiliza inyección de dependencias para facilitar el testing

### Pruebas de Widget
- Las pruebas verifican la interfaz de usuario y las interacciones
- Se utilizan mocks para evitar dependencias externas (Firebase, APIs)
- Las pruebas son rápidas y confiables
- Se cubren casos de éxito y error
- Se verifica accesibilidad y usabilidad

## Resultados Actuales

- **Pruebas Unitarias**: 21 pruebas exitosas (100% de las implementadas)
- **Pruebas de Widget**: 27 pruebas exitosas (100% de las implementadas)
- **Total**: 48 pruebas exitosas

Todas las pruebas pasan exitosamente y proporcionan una base sólida para el testing de la aplicación Psicodemy. 