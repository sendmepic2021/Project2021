class UpdateStatusReq {
  final int id;
  final int status;

  UpdateStatusReq({this.status, this.id});

  Map<String, dynamic> toJson() => {
    "id": id.toString(),
    "status": status.toString()
  };
}
