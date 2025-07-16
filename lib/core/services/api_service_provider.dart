import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'auth/providers/secure_storage_provider.dart';

// Provider simple para ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiService(secureStorage: storage);
}); 