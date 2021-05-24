import 'package:send_me_pic/app/data/model/res/image_upload_res_entity.dart';

imageUploadResEntityFromJson(ImageUploadResEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = ImageUploadResData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> imageUploadResEntityToJson(ImageUploadResEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] = entity.data?.toJson();
	return data;
}

imageUploadResDataFromJson(ImageUploadResData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	if (json['sender_id'] != null) {
		data.senderId = json['sender_id'] is String
				? int.tryParse(json['sender_id'])
				: json['sender_id'].toInt();
	}
	return data;
}

Map<String, dynamic> imageUploadResDataToJson(ImageUploadResData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['image'] = entity.image;
	data['sender_id'] = entity.senderId;
	return data;
}