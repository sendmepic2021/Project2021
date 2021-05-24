import 'dart:convert';

import 'package:send_me_pic/app/model/emuns.dart';

ResDashboardLatLong welcomeFromJson(String str) => ResDashboardLatLong.fromJson(json.decode(str));

String welcomeToJson(ResDashboardLatLong data) => json.encode(data.toJson());

class ResDashboardLatLong {
  ResDashboardLatLong({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  Data data;

  factory ResDashboardLatLong.fromJson(Map<String, dynamic> json){
    if(json["data"] != null){
      return ResDashboardLatLong(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
    }else{
      return ResDashboardLatLong(
        status: json["status"],
        message: json["message"]
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.userList,
    this.imageGroup,
  });

  List<UserList> userList;
  List<List<ImageGroup>> imageGroup;

  factory Data.fromJson(Map<String, dynamic> json) {
    if(json["user_list"] != null && json["image_group"] != null){
      return Data(
        userList: List<UserList>.from(json["user_list"].map((x) => UserList.fromJson(x))),
        imageGroup: List<List<ImageGroup>>.from(json["image_group"].map((x) => List<ImageGroup>.from(x.map((x) => ImageGroup.fromJson(x))))),
      );
    }else{
      return Data();
    }
  }

  Map<String, dynamic> toJson() => {
    "user_list": List<dynamic>.from(userList.map((x) => x.toJson())),
    "image_group": List<dynamic>.from(imageGroup.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class ImageGroup {
  ImageGroup({
    this.id,
    this.title,
    this.description,
    this.senderId,
    this.receiverId,
    this.image,
    this.isActive,
    this.isReceiver,
    this.latitude,
    this.longitude,
    this.imagePlaceName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.senderUserData,
    this.reciveUserData,
    this.latlong,
    this.palaceName,
  });

  int id;
  String title;
  String description;
  int senderId;
  int receiverId;
  String image;
  int isActive;
  int isReceiver;
  String latitude;
  String longitude;
  String imagePlaceName;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  double distance;
  UserList senderUserData;
  UserList reciveUserData;
  String latlong;
  String palaceName;

  factory ImageGroup.fromJson(Map<String, dynamic> json) => ImageGroup(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    image: json["image"],
    isActive: json["is_active"],
    isReceiver: json["is_receiver"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    imagePlaceName: json["image_place_name"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]).toLocal(),
    distance: json["distance"].toDouble(),
    senderUserData: UserList.fromJson(json["sender_user_data"]),
    reciveUserData: UserList.fromJson(json["recive_user_data"]),
    latlong: json["latlong"],
    palaceName: json["palace_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "image": image,
    "is_active": isActive,
    "is_receiver": isReceiver,
    "latitude": latitude,
    "longitude": longitude,
    "image_place_name": imagePlaceName,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "distance": distance,
    "sender_user_data": senderUserData.toJson(),
    "recive_user_data": reciveUserData.toJson(),
    "latlong": latlong,
    "palace_name": palaceName,
  };
}

class UserList {
  UserList({
    this.id,
    this.displayName,
    this.firstName,
    this.lastName,
    this.userProfileImage,
    this.email,
    this.mobile,
    this.fcmId,
    this.deviceType,
    this.socialId,
    this.isActive,
    this.token,
    this.userType,
    this.loginType,
    this.packageId,
    this.latitude,
    this.longitude,
    this.levelId,
    this.isNotification,
    this.isPrivateProfile,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.palaceName,
    this.publicName,
    this.level_id,

  });

  int id;
  String displayName;
  String firstName;
  String lastName;
  String userProfileImage;
  String email;
  String mobile;
  String fcmId;
  String deviceType;
  String socialId;
  int isActive;
  String token;
  int userType;
  int loginType;
  int packageId;
  String latitude;
  String longitude;
  int levelId;
  int isNotification;
  int isPrivateProfile;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  double distance;
  String palaceName;
  String publicName;
  int level_id;

  UserBadge get badge => UserStatus.getBadgeStatus(level_id);

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    id: json["id"],
    displayName: json["display_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userProfileImage: json["user_profile_image"],
    email: json["email"] == null ? null : json["email"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    fcmId: json["fcm_id"] == null ? null : json["fcm_id"],
    deviceType: json["device_type"],
    socialId: json["social_id"],
    isActive: json["is_active"],
    token: json["token"] == null ? null : json["token"],
    userType: json["user_type"],
    loginType: json["login_type"],
    packageId: json["package_id"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"],
    levelId: json["level_id"],
    isNotification: json["is_notification"],
    isPrivateProfile: json["is_private_profile"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
    distance: json["distance"] == null ? null : json["distance"].toDouble(),
    palaceName: json["palace_name"],
    publicName: json["public_name"],
    level_id: json["level_id"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_name": displayName,
    "first_name": firstName,
    "last_name": lastName,
    "user_profile_image": userProfileImage,
    "email": email == null ? null : email,
    "mobile": mobile == null ? null : mobile,
    "fcm_id": fcmId == null ? null : fcmId,
    "device_type": deviceType,
    "social_id": socialId,
    "is_active": isActive,
    "token": token == null ? null : token,
    "user_type": userType,
    "login_type": loginType,
    "package_id": packageId,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude,
    "level_id": levelId,
    "is_notification": isNotification,
    "is_private_profile": isPrivateProfile,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "distance": distance == null ? null : distance,
    "palace_name": palaceName,
    "public_name": publicName,
    "level_id": level_id,
  };
}

