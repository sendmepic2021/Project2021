class LoginReq{
  final String socialID;
  final String fcmID;
  final int loginType;
  final int deviceType;
  final String email;
  final String userProfileImage;
  final String firstName;
  final String lastName;

  LoginReq({this.socialID, this.fcmID, this.loginType, this.deviceType, this.email, this.userProfileImage, this.firstName, this.lastName,});

  Map<String, dynamic> toJson() => {
    "social_id": socialID,
    "fcm_id": fcmID,
    "login_type": loginType.toString(),
    "device_type": deviceType.toString(),
    "email": email,
    "user_profile_image": userProfileImage,
    "first_name": firstName,
    "last_name": lastName,
  };
}