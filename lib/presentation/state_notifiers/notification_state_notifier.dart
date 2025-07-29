import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/notification_providers.dart';
import 'notification_state.dart';

// Provider estándar en lugar de anotación @riverpod
final notificationStateNotifierProvider =
    StateNotifierProvider<NotificationStateNotifier, NotificationState>((ref) {
      final service = ref.watch(notificationServiceProvider);
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationStateNotifier(service, repository);
    });

class NotificationStateNotifier extends StateNotifier<NotificationState> {
  final dynamic _service;
  final dynamic _repository;

  NotificationStateNotifier(this._service, this._repository)
    : super(NotificationState.initial());

  Future<void> initializeNotifications() async {
    try {
      state = NotificationState.loading();

      await _service.initializeNotifications();

      final hasPermission = await _repository.hasPermission();
      final token = await _repository.getFCMToken();
      final notifications = await _repository.getLocalNotifications();

      if (hasPermission) {
        state = NotificationState.permission();
      } else if (token != null) {
        state = NotificationState.token(token);
      } else if (notifications.isNotEmpty) {
        state = NotificationState.notifications(notifications.first);
      } else {
        state = NotificationState.initial();
      }
    } catch (_) {
      state = NotificationState.error('Error al inicializar notificaciones');
    }
  }

  Future<void> subscribeToTopics(List<String> topics) async {
    try {
      state = NotificationState.loading();

      await _service.subscribeToTopics(topics);

      if (topics.isNotEmpty) {
        state = NotificationState.subscribedTopics(topics.first);
      } else {
        state = NotificationState.initial();
      }
    } catch (_) {
      state = NotificationState.error('Error al suscribirse a temas');
    }
  }

  Future<void> unsubscribeFromTopics(List<String> topics) async {
    try {
      state = NotificationState.loading();

      await _service.unsubscribeFromTopics(topics);
      state = NotificationState.initial();
    } catch (_) {
      state = NotificationState.error('Error al desuscribirse de temas');
    }
  }

  Future<void> saveFCMToken(String userId) async {
    try {
      if (state.token != null) {
        await _repository.saveFCMToken(state.token!, userId);
      }
    } catch (_) {
      state = NotificationState.error('Error al guardar token FCM');
    }
  }

  Future<void> refreshNotifications() async {
    try {
      final notifications = await _repository.getLocalNotifications();
      if (notifications.isNotEmpty) {
        state = NotificationState.notifications(notifications.first);
      }
    } catch (_) {
      state = NotificationState.error('Error al actualizar notificaciones');
    }
  }

  void handleForegroundMessage(Map<String, dynamic> message) {
    _service.handleForegroundMessage(message);
    refreshNotifications();
  }

  void clearError() {
    state = NotificationState.initial();
  }
}
