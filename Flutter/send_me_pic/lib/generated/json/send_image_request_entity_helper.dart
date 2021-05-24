import 'package:send_me_pic/app/data/model/res/send_image_request_entity.dart';

sendImageRequestEntityFromJson(SendImageRequestEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = SendImageRequestData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> sendImageRequestEntityToJson(SendImageRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] = entity.data?.toJson();
	return data;
}

sendImageRequestDataFromJson(SendImageRequestData data, Map<String, dynamic> json) {
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['sender_id'] != null) {
		data.senderId = json['sender_id'].toString();
	}
	if (json['receiver_id'] != null) {
		data.receiverId = json['receiver_id'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> sendImageRequestDataToJson(SendImageRequestData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['description'] = entity.description;
	data['sender_id'] = entity.senderId;
	data['receiver_id'] = entity.receiverId;
	data['status'] = entity.status;
	data['updated_at'] = entity.updatedAt;
	data['created_at'] = entity.createdAt;
	data['id'] = entity.id;
	return data;
}