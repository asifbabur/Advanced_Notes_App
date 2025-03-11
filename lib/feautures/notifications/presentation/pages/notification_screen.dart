import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/notifications/presentation/providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  static const pageName = 'notification_screen';
  static const pagePath = '/notification_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: notifications.when(
        data: (notificationList) {
          if (notificationList.isEmpty) {
            return Center(child: Text("No notifications"));
          }
          return ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notification = notificationList[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing:
                    notification.isRead
                        ? Icon(Icons.done, color: Colors.green)
                        : Icon(Icons.notifications, color: Colors.blue),
                onTap: () {
                  ref
                      .read(notificationControllerProvider.notifier)
                      .markAsRead(notification.noteId);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error:
            (error, stack) =>
                Center(child: Text("Error loading notifications")),
      ),
    );
  }
}
