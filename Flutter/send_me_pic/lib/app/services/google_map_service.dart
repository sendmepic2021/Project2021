import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/repository/home_repository.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/providers/service_provider.dart';
import 'package:send_me_pic/app/screens/location_pick_screen.dart';
import 'package:send_me_pic/app/services/firebase_config.dart';
import 'package:send_me_pic/app/services/location_service.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'dart:ui';

const kGoogleApiKey = "AIzaSyCUGn858ApHn-K4r2IyXy3heknE5iP6ORM";//"AIzaSyDyacG6HZnFFu8leSq8Egxe3MNkBJEkfT8";

class GooglePlaceService{

  static Future<Address> getAddress({double latitude, double longitude}) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));

    print('Address:');
    print(addresses.first.subLocality);

    Address address = addresses.first;

    return address;
  }

  static Future<void> onLocationSearchBtn(BuildContext context,{Function(LatLng) completion}) async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: (txt) {
          print(txt);
        },
        mode: Mode.overlay,
        language: 'en',
      );
      _displayPrediction(p,completion: completion);
    } catch (e) {
      print(e);
      return;
    }
  }

  static Future<Null> _displayPrediction(Prediction p, {Function(LatLng) completion}) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      final lat = detail.result.geometry.location.lat;
      final lon = detail.result.geometry.location.lng;

      completion(LatLng(lat,lon));

    }
  }

}