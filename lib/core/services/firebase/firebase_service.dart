// class FirebaseService {
//   final FirebaseRepository _repository;
//   static FirebaseService? _instance;

//   FirebaseService._(this._repository);

//   static FirebaseService getInstance(FirebaseRepository repository) {
//     return _instance ??= FirebaseService._(repository);
//   }

//   Future<void> initialize() async {
//     await _repository.initializeFirebase();
//     await _setupTokenListener();
//   }

//   Future<void> _setupTokenListener() async {
//     _repository.onTokenRefresh().listen((token) async {
//       // Guardar nuevo token cuando se actualice
//       final userId = await _getCurrentUserId();
//       if (userId != null) {
//         await _repository.saveTokenToFirestore(token, userId);
//       }
//     });
//   }

//   Future<String?> _getCurrentUserId() async {
//     // Obtener el ID del usuario actual desde el servicio de auth
//     // Implementar según tu lógica de autenticación
//     return null;
//   }
// }
