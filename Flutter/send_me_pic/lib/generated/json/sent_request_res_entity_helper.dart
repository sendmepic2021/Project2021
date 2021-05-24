import 'package:send_me_pic/app/data/model/res/sent_request_res_entity.dart';

sentRequestResEntityFromJson(SentRequestResEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => SentRequestResData().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> sentRequestResEntityToJson(SentRequestResEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] =  entity.data?.map((v) => v.toJson())?.toList();
	return data;
}

sentRequestResDataFromJson(SentRequestResData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['title'] != null) {
		data.title = json['title'];
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['sender_id'] != null) {
		data.senderId = json['sender_id'] is String
				? int.tryParse(json['sender_id'])
				: json['sender_id'].toInt();
	}
	if (json['receiver_id'] != null) {
		data.receiverId = json['receiver_id'] is String
				? int.tryParse(json['receiver_id'])
				: json['receiver_id'].toInt();
	}
	if (json['image'] != null) {
		data.image = json['image'];
	}
	if (json['is_active'] != null) {
		data.isActive = json['is_active'] is String
				? int.tryParse(json['is_active'])
				: json['is_active'].toInt();
	}
	if (json['is_receiver'] != null) {
		data.isReceiver = json['is_receiver'] is String
				? int.tryParse(json['is_receiver'])
				: json['is_receiver'].toInt();
	}
	if (json['latitude'] != null) {
		data.latitude = json['latitude'];
	}
	if (json['longitude'] != null) {
		data.longitude = json['longitude'];
	}
	if (json['image_place_name'] != null) {
		data.imagePlaceName = json['image_place_name'];
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> sentRequestResDataToJson(SentRequestResData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['description'] = entity.description;
	data['sender_id'] = entity.senderId;
	data['receiver_id'] = entity.receiverId;
	data['image'] = entity.image;
	data['is_active'] = entity.isActive;
	data['is_receiver'] = entity.isReceiver;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['image_place_name'] = entity.imagePlaceName;
	data['status'] = entity.status;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}