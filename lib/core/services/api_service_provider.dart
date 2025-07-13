import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

// Provider simple para ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
}); 