// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseNotesDataSourceHash() =>
    r'a17d5c18634dbb553132077c1171674549f17ef8';

/// See also [firebaseNotesDataSource].
@ProviderFor(firebaseNotesDataSource)
final firebaseNotesDataSourceProvider =
    Provider<FirebaseNotesDataSource>.internal(
      firebaseNotesDataSource,
      name: r'firebaseNotesDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$firebaseNotesDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseNotesDataSourceRef = ProviderRef<FirebaseNotesDataSource>;
String _$notesRepositoryHash() => r'81e8a9c432f9fc87be6044142b62e5c1cf95a31b';

/// See also [notesRepository].
@ProviderFor(notesRepository)
final notesRepositoryProvider = Provider<NotesRepositoryImpl>.internal(
  notesRepository,
  name: r'notesRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesRepositoryRef = ProviderRef<NotesRepositoryImpl>;
String _$notesControllerHash() => r'a285c9d760299d3ede0afa02c3361bc134112278';

/// See also [NotesController].
@ProviderFor(NotesController)
final notesControllerProvider =
    AsyncNotifierProvider<NotesController, List<Note>>.internal(
      NotesController.new,
      name: r'notesControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$notesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotesController = AsyncNotifier<List<Note>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
