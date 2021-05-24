import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/services/google_map_service.dart';
import 'package:send_me_pic/app/services/image_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class LocationPickScreen extends StatefulWidget {

  Function(LatLng) pickLocation;

  LocationPickScreen({this.pickLocation});

  @override
  _LocationPickScreenState createState() => _LocationPickScreenState();
}

class _LocationPickScreenState extends State<LocationPickScreen> {
  Completer<GoogleMapController> _controller = Completer();

  String address = "";
  var setLat = 0.0;
  var setLon = 0.0;

  getAddress({double latitude, double longitude}) async {
    final addressRes = await GooglePlaceService.getAddress(latitude: latitude,longitude: longitude);
    setLat = latitude;
    setLon = longitude;
    _add(LatLng(latitude, longitude));
    setState(() {
      address = addressRes.subLocality ?? "";
    });

    // return addresses.first;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add(LatLng pos) async{
    var markerSize = MediaQuery.of(context).size.width~/4;
    final MarkerId markerId = MarkerId("Same");

    //Image

    if(markerSize > 100){
      markerSize = 100;
    }

    final Uint8List markerIcon = await ImageService.getBytesFromAsset('assets/images/location_pin.png', (markerSize * 0.6).toInt());

    // creating a new MARKER
    final Marker marker = Marker(
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: pos,
      markerId: markerId,
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 20.0,
  );

  @override
  void initState() {
    _goToCurrentLoc();
    super.initState();
  }

  _goToCurrentLoc() async {

    final GoogleMapController controller = await _controller.future;

    var loc = await LocationService.getLocation();

    var pos =
    CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 20.0);

    controller.animateCamera(CameraUpdate.newCameraPosition(pos));

    getAddress(latitude: loc.latitude,longitude: loc.longitude);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMapBTNsColor,
        child: Image.asset(
          'assets/images/map_floating_location.png',
          height: 22,
        ),
        onPressed: (){
          _goToCurrentLoc();
        },
      ),
      body: Container(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(markers.values),
                onTap: (argument) {
                  getAddress(latitude: argument.latitude,longitude: argument.longitude);
                },
                onCameraMove: (position) {
                  // print(position);
                  // getAddress(latitude: position.target.latitude,longitude: position.target.longitude);
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                },
              ),

              //Buttons
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //SearchBar
                      Container(
                        height: 44,
                        width: double.infinity,
                        child: InkWell(
                          onTap: () async {
                            GooglePlaceService.onLocationSearchBtn(context,completion: (latLng) async {
                              var pos = CameraPosition(target: latLng, zoom: 20.0);

                              final GoogleMapController controller = await _controller.future;

                              controller.animateCamera(CameraUpdate.newCameraPosition(pos));

                              getAddress(latitude: latLng.latitude,longitude: latLng.longitude);
                            },);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[200]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(95, 95, 95, 0.1),
                                    spreadRadius: 10,
                                    blurRadius: 30,
                                    offset: Offset(0, 0),
                                  ),
                                ]),
                            padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                            // width: double.infinity,
                            child: Opacity(
                              opacity: 0.35,
                              child: Text(
                                'Search Here...',
                                style:
                                TextStyle(color: kPrimaryColor, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(right: 80),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Address: $address'),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    child: TextButton(
                                      onPressed: () {
                                        widget.pickLocation(LatLng(setLat, setLon));
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Pick',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Center(
              //   child: Icon(Icons.location_pin,size: 30,color: kPrimaryColor,)
              // )

            ],
          ),
      ),
    );
  }
}
