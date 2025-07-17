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
      if (result['data'] == null) {
        throw TutorException.emptyResponse('No se recibieron datos de tutores');
      }
      final tutorListResponse = TutorListResponse.fromJson(result);
      if (!tutorListResponse.isSuccess) {
        throw TutorException.serverError(tutorListResponse.message);
      }
      final tutors = tutorListResponse.tutores;
      _cachedTutors = tutors;
      _cacheTimestamp = DateTime.now();
      return tutors;
    } on SocketException catch (e) {
      print('❌ Error de red en getTutors: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTutors: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } on TutorException catch (e) {
      print('❌ TutorException en getTutors: $e');
      throw e;
    } catch (e) {
      print('❌ Error desconocido en getTutors: $e');
      throw TutorException.unknown(e.toString());
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
    } on TutorException catch (e) {
      print('❌ TutorException en getTutorById: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getTutorById: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTutorById: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getTutorById: $e');
      throw TutorException.unknown(e.toString());
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
    } on TutorException catch (e) {
      print('❌ TutorException en getTutorByEmail: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getTutorByEmail: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTutorByEmail: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getTutorByEmail: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<List<TutorModel>> searchTutorsByName(String name) async {
    try {
      final tutors = await getTutors();
      return tutors.where((tutor) => tutor.nombre.toLowerCase().contains(name.toLowerCase())).toList();
    } on TutorException catch (e) {
      print('❌ TutorException en searchTutorsByName: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en searchTutorsByName: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en searchTutorsByName: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en searchTutorsByName: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<int> getTutorCount() async {
    try {
      final tutors = await getTutors();
      return tutors.length;
    } on TutorException catch (e) {
      print('❌ TutorException en getTutorCount: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getTutorCount: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTutorCount: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getTutorCount: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<bool> isEmailTutor(String email) async {
    try {
      final tutor = await getTutorByEmail(email);
      return tutor != null;
    } on TutorException catch (e) {
      print('❌ TutorException en isEmailTutor: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en isEmailTutor: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en isEmailTutor: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en isEmailTutor: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<List<TutorModel>> getActiveTutors() async {
    try {
      return await getTutors();
    } on TutorException catch (e) {
      print('❌ TutorException en getActiveTutors: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getActiveTutors: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getActiveTutors: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getActiveTutors: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<List<TutorModel>> getTopRatedTutors({int limit = 10}) async {
    try {
      final tutors = await getTutors();
      return tutors.take(limit).toList();
    } on TutorException catch (e) {
      print('❌ TutorException en getTopRatedTutors: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getTopRatedTutors: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTopRatedTutors: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getTopRatedTutors: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<List<TutorModel>> getAvailableTutorsForDate(DateTime fecha) async {
    try {
      return await getTutors();
    } on TutorException catch (e) {
      print('❌ TutorException en getAvailableTutorsForDate: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getAvailableTutorsForDate: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getAvailableTutorsForDate: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getAvailableTutorsForDate: $e');
      throw TutorException.unknown(e.toString());
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
    } on TutorException catch (e) {
      print('❌ TutorException en getTutorStats: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en getTutorStats: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en getTutorStats: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en getTutorStats: $e');
      throw TutorException.unknown(e.toString());
    }
  }

  @override
  Future<void> refreshTutorCache() async {
    try {
      _cachedTutors = null;
      _cacheTimestamp = null;
      await getTutors();
    } on TutorException catch (e) {
      print('❌ TutorException en refreshTutorCache: $e');
      throw e;
    } on SocketException catch (e) {
      print('❌ Error de red en refreshTutorCache: $e');
      throw TutorException.networkError('Sin conexión a internet');
    } on FormatException catch (e) {
      print('❌ Error de parseo en refreshTutorCache: $e');
      throw TutorException.parseError('Error al procesar la respuesta');
    } catch (e) {
      print('❌ Error desconocido en refreshTutorCache: $e');
      throw TutorException.unknown(e.toString());
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