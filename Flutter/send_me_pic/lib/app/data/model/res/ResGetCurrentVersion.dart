
class ResGetCurrentVersion {
  ResGetCurrentVersion({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResGetCurrentVersionData data;

  factory ResGetCurrentVersion.fromJson(Map<String, dynamic> json) => ResGetCurrentVersion(
    status: json["status"],
    message: json["message"],
    data: ResGetCurrentVersionData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResGetCurrentVersionData {
  ResGetCurrentVersionData({
    this.androidAppVersion,
    this.iosAppVersion,
    this.isUndermaintenance,
  });

  String androidAppVersion;
  String iosAppVersion;
  int isUndermaintenance;

  factory ResGetCurrentVersionData.fromJson(Map<String, dynamic> json) => ResGetCurrentVersionData(
    androidAppVersion: json["android_app_version"],
    iosAppVersion: json["ios_app_version"],
    isUndermaintenance: json["is_undermaintenance"],
  );

  Map<String, dynamic> toJson() => {
    "android_app_version": androidAppVersion,
    "ios_app_version": iosAppVersion,
    "is_undermaintenance": isUndermaintenance,
  };
}
