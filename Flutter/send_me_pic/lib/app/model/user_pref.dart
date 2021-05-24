import 'package:send_me_pic/app/data/model/res/login_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/update_user_res_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(LoginResData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.id ?? 0);
    prefs.setString("displayName", user.displayName ?? "");
    prefs.setString("socialId", user.socialId ?? "");
    prefs.setString("email", user.email ?? "");
    prefs.setString("mobile", user.mobile ?? "");
    prefs.setString("fcmId", user.fcmId ?? "");
    prefs.setString("token", user.token ?? "");
    prefs.setInt("isPrivateProfile", user.isPrivateProfile ?? 0);
    prefs.setString("userImage", user.userProfileImage ?? "");
    prefs.setInt("isNotificationOn", user.isNotification ?? 0);

    return prefs.commit();
  }

  Future<bool> editUser(UpdateUserResData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.id ?? 0);
    prefs.setString("displayName", user.displayName ?? "");
    prefs.setString("socialId", user.socialId ?? "");
    prefs.setString("email", user.email ?? "");
    prefs.setString("mobile", user.mobile ?? "");
    prefs.setString("fcmId", user.fcmId ?? "");
    prefs.setString("token", user.token ?? "");
    prefs.setInt("isPrivateProfile", user.isPrivateProfile ?? 0);
    prefs.setString("userImage", user.userProfileImage ?? "");
    prefs.setInt("isNotificationOn", user.isNotification ?? 0);

    return prefs.commit();
  }

  Future<MyUser> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("userId");
    String displayName = prefs.getString("displayName");
    String socialId = prefs.getString("socialId");
    String email = prefs.getString("email");
    String mobile = prefs.getString("mobile");
    String fcmId = prefs.getString("fcmId");
    String token = prefs.getString("token");
    String userImage = prefs.getString("userImage");
    int isPrivateProfile = prefs.getInt("isPrivateProfile");
    int isNotificationOn = prefs.getInt("isNotificationOn");

    return MyUser(id: id,email: email,fcmId: fcmId,isPrivateProfile: isPrivateProfile,mobile: mobile,socialId: socialId,token: token,displayName: displayName,userImage: userImage,isNotificationOn: isNotificationOn);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("displayName");
    prefs.remove("userId");
    prefs.remove("socialId");
    prefs.remove("email");
    prefs.remove("mobile");
    prefs.remove("fcmId");
    prefs.remove("token");
    prefs.remove("isPrivateProfile");
    prefs.remove("userImage");
    prefs.remove("isNotificationOn");

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }

  Future setNotificationFlag(int isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("isNotificationOn", isOn);
  }

}

class MyUser{

  final int id;
  final String displayName;
  final String socialId;
  final String email;
  final String mobile;
  final String fcmId;
  final String token;
  final String userImage;
  final int isPrivateProfile;
  final int isNotificationOn;

  MyUser({this.id, this.socialId, this.email, this.mobile, this.fcmId, this.token, this.isPrivateProfile, this.displayName, this.userImage, this.isNotificationOn});
}