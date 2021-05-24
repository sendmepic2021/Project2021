
class ResGetBaseURL {
  ResGetBaseURL({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  ResGetBaseURLData data;

  factory ResGetBaseURL.fromJson(Map<String, dynamic> json) => ResGetBaseURL(
    status: json["status"],
    message: json["message"],
    data: ResGetBaseURLData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ResGetBaseURLData {
  ResGetBaseURLData({
    this.baseUrl,
    this.imageBaseUrl,
  });

  String baseUrl;
  String imageBaseUrl;

  factory ResGetBaseURLData.fromJson(Map<String, dynamic> json) => ResGetBaseURLData(
    baseUrl: json["base_url"],
    imageBaseUrl: json["image_base_url"],
  );

  Map<String, dynamic> toJson() => {
    "base_url": baseUrl,
    "image_base_url": imageBaseUrl,
  };
}
