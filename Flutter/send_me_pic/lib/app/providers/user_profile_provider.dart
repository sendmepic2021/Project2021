import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/data/model/res/send_image_request_entity.dart';
import 'package:send_me_pic/app/data/model/res/update_user_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/user_res_entity.dart';
import 'package:send_me_pic/app/data/repository/UserProfilerepository.dart';
import 'package:send_me_pic/app/model/user_pref.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfileRepository _userProfileRepository;

  ApiResponse<UserResEntity> _user;

  ApiResponse<UserResEntity> get user => _user;

  ApiResponse<UpdateUserResEntity> _updatedUser;

  ApiResponse<UpdateUserResEntity> get updatedUser => _updatedUser;

  ApiResponse<UserResEntity> _otherUser;

  ApiResponse<UserResEntity> get otherUser => _otherUser;

  ApiResponse<SendImageRequestEntity> _imageReq;

  ApiResponse<SendImageRequestEntity> get imageReq => _imageReq;

  UserProfileProvider() {
    _user = ApiResponse();
    _updatedUser = ApiResponse();
    _otherUser = ApiResponse();
    _imageReq = ApiResponse();
    _userProfileRepository = UserProfileRepository();
  }


  sendRequest(int selectedID,String txt,Function(ApiResponse res) action) async{
    _imageReq = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      SendImageRequestEntity res = await UserProfileRepository().sendRequestToUser(selectedID, txt);;

      if (res.status != 1) {
        print('Got the error');
        throw '${res.message ?? "Server Error"}';
      }

      _imageReq = ApiResponse.completed(res);
      notifyListeners();
      action(_imageReq);

    } catch (e) {
      print(e);
      _imageReq = ApiResponse.error('${e.toString()}');
      notifyListeners();
      action(_imageReq);
    }
  }

  fetchSpecificUser(int id) async {
    _otherUser = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      UserResEntity user = await _userProfileRepository.fetchData(id);

      if (user.status != 1) {
        throw 'Error: ${user.message}';
      }

      _otherUser = ApiResponse.completed(user);
      notifyListeners();
    } catch (e) {
      _otherUser = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  fetchUser() async {
    _user = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var local = await UserPreferences().getUser();
      UserResEntity user = await _userProfileRepository.fetchData(local.id);

      if (user.status != 1) {
        throw 'Error: ${user.message}';
      }

      _user = ApiResponse.completed(user);
      notifyListeners();
      _updatedUser = ApiResponse();
    } catch (e) {
      print(e);
      _user = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  updateProfile({filepath, String firstName,String mobile,bool isProfilePrivate,String lastName,String publicName, @required completion}) async {

    _updatedUser = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      if (filepath == null) {
        UpdateUserResEntity res =
            await _userProfileRepository.updateUser(firstName, lastName,publicName,mobile, isProfilePrivate);


        if(res.status != 1){
          throw 'Error: ${res.message}';
        }

        _updatedUser = ApiResponse.completed(res);
        notifyListeners();
        if (res.status == 1) {
          UserPreferences().editUser(res.data);
          completion();
          fetchUser();
        }
      } else {
        UpdateUserResEntity res = await _userProfileRepository
            .updateUser(firstName, lastName,publicName ,mobile, isProfilePrivate, filepath: filepath);

        if(res.status != 1){
          throw 'Error: ${res.message}';
        }
        _updatedUser = ApiResponse.completed(res);
        notifyListeners();
        if (res.status == 1) {
          UserPreferences().editUser(res.data);
          completion();
          fetchUser();
        }
      }
    } catch (e) {
      _updatedUser = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }
}
