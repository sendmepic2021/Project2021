import 'package:send_me_pic/app/model/user_model.dart';
import 'package:send_me_pic/app/model/user_pref.dart';

class LogoutReq{
  final String id ;

  LogoutReq({this.id});

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}