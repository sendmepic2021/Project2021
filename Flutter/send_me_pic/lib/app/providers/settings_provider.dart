
import 'package:flutter/cupertino.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/data/model/res/ResGetCMSPages.dart';
import 'package:send_me_pic/app/data/repository/service_repository.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';

class SettingsProvider extends ChangeNotifier {

  ServiceRepository _serviceRepository;

  ApiResponse<ResGetCMsPages> _cmsData;

  ApiResponse<ResGetCMsPages> get cmsData => _cmsData;

  SettingsProvider(){
    _serviceRepository = ServiceRepository();
  }

  final List<String> listNames = [
    'Notification',
    'Privacy Policy',
    'Terms and Conditions',
    'About Us',
    'Invite Friends',
    'Rate Us',
    'Logout'
  ];

  fetchCMSContent({int id,Function(ApiResponse<ResGetCMsPages>) completion}) async {
    _cmsData = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _serviceRepository.getCMSPages(id);

      if (res.status != 1) {
        throw '${res.message ?? "Server Error"}';
      }

      _cmsData = ApiResponse.completed(res);
      completion(_cmsData);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      _cmsData = ApiResponse.error('${e.toString()}');
      completion(_cmsData);
      notifyListeners();
    }
  }

  bool isNotification = false;

  setNotificationClicked(bool trigger) async {
    isNotification = trigger;
    try{
      var res = await _serviceRepository.updateNotification(trigger);

      if(res.status != 1){
        throw res.message;
      }

      await UserPreferences().setNotificationFlag(trigger ? 1 : 0);

    }catch(e){
      print(e);
    }
  }

}
