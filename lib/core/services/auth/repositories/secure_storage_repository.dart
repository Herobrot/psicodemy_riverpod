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
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error storing token: $e'));
    }
  }

  @override
  Future<String?> getToken(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error getting token: $e'));
    }
  }

  @override
  Future<void> deleteToken(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error deleting token: $e'));
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error clearing storage: $e'));
    }
  }

  @override
  Future<bool> hasToken(String key) async {
    try {
      final token = await _secureStorage.read(key: key);
      return token != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> storeData(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = json.encode(data);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error storing data: $e'));
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
    } catch (e) {
      throw AuthExceptions.handleGenericException(Exception('Error reading data: $e'));
    }
  }
}

final secureStorageRepositoryProvider = Provider<SecureStorageRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageRepositoryImpl(secureStorage);
});