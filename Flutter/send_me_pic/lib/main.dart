import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/providers/service_provider.dart';
import 'package:send_me_pic/app/providers/settings_provider.dart';
import 'package:send_me_pic/app/providers/user_profile_provider.dart';
import 'package:send_me_pic/app/screens/camera_screen.dart';
import 'package:send_me_pic/app/screens/dashboard_screen.dart';
import 'package:send_me_pic/app/screens/enter_description_screen.dart';
import 'package:send_me_pic/app/screens/image_pageview_screen.dart';
import 'package:send_me_pic/app/screens/image_select_screen.dart';
import 'package:send_me_pic/app/screens/lending_page.dart';
import 'package:send_me_pic/app/screens/location_photos_grid_screen.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/screens/notification_list_screen.dart';
import 'package:send_me_pic/app/screens/other_user_profile_screen.dart';
import 'package:send_me_pic/app/screens/received_request_list_screen.dart';
import 'package:send_me_pic/app/screens/request_detail_screen.dart';
import 'package:send_me_pic/app/screens/request_sent_detail_screen.dart';
import 'package:send_me_pic/app/screens/search_list_screen.dart';
import 'package:send_me_pic/app/screens/sent_request_list_screen.dart';
import 'package:send_me_pic/app/screens/settings_screen.dart';
import 'package:send_me_pic/app/screens/sign_in_screen.dart';
import 'package:send_me_pic/app/screens/splash_screen.dart';
import 'package:send_me_pic/app/screens/update_user_profile_screen.dart';
import 'package:send_me_pic/app/screens/user_profile_details_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:send_me_pic/app/services/firebase_config.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseConfig.FCMToken = await messaging.getToken(
    vapidKey: "BPzK7hEzmTIvIkgU8AA7Trj9Gc7CIW6JFzJer7TdjwSYbErdCN2smxEFAMf5sFA35nRFLCuX7RM8dF2yNfRloMs",
  );

  // FirebaseConfig.FCMToken = "cool";

  print("FCM Token is: " + FirebaseConfig.FCMToken);

  print('User granted permission: ${settings.authorizationStatus}');

  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}


class MyApp extends StatelessWidget {
  static final facebookAppEvents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    print('cool');
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    return buildMultiProvider();
  }

  Widget buildMultiProvider() {
    return OverlaySupport(
      child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => HomeProvider(),
        // ),
        ChangeNotifierProvider(
          create: (_) => UserProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceProvider(),
        ),
        ChangeNotifierProxyProvider<ServiceProvider,HomeProvider>(create: (_) => HomeProvider(), update: (_, myModel, myNotifier){
          myNotifier.serviceProvider = myModel;
          return myNotifier;
        }),
      ],
      child: MaterialApp(
        title: 'Send  Me Pic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kRegularFonts,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
              centerTitle: true,
              backwardsCompatibility: false,
              titleTextStyle: TextStyle(
                  fontFamily: kRegularFonts,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              systemOverlayStyle: Platform.isAndroid ?
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness:Brightness.dark ,
                systemNavigationBarIconBrightness: Brightness.dark,
              ) : SystemUiOverlayStyle.dark
          ),
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: kInitialRoute,
        routes: {
          kInitialRoute: (context) => LendingPage(),
          kSplashRoute: (context) => SplashScreen(),
          kSignInRoute: (context) => SignInScreen(),
          kDashboardRoute: (context) => DashboardScreen(),
          kSettingsRoute: (context) => SettingsScreen(),
          kProfileRoute: (context) => UserProfileDetailsScreen(),
          kUpdateProfileRoute: (context) => UpdateUserProfileScreen(),
          kNotificationListRoute: (context) => NotificationListScreen(),
          // kCMSPageListRoute: (context) => CMSScreen(type: CMSType.terms,),
          kOtherUserProfileRoute: (context) => OtherUserProfileScreen(),
          kLocationProfileGridRoute: (context) => LocationPhotosScreen(),
          kSearchListRoute: (context) => SearchListScreen(),
          kRequestSentGridRoute: (context) => SentRequestListScreen(),
          kRequestDetailReceivedRoute: (context) => RequestDetailScreen(),
          kRequestedImageRoute: (context) => ImagePageViewScreen(),
          kRequestReceivedGridRoute: (context) => ReceivedRequestListPage(),
          kCameraRoute: (context) => CameraScreen(),
          kEnterDescriptionRoute: (context) => EnterDescriptionScreen(),
          kRequestDetailSentRoute: (context) => RequestDetailSentScreen(),
          kImageSelectionRoute: (context) => ImageSelection(),
        },
      ),
  ),
    );
  }
}
