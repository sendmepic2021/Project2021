import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class ResGetAllRequestBySenderEntity with JsonConvert<ResGetAllRequestBySenderEntity> {
	 int status;
	 String message;
	 List<ResGetAllRequestBySenderData> data;
}

class ResGetAllRequestBySenderData with JsonConvert<ResGetAllRequestBySenderData> {
	 int id;
	 dynamic title;
	 String description;
	@JSONField(name: "sender_id")
	 int senderId;
	@JSONField(name: "receiver_id")
	 int receiverId;
	 dynamic image;
	@JSONField(name: "is_active")
	 int isActive;
	@JSONField(name: "is_receiver")
	 int isReceiver;
	 dynamic latitude;
	 dynamic longitude;
	@JSONField(name: "image_place_name")
	 dynamic imagePlaceName;
	 String status;
	@JSONField(name: "created_at")
	 String createdAt;
	@JSONField(name: "updated_at")
	 String updatedAt;
	@JSONField(name: "sender_user_data")
	 ResGetAllRequestBySenderDataSenderUserData senderUserData;
	@JSONField(name: "recive_user_data")
	 ResGetAllRequestBySenderDataReciveUserData reciveUserData;
}

class ResGetAllRequestBySenderDataSenderUserData with JsonConvert<ResGetAllRequestBySenderDataSenderUserData> {
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
}

class ResGetAllRequestBySenderDataReciveUserData with JsonConvert<ResGetAllRequestBySenderDataReciveUserData> {
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
}
