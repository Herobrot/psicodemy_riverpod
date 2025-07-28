import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider para SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

// Provider para verificar si es la primera vez que se abre la app
final isFirstTimeProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    return !(prefs.getBool('has_seen_onboarding') ?? false);
  } catch (e) {
    print('❌ Error checking first time status: $e');
    // Default to showing onboarding if there's an error
    return true;
  }
});

// Provider para marcar que el onboarding ya fue visto
final onboardingRepository = Provider((ref) => OnboardingRepository(ref));

class OnboardingRepository {
  final Ref _ref;
  
  OnboardingRepository(this._ref);
  
  Future<void> markOnboardingAsSeen() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.setBool('has_seen_onboarding', true);
    } catch (e) {
      print('❌ Error marking onboarding as seen: $e');
      // Don't throw - this is not critical
    }
  }
  
  Future<bool> hasSeenOnboarding() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      return prefs.getBool('has_seen_onboarding') ?? false;
    } catch (e) {
      print('❌ Error checking onboarding status: $e');
      // Default to false if there's an error
      return false;
    }
  }
} 