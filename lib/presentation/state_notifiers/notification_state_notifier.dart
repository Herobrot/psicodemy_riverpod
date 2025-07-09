/*import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/services/notification/notification_service.dart';
import '../../domain/repositories/notification_repository_interface.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_state.dart';

part 'notification_state_notifier.g.dart';

/*@riverpod
class NotificationStateNotifier extends _$NotificationStateNotifier {
  @override
  NotificationState build() {
    // Inicializar dependencias usando ref
    final service = ref.watch(notificationServiceProvider);
    final repository = ref.watch(notificationRepositoryProvider);
    
    return const NotificationState();
  }

  Future<void> initializeNotifications() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final service = ref.read(notificationServiceProvider);
      final repository = ref.read(notificationRepositoryProvider);
      
      await service.initializeNotifications();
      
      final hasPermission = await repository.hasPermission();
      final token = await repository.getFCMToken();
      final notifications = await repository.getLocalNotifications();
      
      state = state.copyWith(
        isInitialized: true,
        hasPermission: hasPermission,
        fcmToken: token,
        notifications: notifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> subscribeToTopics(List<String> topics) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final service = ref.read(notificationServiceProvider);
      await service.subscribeToTopics(topics);
      
      final updatedTopics = [...state.subscribedTopics];
      for (final topic in topics) {
        if (!updatedTopics.contains(topic)) {
          updatedTopics.add(topic);
        }
      }
      
      state = state.copyWith(
        subscribedTopics: updatedTopics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> unsubscribeFromTopics(List<String> topics) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final service = ref.read(notificationServiceProvider);
      await service.unsubscribeFromTopics(topics);
      
      final updatedTopics = state.subscribedTopics.where(
        (topic) => !topics.contains(topic),
      ).toList();
      
      state = state.copyWith(
        subscribedTopics: updatedTopics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> saveFCMToken(String userId) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      if (state.fcmToken != null) {
        await repository.saveFCMToken(state.fcmToken!, userId);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refreshNotifications() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final notifications = await repository.getLocalNotifications();
      state = state.copyWith(notifications: notifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void handleForegroundMessage(Map<String, dynamic> message) {
    final service = ref.read(notificationServiceProvider);
    service.handleForegroundMessage(message);
    refreshNotifications();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}*/

@riverpod
class NotificationStateNotifier extends _$NotificationStateNotifier {
  @override
  NotificationState build() {
    _listenToNotificationState();
    return const NotificationState.initial();
  }

  void _listenToNotificationState() {
    final notificationService = ref.watch(notificationServiceProvider);
    _notificationStateSubscription?.cancel();
    _notificationStateSubscription = notificationService.notificationStateChanges.listen((notificationState) {
      state = notificationState;
    });
  }
}*/