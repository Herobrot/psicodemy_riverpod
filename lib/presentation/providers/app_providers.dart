import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider para SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

// Provider para verificar si es la primera vez que se abre la app
final isFirstTimeProvider = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  return !(prefs.getBool('has_seen_onboarding') ?? false);
});

// Provider para marcar que el onboarding ya fue visto
final onboardingRepository = Provider((ref) => OnboardingRepository(ref));

class OnboardingRepository {
  final Ref _ref;
  
  OnboardingRepository(this._ref);
  
  Future<void> markOnboardingAsSeen() async {
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.setBool('has_seen_onboarding', true);
  }
  
  Future<bool> hasSeenOnboarding() async {
    final prefs = _ref.read(sharedPreferencesProvider);
    return prefs.getBool('has_seen_onboarding') ?? false;
  }
} 