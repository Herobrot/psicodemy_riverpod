import 'package:firebase_auth/firebase_auth.dart';
import 'complete_user_model.dart';

class FirebaseUserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  const FirebaseUserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    this.createdAt,
    this.lastSignInAt,
  });

  factory FirebaseUserModel.fromFirebaseUser(User user) {
    return FirebaseUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  factory FirebaseUserModel.fromCompleteUser(CompleteUserModel completeUser) {
    return FirebaseUserModel(
      uid: completeUser.firebaseUser.uid,
      email: completeUser.firebaseUser.email,
      displayName: completeUser.firebaseUser.displayName,
      photoURL: completeUser.firebaseUser.photoURL,
      isEmailVerified: completeUser.firebaseUser.emailVerified,
      createdAt: completeUser.firebaseUser.createdAt,
      lastSignInAt: completeUser.firebaseUser.lastSignInAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastSignInAt': lastSignInAt?.millisecondsSinceEpoch,
    };
  }

  factory FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    return FirebaseUserModel(
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
    );
  }

  FirebaseUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return FirebaseUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseUserModel &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.isEmailVerified == isEmailVerified;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        photoURL.hashCode ^
        isEmailVerified.hashCode;
  }

  @override
  String toString() {
    return 'FirebaseUserModel(uid: $uid, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified)';
  }
}
