class UpdateProfileReq{
  final int id ;
  final String firstName;
  final String lastName;
  final String mobile;
  final int isProfilePrivate;
  final double latitude;
  final double longitude;
  final String publicName;

  UpdateProfileReq({this.mobile, this.isProfilePrivate, this.firstName, this.lastName, this.latitude, this.longitude, this.id,this.publicName});

  Map<String, String> toJson() => {
    "id":id.toString(),
    "first_name":firstName,
    "last_name":lastName,
    "public_name": publicName,
    "mobile":mobile,
    "latitude":latitude.toString(),
    "longitude":longitude.toString(),
    "is_private_profile":isProfilePrivate.toString(),
  };
}