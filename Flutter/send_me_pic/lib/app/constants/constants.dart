import 'dart:io';

import 'package:flutter/material.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';

//URL
String kApplicationUrl = "https://42ld7.app.link/SendMePic";//Platform.isIOS ? "https://apps.apple.com/us/app/sendmepic/id1564025954" : "https://play.google.com/store/apps/details?id=com.sqt.send_me_pic";

// String kBaseUrlGetter = 'http://qa.sendmepic.me/api/v1/get_base_url';

String kBaseUrlGetter = 'http://app.sendmepic.me/api/v1/get_base_url';

// String kBaseUrlGetter = 'http://sendmepic.me/api/v1/get_base_url';

String kImgBaseURL = "";
String kBaseURL = "http://app.sendmepic.me/api/v1/";

String kLoginPath = "login";
String kGetUserByIdPath = "getUserbyid";
String kLogoutPath = "logout";
String kUpdateProfilePath = "user_update_profile_by_id";
String kGetUsersFromLocationPath = "get_user_details_by_lat_long";
String kBaseURLPath = "get_base_url";
String kSendImageRequestPath = "send_request_user_for_image";
String kGetAllSentRequestPath = "get_all_request_by_sender";
String kGetAllReceivedRequestPath = "get_all_request_by_receiver";
String kGetRequestDetailsPath = "get_request_detail_by_id";
String kUpdateStatusPath = "update_status_by_id";
String kUploadImageBySenderPath = 'upload_image_by_sender';
String kUpdateNotificationPath = 'update_notification';
String kGetNotificationListPath = 'get_notification_by_user_id';
String kSendMultipleRequestToUserPath = 'send_multiple_request_user_for_image';
String kUpdateUserLocationPath = 'update_user_location';
String kGetCmsPagesPath = 'get_cms_pages';
String kGetCurrentVersion = 'get_current_version';
String kgetDashboardCount = 'getDashboardCount';
String kDeleteImage = 'deleteImage';
String kUpdateNotificationStatusById = 'updateNotificationStatusById';
String kShowSentRequest = 'showSentRequest';
String kShowReceiveRequest = 'showReceiveRequest';

//Colors
Color kPrimaryColor = HexColor.fromHex('#222f3e');//HexColor.fromHex('#144E5A');
Color kThemeRedColor = HexColor.fromHex('#D8232A');//HexColor.fromHex('#E30613');
Color kSignInBGColor = Colors.white;//HexColor.fromHex('#FFF4E7');
Color kSignInGoogleColor = HexColor.fromHex('#DC4639');
Color kSignInFacebookColor = HexColor.fromHex('#3B5998');
Color kSignInAppleColor = HexColor.fromHex('#000000');
Color kMapBTNsColor = HexColor.fromHex('#D8232A');//HexColor.fromHex('#E30613');//HexColor.fromHex('#E38346');
Color kPinkBTNColor = HexColor.fromHex('#FC7575');
Color kPlatinumColor = HexColor.fromHex('#dfe6e9');
Color kGoldColor = HexColor.fromHex('#FFDE6D');
Color kSilverColor = HexColor.fromHex('#C0C0C0');
Color kBronzeColor = HexColor.fromHex('#E38346');


//Fonts
String kRegularFonts = "Futura PT";

//Routes
String kInitialRoute = '/';
String kSplashRoute = '/splash';
String kSignInRoute = '/signIn';
String kDashboardRoute = '/dashboard';
String kSettingsRoute = '/settings';
String kProfileRoute = '/profile';
String kUpdateProfileRoute = '/updateProfile';
String kNotificationListRoute = '/notificationList';
String kCMSPageListRoute = '/cmsPage';
String kOtherUserProfileRoute = '/otherUserProfile';
String kLocationProfileGridRoute = '/locationProfile';
String kSearchListRoute = '/searchList';
String kRequestSentGridRoute = '/requestSent';
String kRequestDetailReceivedRoute = '/requestDetailReceiver';
String kRequestDetailSentRoute = '/requestDetailSent';
String kRequestedImageRoute = '/imagesScreen';
String kRequestReceivedGridRoute = '/requestReceived';
String kCameraRoute = '/camera';
String kEnterDescriptionRoute = '/enterDescription';
String kImageSelectionRoute = '/selectImage';


String kPlaceHolderBaseUrl = 'https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png';

//Decorations
const kRoundedTextFieldDecoration = InputDecoration(
  hintText: 'Value',
  hintStyle: TextStyle(
      color: Colors.black54
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.black38, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.black54, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);