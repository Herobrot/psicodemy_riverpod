import '../../domain/repositories/notification_repository_interface.dart';

/*part 'notification_repository_impl.g.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  

}

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseMessagingDatasource _firebaseDatasource;
  final LocalNotificationDatasource _localDatasource;

  NotificationRepositoryImpl({
    required FirebaseMessagingDatasource firebaseDatasource,
    required LocalNotificationDatasource localDatasource,
  }) : _firebaseDatasource = firebaseDatasource,
       _localDatasource = localDatasource;

  @override
  Future<String?> getFCMToken() => _firebaseDatasource.getFCMToken();

  @override
  Future<void> saveFCMToken(String token, String userId) => 
      _firebaseDatasource.saveFCMTokenToFirestore(token, userId);

  @override
  Future<void> subscribeToTopic(String topic) => 
      _firebaseDatasource.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) => 
      _firebaseDatasource.unsubscribeFromTopic(topic);

  @override
  Future<void> requestPermission() => 
      _firebaseDatasource.requestPermission();

  @override
  Future<bool> hasPermission() => 
      _firebaseDatasource.hasPermission();

  @override
  Stream<Map<String, dynamic>> get onMessageReceived => 
      _firebaseDatasource.onMessageReceived.map((message) => {
        'notification': message.notification?.toMap(),
        'data': message.data,
      });

  @override
  Stream<Map<String, dynamic>> get onMessageOpenedApp => 
      _firebaseDatasource.onMessageOpenedApp.map((message) => {
        'notification': message.notification?.toMap(),
        'data': message.data,
      });

  @override
  Future<void> saveNotificationToLocal(NotificationEntity notification) async {
    final model = NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      data: notification.data,
      timestamp: notification.timestamp,
      isRead: notification.isRead,
    );
    await _localDatasource.saveNotification(model);
  }

  @override
  Future<List<NotificationEntity>> getLocalNotifications() async {
    final models = await _localDatasource.getNotifications();
    return models.cast<NotificationEntity>();
  }
}*/