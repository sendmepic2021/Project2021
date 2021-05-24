import 'package:send_me_pic/app/data/model/res/login_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/base_res_model.dart';

loginResEntityFromJson(LoginResEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = LoginResData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> loginResEntityToJson(LoginResEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] = entity.data?.toJson();
	return data;
}

loginResDataFromJson(LoginResData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['display_name'] != null) {
		data.displayName = json['display_name'].toString();
	}
	if (json['first_name'] != null) {
		data.firstName = json['first_name'].toString();
	}
	if (json['last_name'] != null) {
		data.lastName = json['last_name'].toString();
	}
	if (json['user_profile_image'] != null) {
		data.userProfileImage = json['user_profile_image'].toString();
	}
	if (json['email'] != null) {
		data.email = json['email'].toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile'].toString();
	}
	if (json['fcm_id'] != null) {
		data.fcmId = json['fcm_id'].toString();
	}
	if (json['device_type'] != null) {
		data.deviceType = json['device_type'].toString();
	}
	if (json['social_id'] != null) {
		data.socialId = json['social_id'].toString();
	}
	if (json['is_active'] != null) {
		data.isActive = json['is_active'] is String
				? int.tryParse(json['is_active'])
				: json['is_active'].toInt();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	if (json['user_type'] != null) {
		data.userType = json['user_type'] is String
				? int.tryParse(json['user_type'])
				: json['user_type'].toInt();
	}
	if (json['login_type'] != null) {
		data.loginType = json['login_type'] is String
				? int.tryParse(json['login_type'])
				: json['login_type'].toInt();
	}
	if (json['package_id'] != null) {
		data.packageId = json['package_id'] is String
				? int.tryParse(json['package_id'])
				: json['package_id'].toInt();
	}
	if (json['latitude'] != null) {
		data.latitude = json['latitude'].toString();
	}
	if (json['longitude'] != null) {
		data.longitude = json['longitude'].toString();
	}
	if (json['level_id'] != null) {
		data.levelId = json['level_id'] is String
				? int.tryParse(json['level_id'])
				: json['level_id'].toInt();
	}
	if (json['is_notification'] != null) {
		data.isNotification = json['is_notification'] is String
				? int.tryParse(json['is_notification'])
				: json['is_notification'].toInt();
	}
	if (json['is_private_profile'] != null) {
		data.isPrivateProfile = json['is_private_profile'] is String
				? int.tryParse(json['is_private_profile'])
				: json['is_private_profile'].toInt();
	}
	if (json['email_verified_at'] != null) {
		data.emailVerifiedAt = json['email_verified_at'];
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'];
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> loginResDataToJson(LoginResData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['display_name'] = entity.displayName;
	data['first_name'] = entity.firstName;
	data['last_name'] = entity.lastName;
	data['user_profile_image'] = entity.userProfileImage;
	data['email'] = entity.email;
	data['mobile'] = entity.mobile;
	data['fcm_id'] = entity.fcmId;
	data['device_type'] = entity.deviceType;
	data['social_id'] = entity.socialId;
	data['is_active'] = entity.isActive;
	data['token'] = entity.token;
	data['user_type'] = entity.userType;
	data['login_type'] = entity.loginType;
	data['package_id'] = entity.packageId;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['level_id'] = entity.levelId;
	data['is_notification'] = entity.isNotification;
	data['is_private_profile'] = entity.isPrivateProfile;
	data['email_verified_at'] = entity.emailVerifiedAt;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}