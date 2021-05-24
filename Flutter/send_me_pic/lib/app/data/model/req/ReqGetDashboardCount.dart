class ReqGetDashboardCount{
  final int id ;

  ReqGetDashboardCount({this.id});

  Map<String, dynamic> toJson() => {
    "user_id": id.toString(),
  };
}