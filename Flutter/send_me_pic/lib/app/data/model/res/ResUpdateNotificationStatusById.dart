class ResUpdateNotificationStatusById {
  ResUpdateNotificationStatusById({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResUpdateNotificationStatusByIdData data;

  factory ResUpdateNotificationStatusById.fromJson(Map<String, dynamic> json) => ResUpdateNotificationStatusById(
    status: json["status"],
    message: json["message"],
    data: ResUpdateNotificationStatusByIdData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResUpdateNotificationStatusByIdData {
  ResUpdateNotificationStatusByIdData({
    this.id,
    this.userId,
    this.notificationId,
    this.isShowNotification,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  int notificationId;
  int isShowNotification;
  DateTime createdAt;
  DateTime updatedAt;

  factory ResUpdateNotificationStatusByIdData.fromJson(Map<String, dynamic> json) => ResUpdateNotificationStatusByIdData(
    id: json["id"],
    userId: json["user_id"],
    notificationId: json["notification_id"],
    isShowNotification: json["is_show_notification"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "notification_id": notificationId,
    "is_show_notification": isShowNotification,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
