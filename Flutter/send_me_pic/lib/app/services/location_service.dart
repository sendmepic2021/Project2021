import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService{

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static UserLocation _currentLocation;
  static var location = Location();

  static Future<UserLocation> getLocation() async {
    print('Started Location');
    try {

      var userLocation = await Geolocator.getCurrentPosition().timeout(Duration(seconds: 5));

      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      print('Completed Location');
    } catch (e) {
      print('ERROR Location');
      print('Could not get location: ${e.toString()}');

      try{
        print('called 2');
        var userLocation2 = await location.getLocation().timeout(Duration(seconds: 5));
        _currentLocation = UserLocation(
          latitude: userLocation2.latitude,
          longitude: userLocation2.longitude,
        );
      }catch(e){
        return await getLastLocation();
      }
    }
    return _currentLocation;
  }

  static Future<UserLocation> getLastLocation() async {
    try {
      var userLocation = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);

      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      return _currentLocation;
    } catch (e) {
      print('Could not get Last location: ${e.toString()}');
      rethrow;
    }
  }

}
class UserLocation {
  final double latitude;
  final double longitude;
  UserLocation({this.latitude, this.longitude});
}