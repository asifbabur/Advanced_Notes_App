import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> registerWithEmailPassword(String email, String password);
  Future<void> signOut();
  Stream<UserModel?> get user;
}
