import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/secure_storage_provider.dart';
import '../exceptions/auth_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// part 'secure_storage_repository.g.dart';

abstract class SecureStorageRepository {
  Future<void> storeToken(String key, String token);
  Future<String?> getToken(String key);
  Future<void> deleteToken(String key);
  Future<void> clearAll();
  Future<bool> hasToken(String key);
  Future<void> storeData(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> read(String key);
}

class SecureStorageRepositoryImpl implements SecureStorageRepository {
  final FlutterSecureStorage _secureStorage;

  SecureStorageRepositoryImpl(this._secureStorage);

  @override
  Future<void> storeToken(String key, String token) async {
    try {
      await _secureStorage.write(key: key, value: token);
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error storing token'),
      );
    }
  }

  @override
  Future<String?> getToken(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error getting token'),
      );
    }
  }

  @override
  Future<void> deleteToken(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error deleting token'),
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error clearing storage'),
      );
    }
  }

  @override
  Future<bool> hasToken(String key) async {
    try {
      final token = await _secureStorage.read(key: key);
      return token != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> storeData(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = json.encode(data);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error storing data'),
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> read(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      throw AuthExceptions.handleGenericException(
        Exception('Error reading data'),
      );
    }
  }
}

final secureStorageRepositoryProvider = Provider<SecureStorageRepository>((
  ref,
) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageRepositoryImpl(secureStorage);
});
