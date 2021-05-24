import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/screens/dashboard_screen.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/screens/sign_in_screen.dart';
import 'package:send_me_pic/app/screens/splash_screen.dart';
import 'package:send_me_pic/app/services/firebase_config.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class LendingPage extends StatefulWidget {
  @override
  _LendingPageState createState() => _LendingPageState();
}

class _LendingPageState extends State<LendingPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callInitialApi();
  }

  callInitialApi(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AuthProvider>(context, listen: false);

      provider.firstApi(completion: (){
        try{
          CustomPopup(context, title: 'New Update', message: 'New update is available, please update this app', primaryBtnTxt: 'Go!',primaryAction: () async {
            try{
              await canLaunch(kApplicationUrl) ? await launch(kApplicationUrl) : print('Could not launch $kApplicationUrl');
            }catch(e){
              print(e);
            }
          });
        }catch(e){
          print(e);
        }

      },onError: (err){
        CustomPopup(context, title: 'Error', message: err, primaryBtnTxt: 'Re-Try!',primaryAction: () async {
          callInitialApi();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // return SplashScreen();

    return Consumer<AuthProvider> (
      builder: (_, auth, __) {

        if(auth.isAppUnderMaintenance){
          return Scaffold(body: NoDataFoundContainer(title: 'Under Maintenance',reason: 'This App is Under Maintenance, \n Sorry for the inconvenience',));
        }

        if(!auth.splashScreenLoaded){
          return SplashScreen();
        }else if (auth.isLogin != null){
          print(auth.isLogin);
          return auth.isLogin ? MessageHandler(child: DashboardScreen(),) : SignInScreen();
        }else{
          auth.getUserFromLocal();
          return Container(
            color: Colors.white,
          );
        }
      },
    );
  }
}
