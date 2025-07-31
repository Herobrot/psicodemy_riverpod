import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tutor_model.dart';
import '../exceptions/tutor_exception.dart';
import 'tutor_repository_interface.dart';
import '../../api_service.dart';
import '../../api_service_provider.dart';

/// Implementación del repositorio de tutores
class TutorRepository implements TutorRepositoryInterface {
  final ApiService _apiService;

  // Cache simple para tutores
  List<TutorModel>? _cachedTutors;
  DateTime? _cacheTimestamp;
  static const Duration _cacheExpiration = Duration(minutes: 15);

  TutorRepository(this._apiService);

  @override
  Future<List<TutorModel>> getTutors() async {
    try {
      if (isCacheValid()) {
        return _cachedTutors!;
      }
      final result = await _apiService.getTutorsFromApi();
      if (result.isEmpty) {
        throw TutorException.emptyResponse('No se recibieron datos de tutores');
      }
      final tutorListResponse = TutorListResponse.fromList(result);
      if (!tutorListResponse.isSuccess) {
        throw TutorException.serverError(tutorListResponse.message);
      }
      final tutors = tutorListResponse.tutores;
      _cachedTutors = tutors;
      _cacheTimestamp = DateTime.now();
      return tutors;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } on TutorException catch (_) {
      rethrow;
    } catch (_) {
      throw TutorException.unknown('Error al obtener los tutores');
    }
  }

  @override
  Future<TutorModel?> getTutorById(String id) async {
    try {
      final tutors = await getTutors();
      try {
        return tutors.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener el tutor por ID');
    }
  }

  @override
  Future<TutorModel?> getTutorByEmail(String email) async {
    try {
      final tutors = await getTutors();
      try {
        return tutors.firstWhere((t) => t.correo == email);
      } catch (_) {
        return null;
      }
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al buscar tutores por nombre');
    }
  }

  @override
  Future<List<TutorModel>> searchTutorsByName(String name) async {
    try {
      final tutors = await getTutors();
      return tutors
          .where(
            (tutor) => tutor.nombre.toLowerCase().contains(name.toLowerCase()),
          )
          .toList();
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener el tutor por email');
    }
  }

  @override
  Future<int> getTutorCount() async {
    try {
      final tutors = await getTutors();
      return tutors.length;
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener el tutor por email');
    }
  }

  @override
  Future<bool> isEmailTutor(String email) async {
    try {
      final tutor = await getTutorByEmail(email);
      return tutor != null;
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener el tutor por email');
    }
  }

  @override
  Future<List<TutorModel>> getActiveTutors() async {
    try {
      return await getTutors();
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener los tutores activos');
    }
  }

  @override
  Future<List<TutorModel>> getTopRatedTutors({int limit = 10}) async {
    try {
      final tutors = await getTutors();
      return tutors.take(limit).toList();
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown(
        'Error al obtener los tutores más calificados',
      );
    }
  }

  @override
  Future<List<TutorModel>> getAvailableTutorsForDate(DateTime fecha) async {
    try {
      return await getTutors();
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown('Error al obtener los tutores disponibles');
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
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown(
        'Error al obtener las estadísticas de los tutores',
      );
    }
  }

  @override
  Future<void> refreshTutorCache() async {
    try {
      _cachedTutors = null;
      _cacheTimestamp = null;
      await getTutors();
    } on TutorException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (_) {
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (_) {
      throw TutorException.unknown(
        'Error al actualizar la caché de los tutores',
      );
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

  void clearCache() {
    _cachedTutors = null;
    _cacheTimestamp = null;
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TutorRepository(apiService);
});
