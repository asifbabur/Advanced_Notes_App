import 'package:my_notes_flutter/feautures/home/data/models/note.dart';

abstract class NotesRepository {
  Future<void> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String noteId);
  Future<void> shareNote(Note note, String email);
  Stream<List<Note>> getNotes();
}
