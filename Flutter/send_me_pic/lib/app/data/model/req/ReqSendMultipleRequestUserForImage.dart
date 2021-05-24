class ReqSendMultipleRequestUserForImage{
  final String description;
  final String senderId;
  final String receiverId;

  ReqSendMultipleRequestUserForImage({this.description, this.senderId, this.receiverId});

  Map<String, dynamic> toJson() => {
    "description": description,
    "sender_id": senderId,
    "receiver_id": receiverId
  };
}