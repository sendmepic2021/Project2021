import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class SendImageRequestEntity with JsonConvert<SendImageRequestEntity> {
	int status;
	String message;
	SendImageRequestData data;
}

class SendImageRequestData with JsonConvert<SendImageRequestData> {
	String description;
	@JSONField(name: "sender_id")
	String senderId;
	@JSONField(name: "receiver_id")
	String receiverId;
	int status;
	@JSONField(name: "updated_at")
	String updatedAt;
	@JSONField(name: "created_at")
	String createdAt;
	int id;
}
