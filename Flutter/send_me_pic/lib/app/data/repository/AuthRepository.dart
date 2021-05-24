import 'dart:io';

import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/req/LoginReq.dart';
import 'package:send_me_pic/app/data/model/req/logout_req.dart';
import 'package:send_me_pic/app/data/model/res/ResGetBaseURL.dart';
import 'package:send_me_pic/app/data/model/res/ResGetCurrentVersion.dart';
import 'package:send_me_pic/app/data/model/res/login_res_entity.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/services/firebase_config.dart';

class AuthRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

  Future setBaseURLAPI() async{
    final res = await _helper.getApiFromURL(kBaseUrlGetter);

    var baseData = ResGetBaseURL.fromJson(res);

    kBaseURL = baseData.data.baseUrl ?? 'http://app.sendmepic.me/api/v1/';
    kImgBaseURL = baseData.data.imageBaseUrl ?? '';
  }

  Future<ResGetCurrentVersion> getCurrentVersion() async {
    final res = await _helper.getApi(kGetCurrentVersion);

    return ResGetCurrentVersion.fromJson(res);
  }


  Future<LoginResEntity> logInUser({LoginType loginType,String email, String firstName, String lastName,String socialID,String userProfileImage}) async {

    PlatformEnum platform = PlatformEnum.iOS;

    if(Platform.isIOS){
      platform = PlatformEnum.iOS;
    }else{
      platform = PlatformEnum.Android;
    }

    var loginBody = LoginReq(deviceType: platform.getValue,email: email,fcmID: FirebaseConfig.FCMToken,firstName: firstName,lastName: lastName,loginType: loginType.getValue,socialID: socialID,userProfileImage: userProfileImage);

    //post method
    final response = await _helper.postApi(kLoginPath, loginBody.toJson());

    print('success : $response');

    return LoginResEntity().fromJson(response);
  }


  Future logoutUser() async {

    var user = await UserPreferences().getUser();

    var logoutBody = LogoutReq(id: user.id.toString());

    //post method
    final response = await _helper.postApi(kLogoutPath, logoutBody.toJson());

    print('success : $response');
  }

}