class ResDeleteImage {
  ResDeleteImage({
    this.status,
    this.message,
  });

  int status;
  String message;

  factory ResDeleteImage.fromJson(Map<String, dynamic> json) => ResDeleteImage(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

