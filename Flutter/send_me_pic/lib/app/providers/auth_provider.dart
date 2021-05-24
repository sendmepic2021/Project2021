import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/data/model/req/LoginReq.dart';
import 'package:send_me_pic/app/data/repository/AuthRepository.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/model/user_model.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:send_me_pic/app/data/model/res/login_res_entity.dart';
import 'package:package_info/package_info.dart';

import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:crypto/crypto.dart';

abstract class AuthBase {
  Future getUserFromLocal();

  Future logInUser();

  Future logOutUser();
}

class AuthProvider extends ChangeNotifier with AuthBase {
  AuthProvider() {
    _authRepository = AuthRepository();
    _loginData = ApiResponse();
    getUserFromLocal();
  }

  MyLocalUser user;

  bool splashScreenLoaded = false;

  bool isLogin;

  bool isAppUnderMaintenance = false;

  bool isNewUpdateAvailable = false;

  AuthRepository _authRepository;

  ApiResponse<LoginResEntity> _loginData;

  ApiResponse<LoginResEntity> get loginData => _loginData;

  LoginType loginType = LoginType.google;

  @override
  getUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin') ?? false;
    notifyListeners();
  }

  //For FaceBook Token
  Future<AccessToken> _login() async {
    try{
      final LoginResult result = await FacebookAuth.instance.login(permissions: [
        "email"
      ]); // by the fault we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // get the user data
        // by default we get the userId, email,name and picture
        final userData = await FacebookAuth.instance.getUserData();
        // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
        print(userData);
        return result.accessToken;
      }

      if (result.status == LoginStatus.cancelled){
        throw 'Sign in aborted by User';
      }

      if (result.status == LoginStatus.failed){
        throw 'Sign in Failed';
      }

      print(result.status);
      print(result.message);
      return null;
    }catch(e){
      print('On Facebook Login');
      print(e);
      rethrow;
    }

  }

  //FaceBook SignIn
  facebookSignIn() async {
    try{
      var fbObj = await _login();

      final token = fbObj.token;

      print(token);

      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${token}'));
      final profile = json.decode(graphResponse.body);

      print('res: $profile');

      print(profile["email"]);
      print(profile["first_name"]);
      print(profile["last_name"]);
      print(profile["name"]);
      print(profile["picture"]["data"]["url"]);

      final email = profile["email"];
      final firstName = profile["first_name"];
      final lastName = profile["last_name"];
      final imgUrl = profile["picture"]["data"]["url"];

      logInUser(
          loginType: LoginType.facebook,
          userProfileImage: imgUrl,
          socialID: fbObj.userId,
          email: email,
          firstName: firstName,
          lastName: lastName);
    }catch(e){
      print('On Login');
      print(e);
      rethrow;
    }
  }

  //Google SignIn
  signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;

        print(googleAuth.idToken);
        print(googleAuth.serverAuthCode);
        print(googleAuth.accessToken);

        if (googleAuth.idToken != null) {

          String firstName = googleUser.displayName ?? "";
          String lastName = "";

          try{
            print('uri : https://www.googleapis.com/oauth2/v3/userinfo?access_token=${googleAuth.accessToken ?? ""}');
            final graphResponse = await http.get(Uri.parse(
                'https://www.googleapis.com/oauth2/v3/userinfo?access_token=${googleAuth.accessToken ?? ""}')).timeout(Duration(seconds: 10));

            final profile = json.decode(graphResponse.body);

            print(profile);

            firstName = profile["given_name"] ?? (googleUser.displayName ?? "");
            lastName = profile["family_name"] ?? "";

          }catch(e){
            throw e;
          }

          print(googleAuth.idToken);
          print(googleUser.displayName);
          print(googleUser.email);
          print(googleUser.photoUrl);

          logInUser(
              loginType: LoginType.google,
              userProfileImage: googleUser.photoUrl ?? "",
              socialID: googleUser.id ?? "",
              email: googleUser.email ?? "",
              firstName: firstName ?? "",
              lastName: lastName ?? "");
        } else {
          throw "Missing google id token";
        }
      } else {
        throw "Sign in aborted by user";
      }
    } catch (e) {
      throw e;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //Apple SignIn
  signInWithApple() async {

    try{
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'com.sqt.sendmepics',
        redirectUri: Uri.parse(
          'https://shimmering-light-approach.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
        // TODO: Remove these if you have no need for them
        nonce: nonce,
        state: 'example-state',
      ).onError((error, stackTrace) {
        throw 'Try again';
      });

      print(credential.identityToken);
      print(credential.email ?? "email");
      print(credential.familyName ?? "familyName");
      print(credential.givenName ?? "");
      print(credential.userIdentifier);
      print(credential.authorizationCode);
      print(credential.state);

      final oAuthProvider = OAuthProvider('apple.com').credential(accessToken: credential.authorizationCode,idToken: credential.identityToken,rawNonce: rawNonce);
      final credentials = oAuthProvider;
      // getCredential(
      //   idToken: appleIdCredential.identityToken,
      //   accessToken: appleIdCredential.authorizationCode,
      // );


      final res = await FirebaseAuth.instance.signInWithCredential(oAuthProvider);

      print(res.user.uid);

      logInUser(
          loginType: LoginType.apple,
          userProfileImage: "",
          socialID: res.user.uid,
          email: res.user.email,
          firstName: credential.givenName,
          lastName: credential.familyName);
    }catch(e){
      rethrow;
    }
  }

  //SignIn User With System
  @override
  logInUser(
      {LoginType loginType,
      String email,
      String firstName,
      String lastName,
      String socialID,
      String userProfileImage}) async {
    _loginData = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      LoginResEntity login = await _authRepository.logInUser(
          loginType: loginType,
          firstName: firstName ?? "",
          lastName: lastName ?? "",
          email: email ?? "",
          socialID: socialID ?? "",
          userProfileImage: userProfileImage ?? "");

      if(login.status != 1){
        throw login.message ?? "";
      }

      UserPreferences().saveUser(login.data);
      _loginData = ApiResponse.completed(login);
      notifyListeners();
    } catch (e) {
      print(e);
      _loginData = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  Future updateUser(MyLocalUser user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', user.isLogin);
    isLogin = user.isLogin;
    this.user = user;
    notifyListeners();
  }

  Future firstApi({Function completion,Function(String) onError}) async {
    splashScreenLoaded = false;
    notifyListeners();

    try{
      await setBaseUrl();

      await getCurrentVersion();

      if(isNewUpdateAvailable){
        if(completion != null){
          completion();
        }
      }

      if(isAppUnderMaintenance){
        splashScreenLoaded = false;
        notifyListeners();
      }else{
        splashScreenLoaded = true;
        notifyListeners();
      }

      notifyListeners();
    }catch(e){
      print(e);
      onError(e.toString());
    }

  }

  @override
  Future logOutUser() async {
    try{
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      await FacebookAuth.instance.logOut();

      await _authRepository.logoutUser();

      _loginData = ApiResponse();

      UserPreferences().removeUser();

      final prefs = await SharedPreferences.getInstance();
      prefs.remove('isLogin');

      user = null;
      isLogin = null;
      notifyListeners();
    }catch(e){
      print(e);
    }

  }

  Future setBaseUrl() async {
    try{
      await _authRepository.setBaseURLAPI();
    }catch(e){
      rethrow;
    }
  }

  Future getCurrentVersion() async {
    try{
      var res = await _authRepository.getCurrentVersion();

      if(res.status != 1){
        throw res.message ?? "";
      }

      isAppUnderMaintenance = res.data.isUndermaintenance == 1;
      notifyListeners();

      // res.data.androidAppVersion

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;

      print(version);

      if(Platform.isIOS){
        if(res.data.iosAppVersion == version){
          isNewUpdateAvailable = false;
        }else{
          isNewUpdateAvailable = true;
        }
        notifyListeners();
      }else if(Platform.isAndroid){
        if(res.data.androidAppVersion == version){
          isNewUpdateAvailable = false;
        }else{
          isNewUpdateAvailable = true;
        }
        notifyListeners();
      }
    }catch(e){
     rethrow;
    }
  }

}
