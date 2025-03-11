import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/notifications/data/model/notification.dart';
import 'package:my_notes_flutter/feautures/notifications/domain/notification_repo.dart';


class NotificationController extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;

  NotificationController(this._repository) : super(const AsyncValue.data(null));

  // Save a notification
  Future<void> saveNotification(Notification notification) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveNotification(notification);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }
}
