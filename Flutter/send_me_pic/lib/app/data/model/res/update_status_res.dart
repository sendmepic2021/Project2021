import 'dart:convert';

class UpdateStatusRes {
  UpdateStatusRes({
    this.status,
    this.message,
    this.data,
  });

  final int status;
  final String message;
  final UpdateStatusData data;

  factory UpdateStatusRes.fromJson(String str) => UpdateStatusRes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateStatusRes.fromMap(Map<String, dynamic> json) => UpdateStatusRes(
    status: json["status"],
    message: json["message"],
    data: UpdateStatusData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data.toMap(),
  };
}

class UpdateStatusData {
  UpdateStatusData({
    this.imageId,
    this.receiverId,
  });

  final int imageId;
  final int receiverId;

  factory UpdateStatusData.fromJson(String str) => UpdateStatusData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateStatusData.fromMap(Map<String, dynamic> json) => UpdateStatusData(
    imageId: json["image-id"],
    receiverId: json["receiver-id"],
  );

  Map<String, dynamic> toMap() => {
    "image-id": imageId,
    "receiver-id": receiverId,
  };
}
