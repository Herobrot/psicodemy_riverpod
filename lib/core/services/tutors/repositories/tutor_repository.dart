import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tutor_service.dart';
import '../models/tutor_model.dart';
import '../exceptions/tutor_exception.dart';
import 'tutor_repository_interface.dart';
import '../../auth/providers/secure_storage_provider.dart';

/// Implementación del repositorio de tutores
class TutorRepository implements TutorRepositoryInterface {
  final TutorService _tutorService;
  
  // Cache simple para tutores
  List<TutorModel>? _cachedTutors;
  DateTime? _cacheTimestamp;
  static const Duration _cacheExpiration = Duration(minutes: 15);

  TutorRepository(this._tutorService);

  @override
  Future<List<TutorModel>> getTutors() async {
    try {
      // Intentar obtener desde cache primero
      if (isCacheValid()) {
        return _cachedTutors!;
      }

      // Si no hay cache válido, obtener desde servicio
      final tutors = await _tutorService.getTutors();
      
      // Actualizar cache
      _cachedTutors = tutors;
      _cacheTimestamp = DateTime.now();
      
      return tutors;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TutorModel?> getTutorById(String id) async {
    try {
      return await _tutorService.getTutorById(id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TutorModel?> getTutorByEmail(String email) async {
    try {
      return await _tutorService.getTutorByEmail(email);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TutorModel>> searchTutorsByName(String name) async {
    try {
      return await _tutorService.searchTutorsByName(name);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<int> getTutorCount() async {
    try {
      return await _tutorService.getTutorCount();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> isEmailTutor(String email) async {
    try {
      return await _tutorService.isEmailTutor(email);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TutorModel>> getActiveTutors() async {
    try {
      // Para esta implementación, consideramos activos a todos los tutores
      // En el futuro se puede mejorar con datos de actividad real
      return await getTutors();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TutorModel>> getTopRatedTutors({int limit = 10}) async {
    try {
      // Para esta implementación, devolvemos todos los tutores limitados
      // En el futuro se puede implementar con datos de calificación real
      final tutors = await getTutors();
      return tutors.take(limit).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TutorModel>> getAvailableTutorsForDate(DateTime fecha) async {
    try {
      // Para esta implementación, consideramos disponibles a todos los tutores
      // En el futuro se puede cruzar con datos de citas para verificar disponibilidad
      return await getTutors();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getTutorStats() async {
    try {
      final tutors = await getTutors();
      
      return {
        'totalTutors': tutors.length,
        'activeTutors': tutors.length,
        'lastUpdated': DateTime.now().toIso8601String(),
        'cacheValid': isCacheValid(),
        'cacheTimestamp': _cacheTimestamp?.toIso8601String(),
      };
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> refreshTutorCache() async {
    try {
      // Invalidar cache actual
      _cachedTutors = null;
      _cacheTimestamp = null;
      
      // Obtener nuevos datos
      await getTutors();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TutorModel>> getTutorsFromCache() async {
    if (isCacheValid()) {
      return _cachedTutors!;
    } else {
      throw TutorException.emptyResponse('Cache no válido o vacío');
    }
  }

  @override
  bool isCacheValid() {
    if (_cachedTutors == null || _cacheTimestamp == null) {
      return false;
    }
    
    final now = DateTime.now();
    final difference = now.difference(_cacheTimestamp!);
    
    return difference < _cacheExpiration;
  }

  /// Manejo de errores
  TutorException _handleError(dynamic error) {
    if (error is TutorException) {
      return error;
    } else {
      return TutorException.unknown(error.toString());
    }
  }

  /// Limpiar cache
  void clearCache() {
    _cachedTutors = null;
    _cacheTimestamp = null;
  }
}

/// Provider para el repositorio de tutores
final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  final tutorService = ref.watch(tutorServiceProvider);
  return TutorRepository(tutorService);
});

/// Provider para el servicio de tutores
final tutorServiceProvider = Provider<TutorService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TutorService(secureStorage: storage);
}); 