// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ResUpdateNotification resUpdateNotificationFromJson(String str) => ResUpdateNotification.fromJson(json.decode(str));

String resUpdateNotificationToJson(ResUpdateNotification data) => json.encode(data.toJson());

class ResUpdateNotification {
  ResUpdateNotification({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResUpdateNotificationData data;

  factory ResUpdateNotification.fromJson(Map<String, dynamic> json) => ResUpdateNotification(
    status: json["status"],
    message: json["message"],
    data: ResUpdateNotificationData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResUpdateNotificationData {
  ResUpdateNotificationData({
    this.id,
    this.displayName,
  });

  int id;
  dynamic displayName;

  factory ResUpdateNotificationData.fromJson(Map<String, dynamic> json) => ResUpdateNotificationData(
    id: json["id"],
    displayName: json["display_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_name": displayName,
  };
}
