class SendImageRequestReq{
  final String senderId ;
  final String receiverId ;
  final String description ;

  SendImageRequestReq({this.senderId, this.receiverId, this.description});

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "description": description,
  };
}