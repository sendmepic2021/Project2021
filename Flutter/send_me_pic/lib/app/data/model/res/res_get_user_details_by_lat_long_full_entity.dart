import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class ResGetUserDetailsByLatLongFullEntity with JsonConvert<ResGetUserDetailsByLatLongFullEntity> {
	int status;
	String message;
	ResGetUserDetailsByLatLongFullData data;
}

class ResGetUserDetailsByLatLongFullData with JsonConvert<ResGetUserDetailsByLatLongFullData> {
	@JSONField(name: "user_list")
	List<ResGetUserDetailsByLatLongFullDataUserList> userList;
	@JSONField(name: "image_group")
	List<List<ResGetUserDetailsByLatLongFullDataUserList>> imageGroup;
}

class ResGetUserDetailsByLatLongFullDataUserList with JsonConvert<ResGetUserDetailsByLatLongFullDataUserList> {
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
	String latitude;
	String longitude;
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
	double distance;
}

class ResGetUserDetailsByLatLongFullDataImageGroupResGetUserDetailsByLatLongFullDataImageGroup with JsonConvert<ResGetUserDetailsByLatLongFullDataImageGroupResGetUserDetailsByLatLongFullDataImageGroup> {
	int id;
	String title;
	String description;
	@JSONField(name: "sender_id")
	int senderId;
	@JSONField(name: "receiver_id")
	int receiverId;
	String image;
	@JSONField(name: "is_active")
	int isActive;
	@JSONField(name: "is_receiver")
	int isReceiver;
	String latitude;
	String longitude;
	@JSONField(name: "image_place_name")
	String imagePlaceName;
	String status;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;
	double distance;
	String latlong;
}
