import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/tutor_repository.dart';
import 'models/tutor_model.dart';

class TutorService {
  final TutorRepository _tutorRepository;

  TutorService(this._tutorRepository);

  Future<List<TutorModel>> getTutors() async {
    return await _tutorRepository.getTutors();
  }

  Future<TutorModel?> getTutorById(String id) async {
    return await _tutorRepository.getTutorById(id);
  }

  Future<TutorModel?> getTutorByEmail(String email) async {
    return await _tutorRepository.getTutorByEmail(email);
  }

  Future<List<TutorModel>> searchTutorsByName(String name) async {
    return await _tutorRepository.searchTutorsByName(name);
  }

  Future<int> getTutorCount() async {
    return await _tutorRepository.getTutorCount();
  }

  Future<bool> isEmailTutor(String email) async {
    return await _tutorRepository.isEmailTutor(email);
  }

  Future<List<TutorModel>> getActiveTutors() async {
    return await _tutorRepository.getActiveTutors();
  }

  Future<List<TutorModel>> getTopRatedTutors({int limit = 10}) async {
    return await _tutorRepository.getTopRatedTutors(limit: limit);
  }

  Future<List<TutorModel>> getAvailableTutorsForDate(DateTime fecha) async {
    return await _tutorRepository.getAvailableTutorsForDate(fecha);
  }

  Future<Map<String, dynamic>> getTutorStats() async {
    return await _tutorRepository.getTutorStats();
  }

  Future<void> refreshTutorCache() async {
    await _tutorRepository.refreshTutorCache();
  }

  Future<List<TutorModel>> getTutorsFromCache() async {
    return await _tutorRepository.getTutorsFromCache();
  }

  bool isCacheValid() {
    return _tutorRepository.isCacheValid();
  }

  void clearCache() {
    _tutorRepository.clearCache();
  }
}

final tutorServiceProvider = Provider<TutorService>((ref) {
  final tutorRepository = ref.watch(tutorRepositoryProvider);
  return TutorService(tutorRepository);
});
