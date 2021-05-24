import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/main.dart';

class FirebaseConfig{

  static String FCMToken = "";

  static bool isFromNotification = false;

  static Map<String,dynamic> data;

}

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  Widget child;
  @override
  void initState() {
    super.initState();
    child = widget.child;

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    //   if (message != null && message.data != null) {
    //     handleNotification(message.data, context);
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channel.description,
    //             // TODO add a proper drawable resource to android, for now using
    //             //      one that already exists in example app.
    //             icon: 'launch_background',
    //           ),
    //         ));
    //   }
    //   fetchDashboardCount();
    // });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      handleNotification(message.data, context);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if(Platform.isAndroid){
        if (message.notification != null) {
          showOverlayNotification((context) {
            return SafeArea(
              child: TextButton(
                onPressed: (){
                  handleNotification(message.data, context);
                  OverlaySupportEntry.of(context).dismiss();
                },
                child: Card(
                  color: kPrimaryColor,
                  margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(message.notification.title,style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.start,maxLines: 1),
                              Text(message.notification.body,style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.start,maxLines: 2)
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){
                              OverlaySupportEntry.of(context).dismiss();
                            }, icon: Icon(Icons.close,color: Colors.white,size: 20,)),
                            Text('Open',style: TextStyle(color: Colors.white, fontSize: 14),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, duration: Duration(milliseconds: 4000));
        }
      }
      fetchDashboardCount();
    });

    handleOutsideNotification();

  }

  Future handleOutsideNotification() async{
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null && initialMessage.data != null){
      print('Message data: ${initialMessage.data}');
      handleNotification(initialMessage.data, context);
    }
  }

  static handleNotification(Map<String,dynamic> data, BuildContext context) async {

    print(data);

    try{
      // Navigator.of(context).popUntil(ModalRoute.withName(kDashboardRoute));
      // Navigator.of(context).pushNamed(kDashboardRoute);

      var json = NotificationData.fromJson(data);

      final reqProvider = Provider.of<RequestProvider>(context,listen: false);

      final provider = Provider.of<HomeProvider>(context, listen: false);

      reqProvider.selectedReceivedReqDetail = int.parse(json.reqId);

      switch(int.parse(json.screenId)){
        case 1:
          Navigator.of(context).pushNamed(kRequestReceivedGridRoute).then((value) async {
            await provider.getDashBoardCount();
          });;
          Navigator.of(context).pushNamed(kRequestDetailReceivedRoute);
          break;
        case 2:
          Navigator.of(context).pushNamed(kRequestSentGridRoute).then((value) async {
            await provider.getDashBoardCount();
          });
          Navigator.of(context).pushNamed(kRequestDetailSentRoute);
          break;
        default:
          Navigator.of(context).pushNamed(kNotificationListRoute).then((value) async {
            await provider.getDashBoardCount();
          });;
          break;
      }
      reqProvider.updateNotificationStatusById(int.parse(json.notificationId));


      await provider.getDashBoardCount();

      // RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      FirebaseMessaging.instance.setAutoInitEnabled(false);

    }catch(e){
      print("Error: $e");
      Navigator.of(context).pushNamed(kNotificationListRoute);
    }
  }


  fetchDashboardCount() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    await provider.getDashBoardCount();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}


class NotificationData{
  final String reqId;
  final String screenId;
  final String notificationId;

  NotificationData({this.reqId, this.screenId, this.notificationId});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        reqId: json['request_id'],
        screenId: json['screen_id'],
        notificationId: json['notification_id']);
  }
}
