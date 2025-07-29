import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tutor_model.dart';
import '../exceptions/tutor_exception.dart';
import '../repositories/tutor_repository.dart';

/// Estado para la lista de tutores
@immutable
class TutorListState {
  final List<TutorModel> tutors;
  final bool isLoading;
  final TutorException? error;
  final bool hasCache;
  final DateTime? lastUpdated;

  const TutorListState({
    this.tutors = const [],
    this.isLoading = false,
    this.error,
    this.hasCache = false,
    this.lastUpdated,
  });

  TutorListState copyWith({
    List<TutorModel>? tutors,
    bool? isLoading,
    TutorException? error,
    bool? hasCache,
    DateTime? lastUpdated,
  }) {
    return TutorListState(
      tutors: tutors ?? this.tutors,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasCache: hasCache ?? this.hasCache,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TutorListState &&
        other.tutors == tutors &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.hasCache == hasCache &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return tutors.hashCode ^
        isLoading.hashCode ^
        error.hashCode ^
        hasCache.hashCode ^
        lastUpdated.hashCode;
  }
}

/// Notificador para la lista de tutores
class TutorListNotifier extends StateNotifier<TutorListState> {
  final TutorRepository _repository;

  TutorListNotifier(this._repository) : super(const TutorListState());

  /// Cargar tutores (con cache)
  Future<void> loadTutors({bool forceRefresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      List<TutorModel> tutors;

      if (forceRefresh || !_repository.isCacheValid()) {
        tutors = await _repository.getTutors();
      } else {
        tutors = await _repository.getTutorsFromCache();
      }

      state = state.copyWith(
        tutors: tutors,
        isLoading: false,
        hasCache: _repository.isCacheValid(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is TutorException ? e : TutorException.unknown(e.toString()),
      );
    }
  }

  /// Refrescar tutores (forzar actualización)
  Future<void> refreshTutors() async {
    await loadTutors(forceRefresh: true);
  }

  /// Buscar tutores por nombre
  Future<void> searchTutors(String name) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final tutors = await _repository.searchTutorsByName(name);

      state = state.copyWith(
        tutors: tutors,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is TutorException ? e : TutorException.unknown(e.toString()),
      );
    }
  }

  /// Limpiar estado
  void clear() {
    state = const TutorListState();
  }

  /// Actualizar un tutor en la lista
  void updateTutorInList(TutorModel updatedTutor) {
    final tutors = state.tutors.map((tutor) {
      return tutor.id == updatedTutor.id ? updatedTutor : tutor;
    }).toList();

    state = state.copyWith(tutors: tutors);
  }

  /// Obtener tutor por ID desde la lista actual
  TutorModel? getTutorByIdFromList(String id) {
    try {
      return state.tutors.firstWhere((tutor) => tutor.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtener tutor por email desde la lista actual
  TutorModel? getTutorByEmailFromList(String email) {
    try {
      return state.tutors.firstWhere((tutor) => tutor.correo == email);
    } catch (e) {
      return null;
    }
  }

  /// Verificar si un ID está en la lista de tutores
  bool isIdInTutorList(String id) {
    return state.tutors.any((tutor) => tutor.id == id);
  }

  /// Verificar si un email está en la lista de tutores
  bool isEmailInTutorList(String email) {
    return state.tutors.any((tutor) => tutor.correo == email);
  }
}

/// Provider para la lista de tutores
final tutorListProvider =
    StateNotifierProvider<TutorListNotifier, TutorListState>((ref) {
      final repository = ref.watch(tutorRepositoryProvider);
      return TutorListNotifier(repository);
    });

/// Provider para obtener todos los tutores
final tutorsProvider = FutureProvider<List<TutorModel>>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutors();
});

/// Provider para obtener un tutor por ID
final tutorByIdProvider = FutureProvider.family<TutorModel?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutorById(id);
});

/// Provider para obtener un tutor por email
final tutorByEmailProvider = FutureProvider.family<TutorModel?, String>((
  ref,
  email,
) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutorByEmail(email);
});

/// Provider para buscar tutores por nombre
final searchTutorsProvider = FutureProvider.family<List<TutorModel>, String>((
  ref,
  name,
) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.searchTutorsByName(name);
});

/// Provider para obtener el total de tutores
final tutorCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutorCount();
});

/// Provider para verificar si un email es de tutor
final isEmailTutorProvider = FutureProvider.family<bool, String>((
  ref,
  email,
) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.isEmailTutor(email);
});

/// Provider para obtener tutores activos
final activeTutorsProvider = FutureProvider<List<TutorModel>>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getActiveTutors();
});

/// Provider para obtener tutores mejor calificados
final topRatedTutorsProvider = FutureProvider.family<List<TutorModel>, int>((
  ref,
  limit,
) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTopRatedTutors(limit: limit);
});

/// Provider para obtener tutores disponibles para una fecha
final availableTutorsForDateProvider =
    FutureProvider.family<List<TutorModel>, DateTime>((ref, fecha) async {
      final repository = ref.watch(tutorRepositoryProvider);
      return await repository.getAvailableTutorsForDate(fecha);
    });

/// Provider para estadísticas de tutores
final tutorStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutorStats();
});

/// Provider para refrescar cache de tutores
final refreshTutorCacheProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  await repository.refreshTutorCache();
});

/// Provider para verificar si la cache es válida
final isCacheValidProvider = Provider<bool>((ref) {
  final repository = ref.watch(tutorRepositoryProvider);
  return repository.isCacheValid();
});

/// Provider para obtener tutores desde cache
final tutorsFromCacheProvider = FutureProvider<List<TutorModel>>((ref) async {
  final repository = ref.watch(tutorRepositoryProvider);
  return await repository.getTutorsFromCache();
});

/// Provider para obtener un tutor específico con información extendida
final tutorDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, email) async {
      final repository = ref.watch(tutorRepositoryProvider);
      final tutor = await repository.getTutorByEmail(email);

      if (tutor == null) {
        throw TutorException.notFound('Tutor no encontrado');
      }

      // Aquí se puede extender con más información del tutor
      return {
        'tutor': tutor,
        'isActive': true, // Placeholder
        'rating': 4.5, // Placeholder
        'totalAppointments': 0, // Placeholder
        'completedAppointments': 0, // Placeholder
        'lastActivity': DateTime.now().toIso8601String(),
      };
    });

/// Provider para filtrar tutores por criterios
final filteredTutorsProvider =
    FutureProvider.family<List<TutorModel>, Map<String, dynamic>>((
      ref,
      filters,
    ) async {
      final repository = ref.watch(tutorRepositoryProvider);
      List<TutorModel> tutors = await repository.getTutors();

      // Aplicar filtros
      if (filters['name'] != null && filters['name'].isNotEmpty) {
        final name = filters['name'].toString().toLowerCase();
        tutors = tutors
            .where((tutor) => tutor.nombre.toLowerCase().contains(name))
            .toList();
      }

      if (filters['email'] != null && filters['email'].isNotEmpty) {
        final email = filters['email'].toString().toLowerCase();
        tutors = tutors
            .where((tutor) => tutor.correo.toLowerCase().contains(email))
            .toList();
      }

      if (filters['available'] == true) {
        // Filtrar solo tutores disponibles (placeholder)
        tutors = tutors; // Por ahora todos están disponibles
      }

      return tutors;
    });

/// Provider para obtener sugerencias de tutores
final tutorSuggestionsProvider =
    FutureProvider.family<List<TutorModel>, String>((ref, query) async {
      final repository = ref.watch(tutorRepositoryProvider);

      if (query.isEmpty) {
        return await repository.getTopRatedTutors(limit: 5);
      }

      final tutors = await repository.searchTutorsByName(query);
      return tutors.take(5).toList();
    });
