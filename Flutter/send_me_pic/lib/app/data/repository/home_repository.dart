import 'package:flutter/foundation.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/req/ReqGetDashboardCount.dart';
import 'package:send_me_pic/app/data/model/req/ReqSendMultipleRequestUserForImage.dart';
import 'package:send_me_pic/app/data/model/req/get_user_from_loc_req.dart';
import 'package:send_me_pic/app/data/model/res/LatLongDashBordRes.dart';
import 'package:send_me_pic/app/data/model/res/ResGetDashboardCount.dart';
import 'package:send_me_pic/app/data/model/res/base_res_model.dart';
import 'package:send_me_pic/app/data/model/res/get_user_from_loc_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_user_details_by_lat_long_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_user_details_by_lat_long_full_entity.dart';
import 'package:send_me_pic/app/model/user_pref.dart';

class HomeRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

 Future<ResDashboardLatLong> fetchUsers({double lat,double lon,String txt}) async {

   var local = await UserPreferences().getUser();

    var body = GetUsersByLocReq(latitude: lat,longitude: lon,searchText: txt,userID: local.id).toJson();
    //post method

    final response = await _helper.postApi(kGetUsersFromLocationPath, body);

    print('success : $response');

    return ResDashboardLatLong.fromJson(response);
  }



  Future<CommonRes> sendRequestToUser(String ids,String desc) async {

    var local = await UserPreferences().getUser();

    final body = ReqSendMultipleRequestUserForImage(description: desc,senderId: local.id.toString(),receiverId: ids);

    final response = await _helper.postApi(kSendMultipleRequestToUserPath, body.toJson());

    return CommonRes.fromJson(response);

  }

  Future<ResGetDashboardCount> getDashboardCount() async {

    var local = await UserPreferences().getUser();

    final body = ReqGetDashboardCount(id: local.id);

    final response = await _helper.postApi(kgetDashboardCount, body.toJson());

    return ResGetDashboardCount.fromJson(response);

  }

  Future showSentRequest() async {

    var local = await UserPreferences().getUser();

    final body = ReqGetDashboardCount(id: local.id);

    final response = await _helper.postApi(kShowSentRequest, body.toJson());

  }


  Future showReceiveRequest() async {

    var local = await UserPreferences().getUser();

    final body = ReqGetDashboardCount(id: local.id);

    final response = await _helper.postApi(kShowReceiveRequest, body.toJson());

  }

}