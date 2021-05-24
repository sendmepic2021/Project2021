
import 'package:send_me_pic/app/model/emuns.dart';

class UserResEntity {
	UserResEntity({
		this.status,
		this.message,
		this.data,
	});

	int status;
	String message;
	UserResData data;

	factory UserResEntity.fromJson(Map<String, dynamic> json) => UserResEntity(
		status: json["status"],
		message: json["message"],
		data: UserResData.fromJson(json["data"]),
	);

	Map<String, dynamic> toJson() => {
		"status": status,
		"message": message,
		"data": data.toJson(),
	};
}

class UserResData {
	UserResData({
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
		this.profileTotal,
		this.profileRecived,
		this.profileCompleted,
		this.image,
		this.level_id
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
	int profileTotal;
	int profileRecived;
	int profileCompleted;
	List<dynamic> image;
	int level_id;

	UserBadge get badge => UserStatus.getBadgeStatus(level_id);

	factory UserResData.fromJson(Map<String, dynamic> json) => UserResData(
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
		profileTotal: json["profile_total"],
		profileRecived: json["profile_recived"],
		profileCompleted: json["profile_completed"],
		level_id: json["level_id"],
		image: List<dynamic>.from(json["Image"].map((x) => x)),
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
		"profile_total": profileTotal,
		"profile_recived": profileRecived,
		"profile_completed": profileCompleted,
		"level_id": level_id,
		"Image": List<dynamic>.from(image.map((x) => x)),
	};
}
