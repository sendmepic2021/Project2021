class ReqUpdateNotificationStatusById{
  final int userId ;
  final int notificationId;
  ReqUpdateNotificationStatusById({this.userId, this.notificationId});

  Map<String, dynamic> toJson() => {
    "user_id": userId.toString(),
    "notification_id": notificationId.toString()
  };
}