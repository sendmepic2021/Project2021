import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/data/model/req/update_status_image_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/ResDeleteImage.dart';
import 'package:send_me_pic/app/data/model/res/image_upload_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_all_request_by_receiver_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_request_detail_by_id_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_request_detail_entity.dart';
import 'package:send_me_pic/app/data/model/res/sent_request_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/update_status_res.dart';
import 'package:send_me_pic/app/data/repository/image_req_repository.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/services/image_service.dart';

class RequestProvider extends ChangeNotifier {
  ImageRequestRepository _imgReqRepository;

  ApiResponse<ResGetAllRequestByReceiverEntity> _sendReqRes;

  ApiResponse<ResGetAllRequestByReceiverEntity> get sendReqRes => _sendReqRes;

  ApiResponse<ResGetAllRequestByReceiverEntity> _receivedReqRes;

  ApiResponse<ResGetAllRequestByReceiverEntity> get receivedReqRes => _receivedReqRes;

  ApiResponse<ResGetRequestDetailByIdEntity> _receivedReqResDetails;

  ApiResponse<ResGetRequestDetailByIdEntity> get receivedReqResDetails => _receivedReqResDetails;

  ApiResponse<UpdateStatusImageResEntity> _updateStatusRes;

  ApiResponse<UpdateStatusImageResEntity> get updateStatusRes => _updateStatusRes;

  ApiResponse<ImageUploadResEntity> _uploadImgRes;

  ApiResponse<ImageUploadResEntity> get uploadImgRes => _uploadImgRes;

  ApiResponse<ResDeleteImage> _deleteImageRes;

  ApiResponse<ResDeleteImage> get deleteImageRes => _deleteImageRes;


  File pickedImage;

  int selectedReceivedReqDetail = 0;

  RequestProvider() {
    _imgReqRepository = ImageRequestRepository();
    _sendReqRes = ApiResponse();
    _receivedReqRes = ApiResponse();
    _receivedReqResDetails = ApiResponse();
    _updateStatusRes = ApiResponse();
    _uploadImgRes = ApiResponse();
    _deleteImageRes = ApiResponse();
  }

  fetchSentReq() async{
    _sendReqRes = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _imgReqRepository.fetchSentRequest();

      if (res.status != 1) {
        throw '${res.message ?? "Server Error"}';
      }

      _sendReqRes = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      print(e);
      _sendReqRes = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  fetchReceivedReq() async{
    _receivedReqRes = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _imgReqRepository.fetchReceivedRequest();

      if (res.status != 1) {
        throw '${res.message}';
      }

      _receivedReqRes = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      _receivedReqRes = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  fetchReceivedReqDetails() async{
    _receivedReqResDetails = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _imgReqRepository.fetchReceivedReqDetails(selectedReceivedReqDetail);

      if (res.status != 1) {
        throw '${res.message ?? "Server Problem"}';
      }

      _receivedReqResDetails = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      _receivedReqResDetails = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }


  requestStatus(int id, int status) async{
    _updateStatusRes = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _imgReqRepository.requestStatus(id, status);

      if (res.status != 1) {
        throw '${res.message ?? "Server Problem"}';
      }
      _updateStatusRes = ApiResponse.completed(res);
      fetchReceivedReqDetails();
      fetchReceivedReq();
      notifyListeners();
    } catch (e) {
      _updateStatusRes = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  uploadImage(Function completion) async {
    _uploadImgRes = ApiResponse.loading('Fetching');

    // var img = await ImageService.getBytesFromAsset(pickedImage.path, 300);

    // final file = await new File(pickedImage.path).create();
    // file.writeAsBytesSync(img);

    notifyListeners();
    try {
      var res = await _imgReqRepository.uploadImage(selectedReceivedReqDetail,filepath: pickedImage.path);

      if (res.status != 1) {
        throw '${res.message}';
      }
      _uploadImgRes = ApiResponse.completed(res);
      fetchReceivedReqDetails();
      fetchReceivedReq();
      completion();
      notifyListeners();
    } catch (e) {
      print('error is $e');
      _uploadImgRes = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  deleteImage({int id,Function completion}) async {
    _deleteImageRes = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _imgReqRepository.deleteImage(id);

      if (res.status != 1) {
        throw '${res.message ?? "Server Problem"}';
      }
      _deleteImageRes = ApiResponse.completed(res);
      completion();
      notifyListeners();
    } catch (e) {
      print('error is $e');
      _deleteImageRes = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  updateNotificationStatusById(int notificationID) async {
    try{
      await _imgReqRepository.updateNotificationStatusById(notificationID);
    }catch(e){
      print(e);
    }
  }

}
