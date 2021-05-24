import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/req/req_update_user_location.dart';
import 'package:send_me_pic/app/data/model/res/ResGetCMSPages.dart';
import 'package:send_me_pic/app/data/model/res/res_get_notification_by_user.dart';
import 'package:send_me_pic/app/data/model/res/res_update_notification.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/services/google_map_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';

class ServiceRepository{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ResUpdateNotification> updateNotification(bool isOn) async {

    var user = await UserPreferences().getUser();

    final body = {
      "id": user.id.toString(),
      "is_notification": isOn ? 1.toString() : 0.toString(),
    };

    //post method
    final response = await _helper.postApi(kUpdateNotificationPath, body);

    return ResUpdateNotification.fromJson(response);
  }

  Future<ResGetNotificationList> getNotification() async {
    var local = await UserPreferences().getUser();

    final response = await _helper.getApi('$kGetNotificationListPath/${local.id}');

    return ResGetNotificationList.fromJson(response);
  }

  Future updateUserLocation() async {
    var local = await UserPreferences().getUser();

    if (local != null && local.id != null){

      var pos = await LocationService.getLocation();

      if( pos != null && pos.latitude != null){
        try{
          var address = await GooglePlaceService.getAddress(latitude: pos.latitude,longitude: pos.longitude);

          print("Address: " + address.subLocality);

          var body = ReqUpdateUserLocation(local.id, pos.longitude, pos.latitude, address.subLocality);

          await _helper.postApi('$kUpdateUserLocationPath',body.toJson());
        }catch(e){
          rethrow;
        }

      }else{
        throw 'Location not found';
      }
    }else{
      throw 'User not found';
    }

  }

  Future<ResGetCMsPages> getCMSPages(int id) async {

    var res = await _helper.getApi('$kGetCmsPagesPath/$id');

    return ResGetCMsPages.fromJson(res);

  }

}