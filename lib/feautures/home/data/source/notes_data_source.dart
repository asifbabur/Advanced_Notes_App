import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseNotesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notesCollection => _firestore.collection('notes');

  Future<void> createNote(String userId, Note note) async {
    await _notesCollection.doc(note.id).set({
      ...note.toJson(),

      'ownerId': userId,
      'sharedWith': [],
    });
  }

  Stream<List<Note>> getNotesStream(String userId) {
    final ownerNotesStream = _notesCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          log("Owner notes count (listener): ${snapshot.docs.length}");
          return snapshot.docs
              .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
        });

    final sharedNotesStream = _notesCollection
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          log("Shared notes count (listener): ${snapshot.docs.length}");
          return snapshot.docs
              .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
        });

    return Rx.combineLatest2<List<Note>, List<Note>, List<Note>>(
      ownerNotesStream,
      sharedNotesStream,
      (ownerNotes, sharedNotes) {
        final allNotes = [...ownerNotes, ...sharedNotes];
        final uniqueNotes =
            {for (var note in allNotes) note.id: note}.values.toList();
        return uniqueNotes;
      },
    );
  }

  Future<void> updateNote(Note note) async {
    final noteData = note.toJson();
    noteData.remove('ownerId');
    noteData.remove('sharedWith');
    await _notesCollection.doc(note.id).update(noteData);
  }

  Future<void> deleteNote(String noteId) async {
    // Delete the note from the main notes collection
    await _notesCollection.doc(noteId).delete();

    // Find all users who have this note in their shared_notes subcollection
    final userCollection = _firestore.collection('users');
    final usersWithSharedNote =
        await userCollection.where('shared_notes', arrayContains: noteId).get();

    // Delete the note from each user's shared_notes subcollection
    for (var userDoc in usersWithSharedNote.docs) {
      final userId = userDoc.id;
      final userNotesCollection = userCollection
          .doc(userId)
          .collection('shared_notes');
      await userNotesCollection.doc(noteId).delete();
    }
  }

  Future<void> shareNoteWithUser(Note note, String userEmail) async {
    try {
      final userCollection = _firestore.collection('users');

      // Find the user by email
      final userDoc =
          await userCollection.where('email', isEqualTo: userEmail).get();

      if (userDoc.docs.isEmpty) {
        throw Exception('User with email $userEmail not found');
      }

      final userId = userDoc.docs.first.id;

      // Check if the user is already in sharedWith list
      if (note.sharedWith.contains(userId)) {
        log("User already has access to this note");
        return;
      }

      // Update the note's sharedWith array
      await _notesCollection.doc(note.id).update({
        'sharedWith': FieldValue.arrayUnion([userId]),
      });

      log("Note shared successfully with $userEmail ($userId)");
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
