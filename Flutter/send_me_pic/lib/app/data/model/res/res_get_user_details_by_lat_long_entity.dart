import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class ResGetUserDetailsByLatLongEntity with JsonConvert<ResGetUserDetailsByLatLongEntity> {
	 int status;
	 String message;
	 ResGetUserDetailsByLatLongData data;
}

class ResGetUserDetailsByLatLongData with JsonConvert<ResGetUserDetailsByLatLongData> {
	@JSONField(name: "user_list")
	 List<ResGetUserDetailsByLatLongDataUserList> userList;
	@JSONField(name: "image_list")
	 List<ResGetUserDetailsByLatLongDataImageList> imageList;
}

class ResGetUserDetailsByLatLongDataUserList with JsonConvert<ResGetUserDetailsByLatLongDataUserList> {
	 int id;
	@JSONField(name: "display_name")
	 dynamic displayName;
	@JSONField(name: "first_name")
	 String firstName;
	@JSONField(name: "last_name")
	 String lastName;
	@JSONField(name: "user_profile_image")
	 String userProfileImage;
	 dynamic email;
	 dynamic mobile;
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
	 int distance;
}

class ResGetUserDetailsByLatLongDataImageList with JsonConvert<ResGetUserDetailsByLatLongDataImageList> {
	 int id;
	 dynamic title;
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
	 int distance;
}
