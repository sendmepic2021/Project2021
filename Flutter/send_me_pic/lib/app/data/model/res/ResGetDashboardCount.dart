
class ResGetDashboardCount {
  ResGetDashboardCount({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResGetDashboardCountData data;

  factory ResGetDashboardCount.fromJson(Map<String, dynamic> json) => ResGetDashboardCount(
    status: json["status"],
    message: json["message"],
    data: ResGetDashboardCountData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResGetDashboardCountData {
  ResGetDashboardCountData({
    this.sendReqCount,
    this.receiveReqCount,
    this.userNotificationCount,
  });

  int sendReqCount;
  int receiveReqCount;
  int userNotificationCount;

  factory ResGetDashboardCountData.fromJson(Map<String, dynamic> json) => ResGetDashboardCountData(
    sendReqCount: json["send_req_count"],
    receiveReqCount: json["receive_req_count"],
    userNotificationCount: json["user_notification_count"],
  );

  Map<String, dynamic> toJson() => {
    "send_req_count": sendReqCount,
    "receive_req_count": receiveReqCount,
    "user_notification_count": userNotificationCount,
  };
}
