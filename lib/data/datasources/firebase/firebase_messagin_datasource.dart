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
    } catch (e) {
      throw Exception('Error getting FCM token: $e');
    }
  }

  @override
  Future<void> saveFCMTokenToFirestore(String token, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error saving FCM token to Firestore: $e');
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      throw Exception('Error subscribing to topic $topic: $e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      throw Exception('Error unsubscribing from topic $topic: $e');
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
    } catch (e) {
      throw Exception('Error requesting permission: $e');
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      throw Exception('Error checking permission: $e');
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
