import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class ImageUploadResEntity with JsonConvert<ImageUploadResEntity> {
	int status;
	String message;
	ImageUploadResData data;
}

class ImageUploadResData with JsonConvert<ImageUploadResData> {
	int id;
	String image;
	@JSONField(name: "sender_id")
	int senderId;
}
