import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service.dart';
import '../api_service_provider.dart';
import '../auth/models/user_list_model.dart';

class UserMappingService {
  final ApiService _apiService;
  final Map<String, String> _userNameCache = {};
  bool _isLoading = false;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  UserMappingService(this._apiService);

  // Obtener el nombre de un usuario por su ID
  Future<String> getUserName(String userId) async {    
    
    // Verificar si tenemos el nombre en caché
    if (_userNameCache.containsKey(userId)) {      
      return _userNameCache[userId]!;
    }
    
    // Si no está en caché, cargar todos los usuarios
    await _loadUsersIfNeeded();

    // Buscar el usuario en el caché
    final nombre = _userNameCache[userId] ?? userId;    
    return nombre; // Fallback al ID si no se encuentra
  }

  // Obtener múltiples nombres de usuario
  Future<Map<String, String>> getUserNames(List<String> userIds) async {
    // Filtrar IDs que ya tenemos en caché
    final uncachedIds = userIds.where((id) => !_userNameCache.containsKey(id)).toList();
    
    if (uncachedIds.isNotEmpty) {
      await _loadUsersIfNeeded();
    }

    // Retornar el mapeo de todos los IDs solicitados
    return Map.fromEntries(
      userIds.map((id) => MapEntry(id, _userNameCache[id] ?? id))
    );
  }

  // Cargar usuarios si es necesario
  Future<void> _loadUsersIfNeeded() async {
    // Verificar si necesitamos recargar el caché
    if (_isLoading) {
      // Esperar a que termine la carga actual
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    // Verificar si el caché ha expirado
    if (_lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) > _cacheExpiration) {
      _userNameCache.clear();
    }

    // Si ya tenemos datos y no han expirado, no necesitamos cargar
    if (_userNameCache.isNotEmpty && _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) <= _cacheExpiration) {
      return;
    }

    _isLoading = true;

    try {      
      
      final response = await _apiService.getUsersList(limit: 1000); // Obtener todos los usuarios      
      
      final userListResponse = UserListResponse.fromJson(response);      
      
      // Limpiar caché anterior
      _userNameCache.clear();
      
      // Poblar el caché con los nuevos datos
      for (final user in userListResponse.data.users) {
        _userNameCache[user.id] = user.nombre;        
      }
      
      _lastFetchTime = DateTime.now();
            
      
    } catch (_) {            
      // Si falla, mantener el caché anterior si existe
    } finally {
      _isLoading = false;
    }
  }

  // Limpiar caché manualmente
  void clearCache() {
    _userNameCache.clear();
    _lastFetchTime = null;    
  }

  // Obtener estadísticas del caché
  Map<String, dynamic> getCacheStats() {
    return {
      'cacheSize': _userNameCache.length,
      'lastFetchTime': _lastFetchTime?.toIso8601String(),
      'isLoading': _isLoading,
    };
  }
}

// Provider para UserMappingService
final userMappingServiceProvider = Provider<UserMappingService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserMappingService(apiService);
});

// Provider para obtener un nombre de usuario específico
final userNameProvider = FutureProvider.family<String, String>((ref, userId) async {
  final userMappingService = ref.watch(userMappingServiceProvider);
  return await userMappingService.getUserName(userId);
});

// Provider para obtener múltiples nombres de usuario
final userNamesProvider = FutureProvider.family<Map<String, String>, List<String>>((ref, userIds) async {
  final userMappingService = ref.watch(userMappingServiceProvider);
  return await userMappingService.getUserNames(userIds);
}); 