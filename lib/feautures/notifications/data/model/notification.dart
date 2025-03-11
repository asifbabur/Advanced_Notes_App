import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String notificationId,
    required String title,
    required String message,
    required String noteId,
    required String senderId,
    @Default(false) bool isRead,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) 
    required DateTime timestamp,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}

// Helper functions for Firestore timestamp conversion
DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is int) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  }
  return DateTime.now();
}

int _timestampToJson(DateTime timestamp) => timestamp.millisecondsSinceEpoch;
