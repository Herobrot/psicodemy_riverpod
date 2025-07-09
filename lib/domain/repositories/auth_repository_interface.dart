import '../entities/user_firebase_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepositoryInterface {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserFirebaseEntity> signUpWithEmailAndPassword(String email, String password);
  Future<UserFirebaseEntity> signInWithGoogle();
  Future<void> signOut();
  Future<UserFirebaseEntity?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Stream<UserFirebaseEntity?> get authStateChanges;
}