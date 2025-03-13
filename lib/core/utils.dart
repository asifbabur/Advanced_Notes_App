import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:my_notes_flutter/feautures/notifications/presentation/providers/notification_provider.dart';

class Notifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Notifications();

  void setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message.notification?.title ?? "New Shared Note");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle navigation when the user taps on the notification
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Notification permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }
  }

  void showLocalNotification(String noteTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'shared_notes_channel',
          'Shared Notes',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      "New Shared Note",
      "An invitation has been sent to you for note: $noteTitle",
      platformChannelSpecifics,
    );
  }

  Future<void> sendPushNotification(String noteTitle) async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    final fcmToken = userDoc.data()?['fcmToken'];

    if (fcmToken == null) return;

    final url = "https://fcm.googleapis.com/fcm/send";
    final headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key=YOUR_SERVER_KEY", // Replace with your FCM server key
    };

    final body = jsonEncode({
      "to": fcmToken,
      "notification": {
        "title": "New Shared Note",
        "body": "An invitation has been sent to you for note: $noteTitle",
      },
    });

    await http.post(Uri.parse(url), headers: headers, body: body);
  }

  void listenToSharedNotes(WidgetRef ref) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("shared_notes")
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final noteTitle = change.doc["title"] ?? "Untitled Note";
              final noteId = change.doc.id;

           
              showLocalNotification(noteTitle);
              sendPushNotification(noteTitle);
            }
          }
        });
  }

  /// ✅ Background Notification Handler
  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    showLocalNotification(message.notification?.title ?? "New Shared Note");

    print("Handling a background message: ${message.messageId}");
  }
}
