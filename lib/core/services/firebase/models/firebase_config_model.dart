import 'package:firebase_core/firebase_core.dart';

class FirebaseConfigModel {
  final String apiKey;
  final String projectId;
  final String appId;
  final String messagingSenderId;
  final String? authDomain;
  final String? databaseURL;
  final String? storageBucket;
  final String? measurementId;
  final String? trackingId;
  final String? deepLinkURLScheme;
  final String? androidClientId;
  final String? iosClientId;
  final String? iosBundleId;
  final String? appGroupId;

  FirebaseConfigModel({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
    this.measurementId,
    // ios specific
    this.trackingId,
    this.deepLinkURLScheme,
    this.androidClientId,
    this.iosClientId,
    this.iosBundleId,
    this.appGroupId,
  });

  factory FirebaseConfigModel.fromFirebaseOptions(FirebaseOptions options) {
    return FirebaseConfigModel(
      apiKey: options.apiKey,
      appId: options.appId,
      messagingSenderId: options.messagingSenderId,
      projectId: options.projectId,
      authDomain: options.authDomain,
      databaseURL: options.databaseURL,
      storageBucket: options.storageBucket,
      measurementId: options.measurementId,
      trackingId: options.trackingId,
      deepLinkURLScheme: options.deepLinkURLScheme,
      androidClientId: options.androidClientId,
      iosClientId: options.iosClientId,
      iosBundleId: options.iosBundleId,
      appGroupId: options.appGroupId
    );
  }

  factory FirebaseConfigModel.defaultConfig() => FirebaseConfigModel(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
  );
}