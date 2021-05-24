class ReqUpdateUserLocation{
  final int id;
  final double longitude;
  final double latitude;
  final String userAddress;

  ReqUpdateUserLocation(this.id, this.longitude, this.latitude, this.userAddress);


  Map<String, dynamic> toJson() => {
    "id":id.toString(),
    "longitude": longitude.toString(),
    "latitude":latitude.toString(),
    "palace_name":userAddress
  };
}