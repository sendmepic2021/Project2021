import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/req/LoginReq.dart';
import 'package:send_me_pic/app/data/model/req/send_image_req_req.dart';
import 'package:send_me_pic/app/data/model/req/update_profile_req.dart';
import 'package:send_me_pic/app/data/model/res/base_res_model.dart';
import 'package:send_me_pic/app/data/model/res/login_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/send_image_request_entity.dart';
import 'package:send_me_pic/app/data/model/res/update_user_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/user_res_entity.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/services/location_service.dart';

class UserProfileRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserResEntity> fetchData(int id) async {

    //post method
    final response = await _helper.getApi('$kGetUserByIdPath/${id}');

    return UserResEntity.fromJson(response);
  }

  Future updateUser(String firstName,String lastName, String privateName,String mobile,bool isProfilePrivate,{filepath}) async {

    UserLocation pos = await LocationService.getLocation();

    var user = await UserPreferences().getUser();

    UpdateProfileReq req = UpdateProfileReq(firstName: firstName,lastName: lastName,longitude: pos.longitude,latitude: pos.latitude,id: user.id,isProfilePrivate: isProfilePrivate ? 1 : 0,mobile: mobile,publicName: privateName);

    if(filepath == null){

      final response = await _helper.uploadImage(path: kUpdateProfilePath, body: req.toJson(),imgName: 'user_profile_image');

      return UpdateUserResEntity().fromJson(response);

    }else{

      final response = await _helper.uploadImage(filepath: filepath,path: kUpdateProfilePath, body: req.toJson(),imgName: 'user_profile_image');

      return UpdateUserResEntity().fromJson(response);

    }

  }

   Future sendRequestToUser(int id,String desc) async {

     var local = await UserPreferences().getUser();

    final body = SendImageRequestReq(description: desc,senderId: local.id.toString(),receiverId: id.toString());

    final response = await _helper.postApi(kSendImageRequestPath, body.toJson());

    print('res is : $response');

     return SendImageRequestEntity().fromJson(response);

  }

}