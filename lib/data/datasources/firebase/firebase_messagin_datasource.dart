import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

abstract class FirebaseMessagingDatasource {
  Future<String?> getFCMToken();
  Future<void> saveFCMTokenToFirestore(String token, String userId);
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> requestPermission();
  Future<bool> hasPermission();
  Stream<RemoteMessage> get onMessageReceived;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Stream<String> get onTokenRefresh;
}

class FirebaseMessagingDatasourceImpl implements FirebaseMessagingDatasource {
  final FirebaseMessaging _firebaseMessaging;
  final FirebaseFirestore _firestore;

  FirebaseMessagingDatasourceImpl({
    required FirebaseMessaging firebaseMessaging,
    required FirebaseFirestore firestore,
  }) : _firebaseMessaging = firebaseMessaging,
       _firestore = firestore;

  @override
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (_) {
      throw Exception('Error getting FCM token');
    }
  }

  @override
  Future<void> saveFCMTokenToFirestore(String token, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      throw Exception('Error saving FCM token to Firestore');
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (_) {
      throw Exception('Error suscribiendose al topico');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (_) {
      throw Exception('Error desuscribiendose del topico');
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (_) {
      throw Exception('Error requesting permission');
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (_) {
      throw Exception('Error checking permission');
    }
  }

  @override
  Stream<RemoteMessage> get onMessageReceived => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;
}
