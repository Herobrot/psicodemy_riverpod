import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorHandler {
  static void initialize() {
    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    // Handle platform errors
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      print('🚨 Platform Error: $error');
      print('🚨 Stack trace: $stack');
      return true; // Prevent the error from being re-thrown
    };
  }

  static Widget wrapWithErrorHandler(Widget child) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      print('🚨 Widget Error: ${details.exception}');
      print('🚨 Stack trace: ${details.stack}');
      
      return Material(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Algo salió mal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'La aplicación encontró un error inesperado',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    SystemNavigator.pop();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    };
    
    return child;
  }

  static T? safeCall<T>(T Function() function, {T? defaultValue}) {
    try {
      return function();
    } catch (e) {
      print('❌ Safe call error: $e');
      return defaultValue;
    }
  }

  static Future<T?> safeAsyncCall<T>(Future<T> Function() function, {T? defaultValue}) async {
    try {
      return await function();
    } catch (e) {
      print('❌ Safe async call error: $e');
      return defaultValue;
    }
  }

  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    print('❌ Error in $context: $error');
    if (stackTrace != null) {
      print('❌ Stack trace: $stackTrace');
    }
  }
} 