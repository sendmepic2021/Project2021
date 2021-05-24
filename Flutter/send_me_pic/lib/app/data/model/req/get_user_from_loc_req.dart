class GetUsersByLocReq{

  final double latitude;
  final double longitude;
  final String searchText;
  final int userID;

  GetUsersByLocReq({this.latitude, this.longitude, this.searchText, this.userID});

  Map<String, String> toJson() => {
    "latitude": latitude.toString(),
    "longitude": longitude.toString(),
    "search_text": searchText,
    "user_id": userID.toString(),
  };
}