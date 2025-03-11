import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/notifications/data/model/notification.dart';
import 'package:my_notes_flutter/feautures/notifications/data/source/notification_source.dart';
import 'package:my_notes_flutter/feautures/notifications/domain/notification_repo.dart';


// Provider for Notification Repository
final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(FirebaseFirestore.instance),
);

// Provider for Notifications Stream
final notificationStreamProvider =
    StreamProvider<List<Notification>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.fetchNotifications();
});

// Provider for handling Notification Actions
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>(
  (ref) => NotificationController(ref.watch(notificationRepositoryProvider)),
);
