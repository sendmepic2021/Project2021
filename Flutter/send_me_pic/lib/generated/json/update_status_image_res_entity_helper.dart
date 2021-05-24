import 'package:send_me_pic/app/data/model/req/update_status_image_res_entity.dart';

updateStatusImageResEntityFromJson(UpdateStatusImageResEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = UpdateStatusImageResData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> updateStatusImageResEntityToJson(UpdateStatusImageResEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] = entity.data?.toJson();
	return data;
}

updateStatusImageResDataFromJson(UpdateStatusImageResData data, Map<String, dynamic> json) {
	if (json['image-id'] != null) {
		data.imageId = json['image-id'] is String
				? int.tryParse(json['image-id'])
				: json['image-id'].toInt();
	}
	if (json['receiver-id'] != null) {
		data.receiverId = json['receiver-id'] is String
				? int.tryParse(json['receiver-id'])
				: json['receiver-id'].toInt();
	}
	return data;
}

Map<String, dynamic> updateStatusImageResDataToJson(UpdateStatusImageResData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['image-id'] = entity.imageId;
	data['receiver-id'] = entity.receiverId;
	return data;
}