
class ResGetCMsPages {
  ResGetCMsPages({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResGetCMsPagesData data;

  factory ResGetCMsPages.fromJson(Map<String, dynamic> json) => ResGetCMsPages(
    status: json["status"],
    message: json["message"],
    data: ResGetCMsPagesData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResGetCMsPagesData {
  ResGetCMsPagesData({
    this.dataDetails,
  });

  String dataDetails;

  factory ResGetCMsPagesData.fromJson(Map<String, dynamic> json) => ResGetCMsPagesData(
    dataDetails: json["data_details"],
  );

  Map<String, dynamic> toJson() => {
    "data_details": dataDetails,
  };
}
