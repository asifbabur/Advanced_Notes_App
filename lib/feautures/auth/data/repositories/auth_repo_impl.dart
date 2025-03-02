import 'package:my_notes_flutter/feautures/auth/data/source/auth_data_source.dart';
import 'package:my_notes_flutter/feautures/auth/domain/repositories/auth_repo.dart';


import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserModel> signInWithEmail(String email, String password) {
    return dataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserModel> signInWithGoogle() {
    return dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Stream<UserModel?> get user {
    // Map Firebase User stream to our UserModel stream
    return dataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
      );
    });
  }
}
