import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'dart:ui' as ui;

import 'package:send_me_pic/app/constants/constants.dart';

import 'package:geolocator/geolocator.dart';
import 'package:send_me_pic/app/data/model/res/LatLongDashBordRes.dart';
import 'package:send_me_pic/app/data/model/res/ResGetDashboardCount.dart';
import 'package:send_me_pic/app/data/model/res/base_res_model.dart';
import 'package:send_me_pic/app/data/repository/home_repository.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/service_provider.dart';
import 'package:send_me_pic/app/services/google_map_service.dart';
import 'package:send_me_pic/app/services/image_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';
import 'package:send_me_pic/app/model/emuns.dart';

class HomeProvider extends ChangeNotifier {
  int selectedUserFromMarker = 0;

  int selectedPlaceIndex = 0;

  String requestUser = "";

  Completer<GoogleMapController> controller = Completer();

  HomeRepository _homeRepository;

  ApiResponse<ResDashboardLatLong> _res;

  ApiResponse<ResDashboardLatLong> get res => _res;

  ApiResponse<CommonRes> _multipleUserReq;

  ApiResponse<CommonRes> get multipleUserReq => _multipleUserReq;

  ApiResponse<ResGetDashboardCount> _dashboardCountRes;

  ApiResponse<ResGetDashboardCount> get dashboardCountRes => _dashboardCountRes;

  double searchedLat = 0.0;
  double searchedLon = 0.0;

  BuildContext homeContext;

  Timer timer;

  ServiceProvider serviceProvider;

  CameraPosition initialLocation = CameraPosition(
    target: LatLng(23.046, 72.675),
    zoom: 16.0,
  );

  HomeProvider() {
    _homeRepository = HomeRepository();
    _res = ApiResponse();
    _dashboardCountRes = ApiResponse();
    setInitLastLocation();

    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => callEveryTime());
  }

  callEveryTime() async {
    try{

      await serviceProvider.updateUserLoc();

    }catch(e){
      print(e);
    }

  }

  setInitLastLocation() async {
    try{
      var lastPos = await Geolocator.getLastKnownPosition();

      initialLocation = CameraPosition(
        target: LatLng(lastPos.latitude ?? 0.0, lastPos.longitude ?? 0.0),
        zoom: 16.0,
      );
    }catch(e){
      print('Location Error' + e.toString());
    }

  }

  Future sendReqToAll(String desc,Function(ApiResponse res) action) async {
    _multipleUserReq = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      var res = await _homeRepository.sendRequestToUser(requestUser, desc);

      if (res.status != 1) {
        throw res.message ?? 'Server Error';
      }
      _multipleUserReq = ApiResponse.completed(res);
      notifyListeners();
      action(_multipleUserReq);
    } catch (e) {
      _multipleUserReq = ApiResponse.error('${e.toString()}');
      notifyListeners();
      action(_multipleUserReq);
    }
  }

  Future getResponse({bool isLoading,String searchText,Function(ApiResponse<ResDashboardLatLong>, int) completion}) async {
    if(isLoading ?? true){
      _res = ApiResponse.loading('Fetching');
    }
    notifyListeners();
    int resStatus = 0;
    try {
      ResDashboardLatLong res =
          await _homeRepository.fetchUsers(lat: searchedLat, lon: searchedLon, txt: searchText);
      resStatus = res.status;
      if (res.status != 1) {
        throw res.message ?? 'Server Error';
      }
      _res = ApiResponse.completed(res);

      requestUser = res.data.userList.map((e) => e.id).join(",");

      await addMarkers(homeContext);
      notifyListeners();
    } on PlatformException catch (err) {
      FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: err,stack: StackTrace.current));
      // await FirebaseCrashlytics.instance.recordError(err, StackTrace.current,reason: 'Platform Error Mainly Location Based');
    }
    catch (e) {
      _res = ApiResponse.error('${e.toString()}');
      completion(_res, resStatus);
      notifyListeners();
    }
  }

  Future getDashBoardCount() async{
    _dashboardCountRes = ApiResponse.loading('Fetching');
    notifyListeners();
    try {
      ResGetDashboardCount res =
      await _homeRepository.getDashboardCount();

      if (res.status != 1) {
        throw res.message ?? 'Server Error';
      }
      _dashboardCountRes = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      _dashboardCountRes = ApiResponse.error('${e.toString()}');
      notifyListeners();
    }
  }

  Future showSentRequest() async {
    try{
      await _homeRepository.showSentRequest();
    }catch(e){
      print(e);
    }
  }

  Future showReceiveRequest() async {
    try{
      await _homeRepository.showReceiveRequest();
    }catch(e){
      print(e);
    }
  }

//Add DashBoard Markers here
  List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  Future addMarkers(BuildContext context) async {
    // _markers = [];

    List<Marker> localMarkers = [];

    var markerSize = MediaQuery.of(homeContext).size.height~/6.5;

    if(markerSize > 200){
      markerSize = 200;
    }

    //For Searched Location Marker
    final MarkerId markerId = MarkerId("Same");

    //Image
    final Uint8List centerIcon = await ImageService.getBytesFromAsset('assets/images/location_pin_theme.png', (markerSize * 0.4).toInt());

    // creating a new MARKER
    final address = await GooglePlaceService.getAddress(latitude: searchedLat,longitude: searchedLon);

    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(centerIcon),
        position: LatLng(searchedLat, searchedLon),
        markerId: markerId,
        infoWindow: InfoWindow(
          snippet: address.addressLine ?? "",
          title: 'Your Place',
        )
    );

    localMarkers.add(marker);
    // notifyListeners();

    if (res.data != null && res.data.data != null){
      //For User List Marker
      res.data.data.userList.asMap().forEach((index, element) async {
        var dataBytes;
        try {
          final _uri = Uri.parse(kImgBaseURL + (element.userProfileImage ?? ''));

          var request = await http.get(_uri);
          var bytes = request.bodyBytes;

          dataBytes = bytes;

          var myBytes = await ImageService.getBytesFromServerImage(dataBytes, 100);

          var cool = await ImageService.convertImageFileToBitmapDescriptor(myBytes,size: markerSize,
              borderColor: element.badge.getStatusColor());

          localMarkers.add(Marker(
            icon: (element.isPrivateProfile == 1) ? centerIcon : cool,
            markerId: MarkerId('user' + element.id.toString()),
            position: LatLng(
                double.parse(element.latitude), double.parse(element.longitude)),
            infoWindow: InfoWindow(
                title: (element.isPrivateProfile == 1) ? (element.publicName ?? "Anonymous") : (element.firstName ?? "") + ' ' + (element.lastName ?? ""),
                onTap: () {
                  selectedUserFromMarker = element.id;
                  Navigator.pushNamed(context, kOtherUserProfileRoute).then((value) {
                    getDashBoardCount();
                  });
                }),
          ));

        } catch (e) {
          final Uint8List placeholderIcon = await ImageService.getBytesFromAsset('assets/images/userPlaceHolder.png', (markerSize).toInt());

          var cool = await ImageService.convertImageFileToBitmapDescriptor(placeholderIcon,size: markerSize,
              borderColor: element.badge.getStatusColor());

          localMarkers.add(Marker(
            icon: cool,
            markerId: MarkerId(element.id.toString()),
            position: LatLng(
                double.parse(element.latitude), double.parse(element.longitude)),
            infoWindow: InfoWindow(
                title: (element.isPrivateProfile == 1) ? (element.publicName ?? "Anonymous") : (element.firstName ?? "") + ' ' + (element.lastName ?? ""),
                onTap: () {
                  selectedUserFromMarker = element.id;
                  Navigator.pushNamed(context, kOtherUserProfileRoute).then((value) {
                    getDashBoardCount();
                  });
                }),
          ));
        }

      });

      //For Places Marker
      final Uint8List markerIcon = await ImageService.getBytesFromAsset('assets/images/place_icon_red.png', (markerSize * 0.6).toInt());

      res.data.data.imageGroup.asMap().forEach((index,element) {
        if (element.isNotEmpty) {
          print('id is: ${element.first.id}');
          localMarkers.add(
            Marker(
                icon: BitmapDescriptor.fromBytes(markerIcon),
                markerId: MarkerId('place' + element.first.id.toString()),
                position: LatLng(double.parse(element.first.latitude),
                    double.parse(element.first.longitude)),
                infoWindow: InfoWindow(
                    snippet: element.first.imagePlaceName,
                    title: 'Nearby Places',
                    onTap: (){
                      selectedPlaceIndex = index;
                      Navigator.pushNamed(context, kLocationProfileGridRoute);
                    }
                )),
          );
        }
      });
    }

    _markers = [];

    _markers = localMarkers;

    notifyListeners();
  }
}
