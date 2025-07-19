import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/chat_repository.dart';
import '../../auth/repositories/secure_storage_repository.dart';
import '../../api_service_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final secureStorage = ref.watch(secureStorageRepositoryProvider);
  final apiService = ref.watch(apiServiceProvider);
  
  return ChatRepository(
    secureStorage: secureStorage,
    apiService: apiService,
  );
}); 