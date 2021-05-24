import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class GetUserFromLocResEntity with JsonConvert<GetUserFromLocResEntity> {
	int status;
	String message;
	GetUserFromLocResData data;
}

class GetUserFromLocResData with JsonConvert<GetUserFromLocResData> {
	@JSONField(name: "image_list")
	List<dynamic> imageList;
	List<GetUserFromLocResDataUser> user;
}

class GetUserFromLocResDataUser with JsonConvert<GetUserFromLocResDataUser> {
	int id;
	@JSONField(name: "display_name")
	String displayName;
	@JSONField(name: "first_name")
	String firstName;
	@JSONField(name: "last_name")
	String lastName;
	@JSONField(name: "user_profile_image")
	String userProfileImage;
	String email;
	String mobile;
	@JSONField(name: "fcm_id")
	String fcmId;
	@JSONField(name: "device_type")
	String deviceType;
	@JSONField(name: "social_id")
	String socialId;
	@JSONField(name: "is_active")
	int isActive;
	String token;
	@JSONField(name: "user_type")
	int userType;
	@JSONField(name: "login_type")
	int loginType;
	@JSONField(name: "package_id")
	int packageId;
	dynamic latitude;
	dynamic longitude;
	@JSONField(name: "level_id")
	int levelId;
	@JSONField(name: "is_notification")
	int isNotification;
	@JSONField(name: "is_private_profile")
	int isPrivateProfile;
	@JSONField(name: "email_verified_at")
	dynamic emailVerifiedAt;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;
}
