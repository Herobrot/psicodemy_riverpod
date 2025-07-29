class UserFirebaseEntity {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;

  const UserFirebaseEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isEmailVerified,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFirebaseEntity &&
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
    return 'UserFirebaseEntity(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, isEmailVerified: $isEmailVerified)';
  }
}
