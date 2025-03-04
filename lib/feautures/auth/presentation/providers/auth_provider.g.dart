// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthDataSourceHash() =>
    r'95a0b0edd77b64b9889b799f7f261a1e504f76b6';

/// See also [firebaseAuthDataSource].
@ProviderFor(firebaseAuthDataSource)
final firebaseAuthDataSourceProvider =
    Provider<FirebaseAuthDataSource>.internal(
      firebaseAuthDataSource,
      name: r'firebaseAuthDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$firebaseAuthDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthDataSourceRef = ProviderRef<FirebaseAuthDataSource>;
String _$authRepositoryHash() => r'e64ef17a8bbc4fbe2e35e4f07b005a70f9f544b5';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepositoryImpl>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepositoryImpl>;
String _$authStateHash() => r'8643f22b63216573dc53d83106782a4e18506dec';

/// Expose the auth state as a stream of UserModel (or null if not signed in)
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<UserModel?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = StreamProviderRef<UserModel?>;
String _$authControllerHash() => r'6efe3153d947b48aca5220aa3ac3365554ff32d6';

/// Controller for performing authentication actions
///
/// Copied from [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>.internal(
      AuthController.new,
      name: r'authControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
