import 'package:send_me_pic/app/model/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLocalUser extends BaseModel{
  final bool isFirstTime;
  final bool isLogin;

  MyLocalUser({this.isFirstTime, this.isLogin});
}

class UserSharedPrefs{
  static String _isFirstTimeKey = 'isFirstTime';
  static String _isLoginKey = 'isLogin';

  static Future<MyLocalUser> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstTime = prefs.getBool(_isFirstTimeKey) ?? true;
    final isLogin = prefs.getBool(_isLoginKey) ?? false;

    return MyLocalUser(isFirstTime: isFirstTime,isLogin: isLogin);
  }

  static Future setUser(MyLocalUser user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(_isFirstTimeKey, user.isFirstTime);
    prefs.setBool(_isLoginKey, user.isLogin);
  }

  static Future removeUser() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(_isFirstTimeKey);
    prefs.remove(_isLoginKey);
  }

}