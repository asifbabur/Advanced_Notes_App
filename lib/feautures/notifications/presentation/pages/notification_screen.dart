import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/notifications/presentation/providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  static const pageName = 'notification_screen';
  static const pagePath = '/notification_screen';

  const NotificationScreen({super.key});

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
                      .markAsRead(notification.notificationId);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Accept Invitation"),
                        content: Text(
                          "Do you want to accept this note invitation?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(notificationControllerProvider.notifier)
                                  .acceptInvitation(notification.noteId);

                              ref.invalidate(notesControllerProvider);
                              Navigator.of(context).pop();
                            },
                            child: Text("Accept"),
                          ),
                        ],
                      );
                    },
                  );
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
