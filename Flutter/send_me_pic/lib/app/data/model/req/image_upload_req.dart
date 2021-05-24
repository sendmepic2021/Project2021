class ImageUploadReq{
  final int id;
  final double lat;
  final double lon;
  final String address;

  ImageUploadReq({this.id, this.lon, this.lat, this.address});

  Map<String, String> toJson() => {
    "id": id.toString(),
    "latitude": lat.toString(),
    "longitude": lon.toString(),
    "image_place_name": address
  };
}