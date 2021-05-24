import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/providers/service_provider.dart';
import 'package:send_me_pic/app/screens/location_pick_screen.dart';
import 'package:send_me_pic/app/services/google_map_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'dart:ui';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.0,
  );

  bool isLoading = false;

  String profileUrl =
      'https://st4.depositphotos.com/4329009/19956/v/600/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg';

  Future _goToCurrentLoc() async {
    setState(() {
      isLoading = true;
    });

    try {
      var loc = await LocationService.getLocation();
      getMarkerDataFromLoc(latLng: LatLng(loc.latitude, loc.longitude));
    } catch (e) {
      print('Error is : $e');

      // var loc = await LocationService.getLocation().timeout(Duration(seconds: 10));
      // getMarkerDataFromLoc(latLng: LatLng(loc.latitude, loc.longitude));

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  getMarkerDataFromLoc({LatLng latLng}) async {
    final GoogleMapController controller = await _controller.future;
    var pos = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 15.0,
      tilt: 90.0
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(pos));

    final provider = Provider.of<HomeProvider>(context, listen: false);

    provider.searchedLat = latLng.latitude;
    provider.searchedLon = latLng.longitude;

    provider.getResponse(
        searchText: '',
        completion: (res, status) {
          CustomPopup(context,
              title: '${status == 2 ? 'Unauthorized' : 'Error'}',
              message: '${status == 2 ? 'You are unauthorised please try re-login.' : (res.msg ?? '')}',
              primaryBtnTxt: 'OK', primaryAction: () async {
            if (status == 2) {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logOutUser();
            }
          });
        });
  }

  @override
  void initState() {
    // FirebaseConfig.configNotificationHandle(context);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.homeContext = context;
      fetchDashboardCount();

      await _goToCurrentLoc();

      // final serviceProvider =
      //     Provider.of<ServiceProvider>(context, listen: false);
      // serviceProvider.updateUserLoc();
       try{
         await provider.serviceProvider.updateUserLoc();
       }catch(e){

         final local = await UserPreferences().getUser();

         await FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: Exception('${e.toString()} for user ${local.id}, ${local.email}'),stack: StackTrace.current));
       }
    });
  }

  fetchDashboardCount() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    await provider.getDashBoardCount();
  }

  Future _getImgUrl() async {
    var user = await UserPreferences().getUser();

    setState(() {
      profileUrl = kImgBaseURL + (user.userImage ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    _getImgUrl();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'SendMePic',
        ),
        leading: Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(95, 95, 95, 0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ]),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(kProfileRoute);
              },
              child: Hero(
                tag: 'profileImage',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CustomNetWorkImage(url: profileUrl,assetName: 'assets/images/userPlaceHolder.png',),
                ),
              ),
            )),
        actions: [
          settingIconBuilder(context),
          SizedBox(width: 10),
          notificationIconBuilder(context),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(homeProvider.markers),
              onTap: (argument) {
                getMarkerDataFromLoc(latLng: argument);
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                if (!homeProvider.controller.isCompleted) {
                  homeProvider.controller.complete(controller);
                }
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
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                GooglePlaceService.onLocationSearchBtn(
                                  context,
                                  completion: (latLng) {

                                    getMarkerDataFromLoc(latLng: latLng);
                                  },
                                );
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 20),
                                // width: double.infinity,
                                child: Opacity(
                                  opacity: 0.35,
                                  child: Text(
                                    'Search Here...',
                                    style: TextStyle(
                                        color: kPrimaryColor, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (false)
                            Container(
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
                                width: 44,
                                height: double.infinity,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.map,
                                    color: kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => LocationPickScreen(
                                        pickLocation: (target) async {
                                          var pos = CameraPosition(
                                              target: target, zoom: 20.0);

                                          getMarkerDataFromLoc(
                                              latLng: pos.target);
                                        },
                                      ),
                                    ));
                                  },
                                ))
                        ],
                      ),
                    ),

                    newBottomBar()

                    // bottomBar()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Center notificationIconBuilder(BuildContext context) {
    return Center(
          child: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(44)),
            child: IconButton(
              splashColor: Colors.white.withOpacity(0.5),
              onPressed: () {
                Navigator.pushNamed(context, kNotificationListRoute)
                    .then((value) {
                  fetchDashboardCount();
                });
              },
              icon: Consumer<HomeProvider>(builder: (_, provider, __) {
                int count = 0;

                switch (provider.dashboardCountRes.state) {
                  case Status.LOADING:
                    count = 0;
                    break;
                  case Status.COMPLETED:
                    final data = provider.dashboardCountRes.data.data;
                    count = data.userNotificationCount;
                    break;
                  case Status.ERROR:
                    count = 0;
                    break;
                }
                return Stack(
                  children: [
                    Center(
                      child: Container(
                          width: 20,
                          child: Image.asset(
                              'assets/images/notification_bell.png',
                              height: 18)),
                    ),
                    if (count != 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 10,
                          width: 10,
                          // child: Center(
                          //   child: Text(
                          //     "${count < 10 ? count : "9+"}",
                          //     style: TextStyle(
                          //         fontSize: 12, color: Colors.white),
                          //     maxLines: 1,
                          //   ),
                          // ),
                          decoration: BoxDecoration(
                              color: kThemeRedColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                  ],
                );
              }),
            ),
          ),
        );
  }

  Center settingIconBuilder(BuildContext context) {
    return Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(44)),
            child: IconButton(
                splashColor: Colors.white.withOpacity(0.5),
                onPressed: () {
                  Navigator.pushNamed(context, kSettingsRoute);
                },
                icon: Container(
                    width: 20,
                    child: Image.asset('assets/images/settings.png',
                        height: 18))),
          ),
        );
  }

  Widget newBottomBar() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<HomeProvider>(
            builder: (_, provider, __) {
              int sentCount = 0;
              int receivedCount = 0;

              switch (provider.dashboardCountRes.state) {
                case Status.LOADING:
                  sentCount = 0;
                  receivedCount = 0;
                  break;
                case Status.COMPLETED:
                  final data = provider.dashboardCountRes.data.data;
                  sentCount = data.sendReqCount;
                  receivedCount = data.receiveReqCount;
                  break;
                case Status.ERROR:
                  sentCount = 0;
                  receivedCount = 0;
                  break;
              }

              var resIsLoading = false;
              switch (provider.res.state) {
                case Status.LOADING:
                  resIsLoading = true;
                  break;
                case Status.COMPLETED:
                  resIsLoading = false;
                  break;
                case Status.ERROR:
                  resIsLoading = false;
                  break;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _mapFloatingBTNs(
                      icon: !isLoading
                          ? Image.asset(
                              'assets/images/map_floating_location.png',
                              height: 22,
                            )
                          : Container(
                              padding: EdgeInsets.all(7.5),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )),
                      onTap: !isLoading
                          ? () {
                              if (resIsLoading) {
                                return;
                              }
                              _goToCurrentLoc();
                            }
                          : null),

                  //Received
                  SizedBox(height: 10),
                  _requestFloatingBTNs(
                      icon: Image.asset(
                        "assets/images/send_req.png",
                        color: Colors.white,
                        width: 20,
                      ),
                      badge: receivedCount,
                      onTap: () {
                        provider.showReceiveRequest();
                        Navigator.pushNamed(context, kRequestReceivedGridRoute)
                            .then((value) {
                          fetchDashboardCount();
                        });
                      }),
                  SizedBox(height: 10),
                  //Sent
                  _requestFloatingBTNs(
                      icon: Image.asset(
                        "assets/images/receive_req.png",
                        color: Colors.white,
                        width: 20,
                      ),
                      badge: sentCount,
                      onTap: () {
                        provider.showSentRequest();

                        Navigator.pushNamed(context, kRequestSentGridRoute)
                            .then((value) {
                          fetchDashboardCount();
                        });
                      }),
                ],
              );
            },
          ),
          Center(
            child: Consumer<HomeProvider>(
              builder: (_, provider, __) {
                var isLoading = false;
                switch (provider.res.state) {
                  case Status.LOADING:
                    isLoading = true;
                    break;
                  case Status.COMPLETED:
                    isLoading = false;
                    break;
                  case Status.ERROR:
                    isLoading = false;
                    break;
                }

                return Container(
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(22)),
                  height: 44,
                  child: isLoading
                      ? Container(
                          width: 44,
                          child: LoadingSmall(
                            size: 22,
                          ))
                      : TextButton(
                          onPressed: () {
                            if (isLoading) {
                              return;
                            }
                            Navigator.pushNamed(context, kSearchListRoute)
                                .then((value) {
                              fetchDashboardCount();
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Ask For Picture',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            Consumer<HomeProvider>(
              builder: (_, provider, __) {
                var isLoading = false;
                switch (provider.res.state) {
                  case Status.LOADING:
                    isLoading = true;
                    break;
                  case Status.COMPLETED:
                    isLoading = false;
                    break;
                  case Status.ERROR:
                    isLoading = false;
                    break;
                }
                return _mapFloatingBTNs(
                    icon: isLoading
                        ? Container(
                            height: 22,
                            width: 22,
                            child: LoadingSmall(),
                          )
                        : Image.asset(
                            'assets/images/map_floating_user_list.png',
                            height: 22,
                          ),
                    onTap: () {
                      Navigator.pushNamed(context, kSearchListRoute)
                          .then((value) {
                        fetchDashboardCount();
                      });
                    });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<HomeProvider>(builder: (_, homeProvider, __) {
              return Column(
                children: [
                  _mapFloatingBTNs(
                      icon: !isLoading
                          ? Image.asset(
                              'assets/images/map_floating_location.png',
                              height: 22,
                            )
                          : Container(
                              padding: EdgeInsets.all(7.5),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )),
                      onTap: !isLoading
                          ? () {
                              _goToCurrentLoc();
                            }
                          : null)
                ],
              );
            }),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        //Request BTNs
        Consumer<HomeProvider>(
          builder: (_, provider, __) {
            int sentCount = 0;
            int receivedCount = 0;

            switch (provider.dashboardCountRes.state) {
              case Status.LOADING:
                sentCount = 0;
                receivedCount = 0;
                break;
              case Status.COMPLETED:
                final data = provider.dashboardCountRes.data.data;
                sentCount = data.sendReqCount;
                receivedCount = data.receiveReqCount;
                break;
              case Status.ERROR:
                sentCount = 0;
                receivedCount = 0;
                break;
            }

            return Row(
              children: [
                Expanded(
                  child: _requestBTNs(
                      text: 'REQUEST SENT',
                      count: sentCount ?? 0,
                      onTap: () {
                        provider.showSentRequest();

                        Navigator.pushNamed(context, kRequestSentGridRoute)
                            .then((value) {
                          fetchDashboardCount();
                        });
                      }),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: _requestBTNs(
                      text: 'REQUEST RECEIVED',
                      count: receivedCount ?? 0,
                      onTap: () {
                        provider.showReceiveRequest();
                        Navigator.pushNamed(context, kRequestReceivedGridRoute)
                            .then((value) {
                          fetchDashboardCount();
                        });
                      }),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _mapFloatingBTNs({Widget icon, VoidCallback onTap}) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: kThemeRedColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: TextButton(
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.redAccent.withOpacity(0.5)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ))),
          onPressed: onTap,
          child: Center(
            child: icon,
          ),
        ));
  }

  Widget _requestFloatingBTNs({Widget icon, VoidCallback onTap, int badge}) {
    return Container(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(left: 5,top: 5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(0.5)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ))),
                onPressed: onTap,
                child: Center(
                  child: icon,
                ),
              )),
          if (badge > 0)
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kThemeRedColor,
                  ),
                  height: 25,
                  width: 25,
                  child: Center(
                      child: Text(
                    "$badge",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 1,
                  )),
                ))
        ],
      ),
    );
  }

  Widget _requestBTNs({String text, VoidCallback onTap, int count}) {
    return Container(
        height: 60,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: onTap,
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (count != 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kThemeRedColor,
                  ),
                  // child: Center(
                  //     child: Text(
                  //   "$count",
                  //   style: TextStyle(fontSize: 12, color: Colors.white),
                  //   maxLines: 1,
                  // )),
                ),
              ),
          ],
        ));
  }
}
