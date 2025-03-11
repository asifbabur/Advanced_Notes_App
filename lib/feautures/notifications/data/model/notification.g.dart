// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      notificationId: json['notificationId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      noteId: json['noteId'] as String,
      senderId: json['senderId'] as String,
      isRead: json['isRead'] as bool? ?? false,
      timestamp: _timestampFromJson(json['timestamp']),
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title,
      'message': instance.message,
      'noteId': instance.noteId,
      'senderId': instance.senderId,
      'isRead': instance.isRead,
      'timestamp': _timestampToJson(instance.timestamp),
    };
