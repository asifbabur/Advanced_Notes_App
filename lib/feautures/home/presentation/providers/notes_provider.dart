import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/data/source/notes_data_source.dart';
import 'package:my_notes_flutter/feautures/home/domain/repositories/notes_repo_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseNotesDataSource firebaseNotesDataSource(Ref ref) {
  return FirebaseNotesDataSource();
}

@Riverpod(keepAlive: true)
NotesRepositoryImpl notesRepository(Ref ref) {
  final dataSource = ref.watch(firebaseNotesDataSourceProvider);
  return NotesRepositoryImpl(dataSource: dataSource);
}

// // Provider to hold the currently selected category (or null for no filter)
// final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// // Provider to compute all distinct categories (tags) from your notes
// final topTagsProvider = Provider<List<String>>((ref) {
//   final notesAsync = ref.watch(notesControllerProvider);

//   return notesAsync.when(
//     data: (notes) {
//       final Map<String, int> tagCount = {};

//       // Count occurrences of each tag
//       for (final note in notes) {
//         for (final tag in note.tags) {
//           tagCount[tag] = (tagCount[tag] ?? 0) + 1;
//         }
//       }

//       // Sort tags by frequency and get the top 5-6
//       final topTags =
//           tagCount.entries.toList()
//             ..sort((a, b) => b.value.compareTo(a.value)); // Descending order

//       return topTags.take(6).map((e) => e.key).toList(); // Return top 6
//     },
//     loading: () => [],
//     error: (_, __) => [],
//   );
// });

// // Provider to compute all distinct categories (tags) from your notes
// final recentNoteProvider = Provider<Note?>((ref) {
//   final notesAsync = ref.watch(notesControllerProvider);

// //   return notesAsync.when(
// //     data: (notes) {
// //       if (notes.isEmpty) return null; // No notes, return null

// //       // Sort notes by timestamp (assuming `createdAt` is a DateTime field)
// //       notes.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

// //       return notes.first; // Most recent note
// //     },
// //     loading: () => null, // While loading, return null
// //     error: (_, __) => null, // If error, return null
// //   );
// // });

// // Provider to filter notes based on the selected category
// final filteredNotesProvider = Provider<List<Note>>((ref) {
//   final notes = ref
//       .watch(notesControllerProvider)
//       .maybeWhen(data: (notes) => notes, orElse: () => <Note>[]);
//   final selectedCategory = ref.watch(selectedCategoryProvider);
//   if (selectedCategory == null) return notes;
//   return notes.where((note) => note.tags.contains(selectedCategory)).toList();
// });

// AsyncNotifier for managing the notes list (fetching, updating state, etc.)
@Riverpod(keepAlive: true)
class NotesController extends _$NotesController {
  @override
  Stream<List<Note>> build() {
    return ref.read(notesRepositoryProvider).getNotes();
  }
  // Method to add a new note
  Future<void> addNote(Note note) async {
    await ref.read(notesRepositoryProvider).createNote(note);
    state = AsyncValue.data(
      await ref.read(notesRepositoryProvider).getNotes().first,
    );
  }

  // Method to update an existing note
  Future<void> updateNote(Note note) async {
    await ref.read(notesRepositoryProvider).updateNote(note);
    state = AsyncValue.data(
      await ref.read(notesRepositoryProvider).getNotes().first,
    );
  }

  // Method to delete a note
  Future<void> deleteNote(String noteId) async {
    await ref.read(notesRepositoryProvider).deleteNote(noteId);
    state = AsyncValue.data(
      await ref.read(notesRepositoryProvider).getNotes().first,
    );
  }

  // Method to delete a note
  Future<void> shareNote(Note note, String email) async {
    await ref.read(notesRepositoryProvider).shareNote(note, email);
    state = AsyncValue.data(
      await ref.read(notesRepositoryProvider).getNotes().first,
    );
  }
}
