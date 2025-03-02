import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/auth/data/repositories/auth_repo_impl.dart';
import 'package:my_notes_flutter/feautures/auth/data/source/auth_data_source.dart';
import 'package:my_notes_flutter/feautures/auth/domain/repositories/auth_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/data/models/user_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthDataSource firebaseAuthDataSource(Ref ref) {
  return FirebaseAuthDataSource();
}

@Riverpod(keepAlive: true)
AuthRepositoryImpl authRepository(Ref ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource: dataSource);
}

/// Expose the auth state as a stream of UserModel (or null if not signed in)
@Riverpod(keepAlive: true)
Stream<UserModel?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).user;
}

/// Controller for performing authentication actions
@Riverpod()
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // No initialization needed for now
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    return await repo.signInWithEmail(email, password);
  }

  Future<UserModel> signInWithGoogle() async {
    final repo = ref.read(authRepositoryProvider);
    return await repo.signInWithGoogle();
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
  }
}
