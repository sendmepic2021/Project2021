
import 'package:send_me_pic/app/model/emuns.dart';

class ResGetAllRequestByReceiverEntity {
	ResGetAllRequestByReceiverEntity({
		this.status,
		this.message,
		this.data,
	});

	int status;
	String message;
	List<ResGetAllRequestByReceiverData> data;

	factory ResGetAllRequestByReceiverEntity.fromJson(Map<String, dynamic> json) => ResGetAllRequestByReceiverEntity(
		status: json["status"],
		message: json["message"],
		data: List<ResGetAllRequestByReceiverData>.from(json["data"].map((x) => ResGetAllRequestByReceiverData.fromJson(x))),
	);

	Map<String, dynamic> toJson() => {
		"status": status,
		"message": message,
		"data": List<dynamic>.from(data.map((x) => x.toJson())),
	};
}

class ResGetAllRequestByReceiverData {
	ResGetAllRequestByReceiverData({
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
		this.isDeleted,
		this.createdAt,
		this.updatedAt,
		this.senderUserData,
		this.reciveUserData,
	});

	int id;
	dynamic title;
	String description;
	int senderId;
	int receiverId;
	dynamic image;
	int isActive;
	int isReceiver;
	dynamic latitude;
	dynamic longitude;
	dynamic imagePlaceName;
	String status;
	int isDeleted;
	DateTime createdAt;
	DateTime updatedAt;
	ResGetAllRequestByReceiverDataReciveUserData senderUserData;
	ResGetAllRequestByReceiverDataReciveUserData reciveUserData;

	factory ResGetAllRequestByReceiverData.fromJson(Map<String, dynamic> json) => ResGetAllRequestByReceiverData(
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
		isDeleted: json["is_deleted"],
		createdAt: DateTime.parse(json["created_at"]).toLocal(),
		updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
		senderUserData: ResGetAllRequestByReceiverDataReciveUserData.fromJson(json["sender_user_data"]),
		reciveUserData: ResGetAllRequestByReceiverDataReciveUserData.fromJson(json["recive_user_data"]),
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
		"is_deleted": isDeleted,
		"created_at": createdAt.toIso8601String(),
		"updated_at": updatedAt.toIso8601String(),
		"sender_user_data": senderUserData.toJson(),
		"recive_user_data": reciveUserData.toJson(),
	};
}

class ResGetAllRequestByReceiverDataReciveUserData {
	ResGetAllRequestByReceiverDataReciveUserData({
		this.id,
		this.displayName,
		this.firstName,
		this.lastName,
		this.publicName,
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
		this.palaceName,
		this.levelId,
		this.isNotification,
		this.isPrivateProfile,
		this.emailVerifiedAt,
		this.createdAt,
		this.updatedAt,
	});

	int id;
	String displayName;
	String firstName;
	String lastName;
	String publicName;
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
	String palaceName;
	int levelId;
	int isNotification;
	int isPrivateProfile;
	dynamic emailVerifiedAt;
	DateTime createdAt;
	DateTime updatedAt;

	UserBadge get badge => UserStatus.getBadgeStatus(levelId);

	factory ResGetAllRequestByReceiverDataReciveUserData.fromJson(Map<String, dynamic> json) => ResGetAllRequestByReceiverDataReciveUserData(
		id: json["id"],
		displayName: json["display_name"],
		firstName: json["first_name"],
		lastName: json["last_name"],
		publicName: json["public_name"],
		userProfileImage: json["user_profile_image"],
		email: json["email"],
		mobile: json["mobile"],
		fcmId: json["fcm_id"],
		deviceType: json["device_type"],
		socialId: json["social_id"],
		isActive: json["is_active"],
		token: json["token"],
		userType: json["user_type"],
		loginType: json["login_type"],
		packageId: json["package_id"],
		latitude: json["latitude"],
		longitude: json["longitude"],
		palaceName: json["palace_name"],
		levelId: json["level_id"],
		isNotification: json["is_notification"],
		isPrivateProfile: json["is_private_profile"],
		emailVerifiedAt: json["email_verified_at"],
		createdAt: DateTime.parse(json["created_at"]).toLocal(),
		updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
	);

	Map<String, dynamic> toJson() => {
		"id": id,
		"display_name": displayName,
		"first_name": firstName,
		"last_name": lastName,
		"public_name": publicName,
		"user_profile_image": userProfileImage,
		"email": email,
		"mobile": mobile,
		"fcm_id": fcmId,
		"device_type": deviceType,
		"social_id": socialId,
		"is_active": isActive,
		"token": token,
		"user_type": userType,
		"login_type": loginType,
		"package_id": packageId,
		"latitude": latitude,
		"longitude": longitude,
		"palace_name": palaceName,
		"level_id": levelId,
		"is_notification": isNotification,
		"is_private_profile": isPrivateProfile,
		"email_verified_at": emailVerifiedAt,
		"created_at": createdAt.toIso8601String(),
		"updated_at": updatedAt.toIso8601String(),
	};
}
