import 'package:flutter/cupertino.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/data/model/res/ResGetCMSPages.dart';
import 'package:send_me_pic/app/data/model/res/res_get_notification_by_user.dart';
import 'package:send_me_pic/app/data/repository/service_repository.dart';

class ServiceProvider extends ChangeNotifier{

  ServiceRepository _serviceRepository;

  ApiResponse<ResGetNotificationList> _notificationData;

  ApiResponse<ResGetNotificationList> get notificationData => _notificationData;

  ServiceProvider(){
    _serviceRepository = ServiceRepository();
    _notificationData = ApiResponse();
  }

  fetchNotification() async {
    _notificationData = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _serviceRepository.getNotification();

      if (res.status != 1) {
        throw '${res.message ?? ""}';
      }

      _notificationData = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      print("${e}");
      _notificationData = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  Future updateUserLoc() async {
    try{
      await _serviceRepository.updateUserLocation();
    }catch(e){
      rethrow;
    }
  }

}