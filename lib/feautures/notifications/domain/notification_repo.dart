import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes_flutter/feautures/notifications/data/model/notification.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository(this._firestore);

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  // Save a notification
  Future<void> saveNotification(Notification notification) async {
    await _firestore
        .collection("users")
        .doc(_userId)
        .collection("notifications")
        .doc(notification.notificationId) // Store ID as the document ID
        .set(notification.toJson());
  }

  // Save Notification when a shared note is added
  Future<void> saveNotificationToFirestore(String noteTitle, String noteId) async {
    final notification = Notification(
      notificationId: _firestore.collection("users").doc().id, // Generate a unique ID
      title: "New Shared Note",
      message: "An invitation has been sent for note: $noteTitle",
      noteId: noteId,
      senderId: FirebaseAuth.instance.currentUser!.uid, // Sender's ID
      timestamp: DateTime.now(),
      isRead: false,
    );

    await saveNotification(notification);
  }

  // Fetch notifications as a stream
  Stream<List<Notification>> fetchNotifications() {
    return _firestore
        .collection("users")
        .doc(_userId)
        .collection("notifications")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notification.fromJson(doc.data()))
            .toList());
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore
        .collection("users")
        .doc(_userId)
        .collection("notifications")
        .doc(notificationId)
        .update({'isRead': true});
  }
}
