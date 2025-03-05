import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';

class FirebaseNotesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notesCollection =>
      _firestore.collection('notes');

  Future<void> createNote(Note note) async {
    await _notesCollection.doc(note.id).set(note.toJson());
  }

  Stream<List<Note>> getNotesStream() {
    return _notesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toJson());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }
}
