import '../models/tutor_model.dart';

/// Interfaz para el repositorio de tutores
abstract class TutorRepositoryInterface {
  /// Obtener todos los tutores disponibles
  Future<List<TutorModel>> getTutors();

  /// Obtener un tutor específico por ID
  Future<TutorModel?> getTutorById(String id);

  /// Obtener un tutor específico por email
  Future<TutorModel?> getTutorByEmail(String email);

  /// Buscar tutores por nombre
  Future<List<TutorModel>> searchTutorsByName(String name);

  /// Obtener el total de tutores disponibles
  Future<int> getTutorCount();

  /// Verificar si un email pertenece a un tutor
  Future<bool> isEmailTutor(String email);

  /// Obtener tutores activos (que han tenido citas recientes)
  Future<List<TutorModel>> getActiveTutors();

  /// Obtener tutores con mejor calificación
  Future<List<TutorModel>> getTopRatedTutors({int limit = 10});

  /// Obtener tutores disponibles para una fecha específica
  Future<List<TutorModel>> getAvailableTutorsForDate(DateTime fecha);

  /// Obtener estadísticas de tutores
  Future<Map<String, dynamic>> getTutorStats();

  /// Refrescar la cache de tutores
  Future<void> refreshTutorCache();

  /// Obtener tutores desde cache si está disponible
  Future<List<TutorModel>> getTutorsFromCache();

  /// Verificar si la cache de tutores está actualizada
  bool isCacheValid();
} 