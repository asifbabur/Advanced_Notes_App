import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';

class FirebaseNotesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notesCollection => _firestore.collection('notes');

  Future<void> createNote(String userId, Note note) async {
    await _notesCollection.doc(note.id).set({
      ...note.toJson(),
      'userId': userId,
    });
  }

  Stream<List<Note>> getNotesStream(String userId) {
    return _notesCollection.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
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

  Future<void> shareNoteWithUser(Note note, String userEmail) async {
    try {
      final userCollection = _firestore.collection('users');
      final userDoc =
          await userCollection.where('email', isEqualTo: userEmail).get();

      if (userDoc.docs.isEmpty) {
        throw Exception('User with email $userEmail not found');
      }

      final userId = userDoc.docs.first.id;
      final userNotesCollection = userCollection
          .doc(userId)
          .collection('shared_notes');

      await userNotesCollection.doc(note.id).set(note.toJson());
    } catch (e) {
      log(e.toString());
      // Log the error to Firebase Analytics
      await FirebaseAnalytics.instance.logEvent(
        name: 'share_note_error',
        parameters: {
          'noteId': note.id,
          'userEmail': userEmail,
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }
}
