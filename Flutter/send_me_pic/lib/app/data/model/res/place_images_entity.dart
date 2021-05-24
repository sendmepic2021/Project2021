import 'package:send_me_pic/generated/json/base/json_convert_content.dart';
import 'package:send_me_pic/generated/json/base/json_field.dart';

class PlaceImagesEntity with JsonConvert<PlaceImagesEntity> {

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
	dynamic latitude;
	dynamic longitude;
	@JSONField(name: "image_place_name")
	dynamic imagePlaceName;
	String status;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;
}

