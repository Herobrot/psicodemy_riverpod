/*class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseMessagingDataSource _messagingDataSource;
  final FirestoreDataSource _firestoreDataSource;

  FirebaseRepositoryImpl(
    this._messagingDataSource,
    this._firestoreDataSource,
  );

  @override
  Future<void> initializeFirebase() async {
    await _messagingDataSource.initialize();
  }

  @override
  Future<String?> getToken() async {
    return await _messagingDataSource.getToken();
  }

  @override
  Future<void> saveTokenToFirestore(String token, String userId) async {
    await _firestoreDataSource.saveToken(token, userId);
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _messagingDataSource.subscribeToTopic(topic);
  }

  @override
  Stream<String> onTokenRefresh() {
    return _messagingDataSource.onTokenRefresh();
  }

  @override
  Future<void> requestPermissions() async {
    await _messagingDataSource.requestPermissions();
  }
}*/
