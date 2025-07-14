import '../../../types/tipo_usuario.dart';
import 'firebase_auth_response.dart';
import 'user_model.dart';

class CompleteUserModel {
  final String uid; // UID de Firebase
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;
  
  // Datos de la API
  final String? userId; // ID del usuario en la API
  final String? nombre;
  final TipoUsuario? tipoUsuario;
  final String? apiToken;
  final DateTime? apiCreatedAt;
  final DateTime? apiUpdatedAt;

  // Referencias a los modelos originales
  final UserModel firebaseUser;
  final dynamic apiUser;

  const CompleteUserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    this.createdAt,
    this.lastSignInAt,
    this.userId,
    this.nombre,
    this.tipoUsuario,
    this.apiToken,
    this.apiCreatedAt,
    this.apiUpdatedAt,
    required this.firebaseUser,
    this.apiUser,
  });

  // Constructor desde Firebase User
  factory CompleteUserModel.fromFirebaseUser(UserModel firebaseUser) {
    return CompleteUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.createdAt,
      lastSignInAt: firebaseUser.lastSignInAt,
      firebaseUser: firebaseUser,
    );
  }

  // Constructor desde respuesta de API Firebase
  factory CompleteUserModel.fromFirebaseAuthResponse(
    UserModel firebaseUser,
    FirebaseAuthResponse apiResponse,
  ) {
    return CompleteUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.createdAt,
      lastSignInAt: firebaseUser.lastSignInAt,
      userId: apiResponse.data.userId,
      nombre: apiResponse.data.nombre,
      tipoUsuario: apiResponse.data.tipoUsuario, // Usando el getter que convierte string a enum
      apiToken: apiResponse.data.token,
      apiCreatedAt: null, // No disponible en la respuesta actual
      apiUpdatedAt: null, // No disponible en la respuesta actual
      firebaseUser: firebaseUser,
      apiUser: ApiUser.fromApiResponseData(apiResponse.data), // Creando ApiUser desde los datos
    );
  }

  // Copiar con nuevos valores
  CompleteUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    String? userId,
    String? nombre,
    TipoUsuario? tipoUsuario,
    String? apiToken,
    DateTime? apiCreatedAt,
    DateTime? apiUpdatedAt,
    UserModel? firebaseUser,
    dynamic apiUser,
  }) {
    return CompleteUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      apiToken: apiToken ?? this.apiToken,
      apiCreatedAt: apiCreatedAt ?? this.apiCreatedAt,
      apiUpdatedAt: apiUpdatedAt ?? this.apiUpdatedAt,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      apiUser: apiUser ?? this.apiUser,
    );
  }

  // Verificar si el usuario tiene datos de la API
  bool get hasApiData => userId != null && tipoUsuario != null;

  // Verificar si el usuario es tutor
  bool get isTutor => tipoUsuario == TipoUsuario.tutor;

  // Verificar si el usuario es alumno
  bool get isAlumno => tipoUsuario == TipoUsuario.alumno;

  // Obtener el nombre a mostrar
  String get displayNameOrEmail => 
    nombre ?? displayName ?? email.split('@')[0];

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastSignInAt': lastSignInAt?.millisecondsSinceEpoch,
      'userId': userId,
      'nombre': nombre,
      'tipoUsuario': tipoUsuario?.name,
      'apiToken': apiToken,
      'apiCreatedAt': apiCreatedAt?.toIso8601String(),
      'apiUpdatedAt': apiUpdatedAt?.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory CompleteUserModel.fromJson(Map<String, dynamic> json) {
    // Crear un UserModel temporal desde los datos básicos
    final firebaseUser = UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['isEmailVerified'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      lastSignInAt: json['lastSignInAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSignInAt'] as int)
          : null,
    );
    
    return CompleteUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      lastSignInAt: json['lastSignInAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSignInAt'] as int)
          : null,
      userId: json['userId'] as String?,
      nombre: json['nombre'] as String?,
      tipoUsuario: json['tipoUsuario'] != null
          ? TipoUsuario.values.firstWhere(
              (e) => e.name == json['tipoUsuario'],
              orElse: () => TipoUsuario.alumno,
            )
          : null,
      apiToken: json['apiToken'] as String?,
      apiCreatedAt: json['apiCreatedAt'] != null
          ? DateTime.parse(json['apiCreatedAt'] as String)
          : null,
      apiUpdatedAt: json['apiUpdatedAt'] != null
          ? DateTime.parse(json['apiUpdatedAt'] as String)
          : null,
      firebaseUser: firebaseUser,
    );
  }

  // Constructor específico para respuesta de API del backend
  factory CompleteUserModel.fromApiResponse(Map<String, dynamic> apiData, UserModel firebaseUser) {
    return CompleteUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.createdAt,
      lastSignInAt: firebaseUser.lastSignInAt,
      userId: apiData['userId']?.toString(),
      nombre: apiData['nombre']?.toString(),
      tipoUsuario: _parseUserType(apiData['userType']),
      apiToken: apiData['token']?.toString(),
      apiCreatedAt: null,
      apiUpdatedAt: null,
      firebaseUser: firebaseUser,
      apiUser: apiData,
    );
  }

  // Método auxiliar para parsear el tipo de usuario
  static TipoUsuario _parseUserType(dynamic userType) {
    if (userType == null) return TipoUsuario.alumno;
    
    switch (userType.toString().toLowerCase()) {
      case 'tutor':
        return TipoUsuario.tutor;
      case 'alumno':
      default:
        return TipoUsuario.alumno;
    }
  }

  @override
  String toString() {
    return 'CompleteUserModel(uid: $uid, email: $email, displayName: $displayName, '
           'userId: $userId, nombre: $nombre, tipoUsuario: $tipoUsuario, '
           'hasApiData: $hasApiData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CompleteUserModel &&
      other.uid == uid &&
      other.email == email &&
      other.displayName == displayName &&
      other.photoURL == photoURL &&
      other.isEmailVerified == isEmailVerified &&
      other.userId == userId &&
      other.nombre == nombre &&
      other.tipoUsuario == tipoUsuario &&
      other.apiToken == apiToken;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      isEmailVerified.hashCode ^
      userId.hashCode ^
      nombre.hashCode ^
      tipoUsuario.hashCode ^
      apiToken.hashCode;
  }
} 