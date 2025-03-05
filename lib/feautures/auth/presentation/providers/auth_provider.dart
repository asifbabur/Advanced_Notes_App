import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/auth/data/repositories/auth_repo_impl.dart';
import 'package:my_notes_flutter/feautures/auth/data/source/auth_data_source.dart';
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
@Riverpod(keepAlive: true) // Keep the auth state alive across app lifecycle
class AuthController extends _$AuthController {
  @override
  Stream<UserModel?> build() {
    final repo = ref.read(authRepositoryProvider);
    return repo.user; // Listen to auth state changes
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final user = await repo.signInWithEmail(email, password);
      state = AsyncValue.data(user); // Update state
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final user = await repo.registerWithEmailPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    try {
      final user = await repo.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncValue.data(null); // Set state to null after sign out
  }
}
