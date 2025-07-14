import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/firebase/firebase_messagin_datasource.dart';
import '../../data/datasources/firebase/local_notification_datasource.dart';
import '../../domain/repositories/notification_repository_interface.dart';
import '../../domain/entities/notification_entity.dart';
import '../state_notifiers/notification_state_notifier.dart';
import '../state_notifiers/notification_state.dart';

// Providers for dependencies
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

// Datasource providers
final firebaseMessagingDatasourceProvider = Provider<FirebaseMessagingDatasource>((ref) {
  return FirebaseMessagingDatasourceImpl(
    firebaseMessaging: ref.watch(firebaseMessagingProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final localNotificationDatasourceProvider = Provider<LocalNotificationDatasource>((ref) {
  return LocalNotificationDatasourceImpl(
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

// Repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  // TODO: Implement NotificationRepositoryImpl
  throw UnimplementedError('NotificationRepositoryImpl not implemented');
});

// Service provider
final notificationServiceProvider = Provider<dynamic>((ref) {
  // TODO: Implement NotificationService
  throw UnimplementedError('NotificationService not implemented');
});

// State notifier provider
final notificationStateProvider = StateNotifierProvider<NotificationStateNotifier, NotificationState>((ref) {
  return NotificationStateNotifier(
    ref.watch(notificationServiceProvider),
    ref.watch(notificationRepositoryProvider),
  );
});

// Stream providers for real-time updates
final foregroundMessageProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.onMessageReceived;
});

final messageOpenedAppProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.onMessageOpenedApp;
});

// Provider for local notifications
final localNotificationsProvider = FutureProvider<List<NotificationEntity>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getLocalNotifications();
});