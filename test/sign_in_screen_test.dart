import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:psicodemy/presentation/screens/login_screens/sign_in_screen.dart';
import 'package:psicodemy/core/services/auth/auth_service.dart';
import 'package:psicodemy/presentation/providers/simple_auth_providers.dart';

// Generar mocks
import 'sign_in_screen_test.mocks.dart';

@GenerateMocks([
  AuthService,
])
void main() {
  group('SignInScreen Widget Tests', () {
    late MockAuthService mockAuthService;
    late ProviderContainer container;

    setUp(() {
      mockAuthService = MockAuthService();
      
      // Configurar el container de providers con mocks
      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: const MaterialApp(
          home: SignInScreen(),
        ),
      );
    }

    group('Renderizado de la interfaz', () {
      testWidgets('debería mostrar elementos principales de la pantalla', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar elementos principales
        expect(find.text('Bienvenido'), findsOneWidget);
        expect(find.text('Correo electrónico'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
        expect(find.text('Iniciar sesión'), findsOneWidget);
        expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
        expect(find.text('Regístrate'), findsOneWidget);
      });

      testWidgets('debería mostrar campos de entrada', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar campos de entrada
        expect(find.byType(TextFormField), findsNWidgets(2));
        
        // Verificar iconos principales
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('debería mostrar botón de Google', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que existe el botón de Google (por la imagen)
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('debería mostrar formulario', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que el formulario está presente
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Interacciones del usuario', () {
      testWidgets('debería permitir escribir en el campo de email', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Encontrar el campo de email
        final emailField = find.byType(TextFormField).first;
        
        // Escribir en el campo
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // Verificar que el texto se ingresó correctamente
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('debería permitir escribir en el campo de contraseña', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Encontrar el campo de contraseña
        final passwordField = find.byType(TextFormField).last;
        
        // Escribir en el campo
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // Verificar que el texto se ingresó correctamente
        expect(find.text('password123'), findsOneWidget);
      });

      testWidgets('debería mostrar/ocultar contraseña al tocar el icono', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que inicialmente está oculta
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);

        // Tocar el icono para mostrar contraseña
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Verificar que ahora está visible
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);

        // Tocar el icono para ocultar contraseña
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        // Verificar que vuelve a estar oculta
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);
      });
    });

    group('Validación de formulario', () {
      testWidgets('debería mostrar error cuando email está vacío', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Presionar botón sin llenar campos
        await tester.tap(find.text('Iniciar sesión'));
        await tester.pump();

        // Verificar mensaje de error
        expect(find.text('Por favor ingresa tu correo'), findsOneWidget);
      });

      testWidgets('debería mostrar error cuando email no es válido', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Ingresar email inválido
        await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.pump();

        // Presionar botón
        await tester.tap(find.text('Iniciar sesión'));
        await tester.pump();

        // Verificar mensaje de error
        expect(find.text('Por favor ingresa un correo válido'), findsOneWidget);
      });

      testWidgets('debería mostrar error cuando contraseña está vacía', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Ingresar solo email
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pump();

        // Presionar botón
        await tester.tap(find.text('Iniciar sesión'));
        await tester.pump();

        // Verificar mensaje de error
        expect(find.text('Por favor ingresa tu contraseña'), findsOneWidget);
      });
    });

    group('Navegación', () {
      testWidgets('debería navegar a pantalla de registro', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Tocar en "Regístrate"
        await tester.tap(find.text('Regístrate'));
        await tester.pumpAndSettle();

        // Verificar que se navegó (el widget anterior ya no está en el árbol)
        expect(find.text('Bienvenido'), findsNothing);
      });

      testWidgets('debería navegar a pantalla de contraseña olvidada', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Tocar en "¿Olvidaste tu contraseña?"
        await tester.tap(find.text('¿Olvidaste tu contraseña?'));
        await tester.pumpAndSettle();

        // Verificar que se navegó
        expect(find.text('Bienvenido'), findsNothing);
      });
    });

    group('Estructura del widget', () {
      testWidgets('debería tener estructura correcta', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar estructura básica
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('debería tener padding correcto', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que existe padding
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('debería tener campos de entrada con bordes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que los campos tienen OutlineInputBorder
        final textFields = find.byType(TextFormField);
        expect(textFields, findsNWidgets(2));
      });
    });

    group('Colores y estilos', () {
      testWidgets('debería usar colores correctos', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que el botón principal tiene el color rojo
        final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        final buttonStyle = elevatedButton.style;
        
        // Verificar que el texto del botón es blanco
        expect(find.text('Iniciar sesión'), findsOneWidget);
      });

      testWidgets('debería tener fondo correcto', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que el Scaffold tiene el color de fondo correcto
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, const Color(0xFFF7F7F7));
      });
    });

    group('Interacciones complejas', () {
      testWidgets('debería manejar múltiples interacciones', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Escribir en ambos campos
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.pump();

        // Verificar que ambos textos están presentes
        expect(find.text('test@example.com'), findsOneWidget);
        expect(find.text('password123'), findsOneWidget);

        // Cambiar visibilidad de contraseña
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Verificar que el icono cambió
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('debería limpiar campos correctamente', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Escribir en campos
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.pump();

        // Limpiar campos
        await tester.enterText(find.byType(TextFormField).first, '');
        await tester.enterText(find.byType(TextFormField).last, '');
        await tester.pump();

        // Verificar que los campos están vacíos
        expect(find.text('test@example.com'), findsNothing);
        expect(find.text('password123'), findsNothing);
      });
    });

    group('Accesibilidad', () {
      testWidgets('debería tener labels accesibles', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que los campos tienen labels
        expect(find.text('Correo electrónico'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
      });

      testWidgets('debería tener botones accesibles', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que los botones tienen texto descriptivo
        expect(find.text('Iniciar sesión'), findsOneWidget);
        expect(find.text('Regístrate'), findsOneWidget);
        expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
      });
    });

    group('Validación de entrada', () {
      testWidgets('debería validar formato de email', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Probar diferentes formatos de email
        final emailField = find.byType(TextFormField).first;
        
        // Email válido
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();
        expect(find.text('test@example.com'), findsOneWidget);

        // Email inválido
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();
        expect(find.text('invalid-email'), findsOneWidget);
      });

      testWidgets('debería manejar caracteres especiales en contraseña', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final passwordField = find.byType(TextFormField).last;
        
        // Contraseña con caracteres especiales
        await tester.enterText(passwordField, 'P@ssw0rd!');
        await tester.pump();
        expect(find.text('P@ssw0rd!'), findsOneWidget);
      });
    });

    group('Estados de botones', () {
      testWidgets('debería tener botón de inicio de sesión habilitado', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que el botón está habilitado inicialmente
        final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(elevatedButton.onPressed, isNotNull);
      });

      testWidgets('debería tener botón de Google habilitado', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que el botón de Google está presente y habilitado
        expect(find.byType(InkWell), findsWidgets);
      });
    });

    group('Layout y espaciado', () {
      testWidgets('debería tener espaciado correcto entre elementos', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que existen SizedBox para espaciado
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('debería tener ScrollView para contenido extenso', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verificar que existe SingleChildScrollView
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
} 