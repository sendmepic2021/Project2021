import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/req/ReqUpdateNotificationStatusById.dart';
import 'package:send_me_pic/app/data/model/req/image_upload_req.dart';
import 'package:send_me_pic/app/data/model/req/update_status_image_res_entity.dart';
import 'package:send_me_pic/app/data/model/req/update_status_res.dart';
import 'package:send_me_pic/app/data/model/res/ResDeleteImage.dart';
import 'package:send_me_pic/app/data/model/res/ResUpdateNotificationStatusById.dart';
import 'package:send_me_pic/app/data/model/res/image_upload_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_all_request_by_receiver_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_get_request_detail_by_id_entity.dart';
import 'package:send_me_pic/app/data/model/res/res_request_detail_entity.dart';
import 'package:send_me_pic/app/data/model/res/sent_request_res_entity.dart';
import 'package:send_me_pic/app/data/model/res/update_status_res.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/services/google_map_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';

class ImageRequestRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ResGetAllRequestByReceiverEntity> fetchSentRequest() async {

    var local = await UserPreferences().getUser();

    final response = await _helper.getApi('$kGetAllSentRequestPath/${local.id}');

    return ResGetAllRequestByReceiverEntity.fromJson(response);
  }

  Future<ResGetAllRequestByReceiverEntity> fetchReceivedRequest() async {

    var local = await UserPreferences().getUser();

    final response = await _helper.getApi('$kGetAllReceivedRequestPath/${local.id}');

    return ResGetAllRequestByReceiverEntity.fromJson(response);
  }

  Future<ResGetRequestDetailByIdEntity> fetchReceivedReqDetails(int id) async {

    var local = await UserPreferences().getUser();

    final response = await _helper.getApi('$kGetRequestDetailsPath/${id}?user_id=${local.id}');

    return ResGetRequestDetailByIdEntity.fromJson(response);
  }

  Future<UpdateStatusImageResEntity> requestStatus(int id, int status) async {
    var body = UpdateStatusReq(id: id,status: status);

    //post method
    final response = await _helper.postApi(kUpdateStatusPath, body.toJson());

    return UpdateStatusImageResEntity().fromJson(response);

  }

  Future<ImageUploadResEntity> uploadImage(int id,{filepath}) async {

    try{
      UserLocation pos = await LocationService.getLocation();

      final address = await GooglePlaceService.getAddress(latitude: pos.latitude,longitude: pos.longitude);

      ImageUploadReq req = ImageUploadReq(id: id,lon: pos.longitude,lat: pos.latitude, address: address.subLocality ?? "");

      final response = await _helper.uploadImage(filepath: filepath,path: kUploadImageBySenderPath, body: req.toJson(),imgName: 'image');

      return ImageUploadResEntity().fromJson(response);
    }catch(e){
      rethrow;
    }
  }
  
  Future<ResDeleteImage> deleteImage(int id) async {

    final response = await _helper.postApi(kDeleteImage, {
      "id":"$id"
    });

    return ResDeleteImage.fromJson(response);

  }

  Future<ResUpdateNotificationStatusById> updateNotificationStatusById(int notificationId) async {

    var local = await UserPreferences().getUser();

    final req = ReqUpdateNotificationStatusById(userId: local.id,notificationId: notificationId);

    final response = await _helper.postApi(kUpdateNotificationStatusById, req.toJson());

    return ResUpdateNotificationStatusById.fromJson(response);
  }

}