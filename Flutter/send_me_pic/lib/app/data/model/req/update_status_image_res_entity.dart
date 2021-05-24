import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class UpdateStatusImageResEntity with JsonConvert<UpdateStatusImageResEntity> {
	int status;
	String message;
	UpdateStatusImageResData data;
}

class UpdateStatusImageResData with JsonConvert<UpdateStatusImageResData> {
	@JSONField(name: "image-id")
	int imageId;
	@JSONField(name: "receiver-id")
	int receiverId;
}
