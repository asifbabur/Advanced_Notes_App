import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/data/source/notes_data_source.dart';

import 'notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final FirebaseNotesDataSource dataSource;

  NotesRepositoryImpl({required this.dataSource});

  @override
  Future<void> createNote(Note note) async {
    await dataSource.createNote(note);
  }

  @override
  Stream<List<Note>> getNotes() {
    return dataSource.getNotesStream();
  }

  @override
  Future<void> updateNote(Note note) async {
    await dataSource.updateNote(note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await dataSource.deleteNote(noteId);
  }
}
