
import 'dart:convert';

ResGetNotificationList welcomeFromJson(String str) => ResGetNotificationList.fromJson(json.decode(str));

String welcomeToJson(ResGetNotificationList data) => json.encode(data.toJson());

class ResGetNotificationList {
  ResGetNotificationList({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<NotificationData> data;

  factory ResGetNotificationList.fromJson(Map<String, dynamic> json) => ResGetNotificationList(
    status: json["status"],
    message: json["message"],
    data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    this.id,
    this.notificationType,
    this.notificationTitle,
    this.notificationDescription,
    this.userId,
    this.screenId,
    this.requestId,
    this.createdAt,
    this.updatedAt,
    this.isShowNotification
  });

  int id;
  int notificationType;
  String notificationTitle;
  String notificationDescription;
  int userId;
  int screenId;
  int requestId;
  DateTime createdAt;
  DateTime updatedAt;
  int isShowNotification;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["id"],
    notificationType: json["notification_type"],
    notificationTitle: json["notification_title"],
    notificationDescription: json["notification_description"],
    userId: json["user_id"],
    screenId: json["screen_id"] == null ? null : json["screen_id"],
    requestId: json["request_id"] == null ? null : json["request_id"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
    isShowNotification: json["is_show_notification"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "notification_type": notificationType,
    "notification_title": notificationTitle,
    "notification_description": notificationDescription,
    "user_id": userId,
    "screen_id": screenId == null ? null : screenId,
    "request_id": requestId == null ? null : requestId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_show_notification" : isShowNotification,
  };
}
