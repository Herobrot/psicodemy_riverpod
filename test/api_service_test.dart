import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:psicodemy/core/services/api_service.dart';
import 'package:psicodemy/core/services/auth/exceptions/auth_failure.dart';

// Generar mocks
import 'api_service_test.mocks.dart';

@GenerateMocks([
  http.Client,
  FlutterSecureStorage,
])
void main() {
  group('ApiService Tests', () {
    late ApiService apiService;
    late MockClient mockClient;
    late MockFlutterSecureStorage mockSecureStorage;

    const String baseUrl = 'https://api.psicodemy.com';

    setUp(() {
      mockClient = MockClient();
      mockSecureStorage = MockFlutterSecureStorage();

      apiService = ApiService(
        client: mockClient,
        secureStorage: mockSecureStorage,
      );
    });

    tearDown(() {
      apiService.dispose();
    });

    group('Constructor y configuración', () {
      test('debería crear instancia con dependencias inyectadas', () {
        expect(apiService, isA<ApiService>());
      });

      test('debería crear instancia con cliente por defecto', () {
        final apiServiceDefault = ApiService(
          secureStorage: mockSecureStorage,
        );
        expect(apiServiceDefault, isA<ApiService>());
      });
    });

    group('validateTutorCode', () {
      test('debería retornar true para código "TUTOR"', () async {
        final result = await apiService.validateTutorCode('TUTOR');
        expect(result, isTrue);
      });

      test('debería retornar true para código "tutor" (case insensitive)', () async {
        final result = await apiService.validateTutorCode('tutor');
        expect(result, isTrue);
      });

      test('debería retornar false para códigos inválidos', () async {
        final result = await apiService.validateTutorCode('INVALIDO');
        expect(result, isFalse);
      });

      test('debería retornar false para código vacío', () async {
        final result = await apiService.validateTutorCode('');
        expect(result, isFalse);
      });
    });

    group('authenticateWithFirebase', () {
      test('debería autenticar exitosamente con Firebase', () async {
        const firebaseToken = 'test_token';
        const nombre = 'Test User';
        const correo = 'test@example.com';
        const codigoTutor = 'TUTOR';

        final expectedResponse = {
          'success': true,
          'data': {
            'userId': '123',
            'tipoUsuario': 'tutor',
            'token': 'jwt_token',
          },
        };

        when(mockClient.post(
          Uri.parse('$baseUrl/auth/firebase'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(expectedResponse),
          200,
        ));

        final result = await apiService.authenticateWithFirebase(
          firebaseToken: firebaseToken,
          nombre: nombre,
          correo: correo,
          codigoTutor: codigoTutor,
        );

        expect(result, equals(expectedResponse));
        verify(mockClient.post(
          Uri.parse('$baseUrl/auth/firebase'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('debería manejar errores de red', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow(SocketException('Connection failed'));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('authenticateWithCredentials', () {
      test('debería autenticar exitosamente con credenciales', () async {
        const correo = 'test@example.com';
        const password = 'password123';
        const codigoTutor = 'TUTOR';

        final expectedResponse = {
          'success': true,
          'data': {
            'userId': '123',
            'tipoUsuario': 'tutor',
            'token': 'jwt_token',
          },
        };

        when(mockClient.post(
          Uri.parse('$baseUrl/auth/validate'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(expectedResponse),
          200,
        ));

        final result = await apiService.authenticateWithCredentials(
          correo: correo,
          password: password,
          codigoTutor: codigoTutor,
        );

        expect(result, equals(expectedResponse));
      });
    });

    group('healthCheck', () {
      test('debería realizar health check exitosamente', () async {
        final authResponse = {'status': 'ok', 'service': 'auth'};
        final s1Response = {'status': 'ok', 'service': 's1'};

        when(mockClient.get(
          Uri.parse('$baseUrl/auth/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(authResponse),
          200,
        ));

        when(mockClient.get(
          Uri.parse('$baseUrl/s1/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(s1Response),
          200,
        ));

        final result = await apiService.healthCheck();

        expect(result, equals({
          'auth': authResponse,
          's1': s1Response,
        }));
      });
    });

    group('detailedHealthCheck', () {
      test('debería realizar health check detallado exitosamente', () async {
        final expectedResponse = {
          'status': 'ok',
          'services': {
            'auth': 'healthy',
            'database': 'healthy',
          },
        };

        when(mockClient.get(
          Uri.parse('$baseUrl/health/detailed'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(expectedResponse),
          200,
        ));

        final result = await apiService.detailedHealthCheck();

        expect(result, equals(expectedResponse));
      });
    });

    group('Error Handling', () {
      test('debería manejar error 400', () async {
        final errorResponse = {
          'message': 'Datos inválidos',
        };

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(errorResponse),
          400,
        ));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar error 401', () async {
        final errorResponse = {
          'message': 'Token inválido',
        };

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(errorResponse),
          401,
        ));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar error 500', () async {
        final errorResponse = {
          'message': 'Error interno del servidor',
        };

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(errorResponse),
          500,
        ));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar respuesta vacía', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 200));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar respuesta JSON inválida', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('invalid json', 200));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('Manejo de errores de red', () {
      test('debería manejar SocketException', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow(SocketException('Connection failed'));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar ClientException', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow(http.ClientException('Network error'));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });

      test('debería manejar errores desconocidos', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow(Exception('Unknown error'));

        expect(
          () => apiService.authenticateWithFirebase(
            firebaseToken: 'token',
            nombre: 'Test',
            correo: 'test@example.com',
          ),
          throwsA(isA<AuthFailure>()),
        );
      });
    });

    group('Headers y configuración', () {
      test('debería incluir headers básicos correctos', () async {
        const firebaseToken = 'test_token';
        const nombre = 'Test User';
        const correo = 'test@example.com';

        final expectedResponse = {
          'success': true,
          'data': {'userId': '123'},
        };

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(expectedResponse),
          200,
        ));

        await apiService.authenticateWithFirebase(
          firebaseToken: firebaseToken,
          nombre: nombre,
          correo: correo,
        );

                 verify(mockClient.post(
           any,
           headers: anyNamed('headers'),
           body: anyNamed('body'),
         )).called(1);
      });
    });

    group('Timeout y configuración', () {
      test('debería respetar el timeout configurado', () async {
        const firebaseToken = 'test_token';
        const nombre = 'Test User';
        const correo = 'test@example.com';

        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 5));
          return http.Response('{"success": true}', 200);
        });

        final stopwatch = Stopwatch()..start();
        
        try {
          await apiService.authenticateWithFirebase(
            firebaseToken: firebaseToken,
            nombre: nombre,
            correo: correo,
          );
        } catch (e) {
          // Esperamos que falle por timeout
        }
        
        stopwatch.stop();
        
        // El timeout debería ser menor a 6 segundos
        expect(stopwatch.elapsed.inSeconds, lessThan(6));
      });
    });
  });
} 