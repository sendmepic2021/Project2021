import 'dart:io';

import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kPrimaryColor,
      body: buildContainer(_size)
    );
  }

  Container buildContainer(Size size) {

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,

      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: size.height/1.5,
              child: Image.asset('assets/images/send_me_splash_bg_white.png',fit: BoxFit.fitHeight,),
            ),
          ),
          Container(
            height: size.height/2.5,
            child: Center(
                child: Container(
                  width: size.width/2.5,
                  child: Image.asset('assets/images/SendMePicIcon.png'),)),
          ),
        ],
      ),

      // child: Center(child: Image.asset('assets/images/center_icon.png',width: 234,height: 172,)),

      // child: Center(child: LoadingSmall(size: 44,)),
    );

    if(Platform.isAndroid){
      //Android Splash

      // return Container(
      //   color: Colors.white,
      //   width: double.infinity,
      //   height: double.infinity,
      //   child: Container(
      //     width: double.infinity,
      //     height: double.infinity,
      //     child: Image.asset('assets/images/FullSplashScreen.png',fit: BoxFit.contain,),
      //   ),
      // );

      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,

        child: Stack(
          children: [
            // Container(
            //   child: Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: Image.asset('assets/images/SplashBGColor.png',fit: BoxFit.fitHeight,),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: size.height/1.5,
                child: Image.asset('assets/images/send_me_splash_bg_white.png',fit: BoxFit.fitHeight,),
              ),
            ),
            Container(
              height: size.height/2.5,
              child: Center(
                  child: Container(
                    width: size.width/3,
                    child: Image.asset('assets/images/SendMePicIcon.png'),)),
            ),
          ],
        ),

        // child: Center(child: Image.asset('assets/images/center_icon.png',width: 234,height: 172,)),

        // child: Center(child: LoadingSmall(size: 44,)),
      );

      return Container(
        color: kPrimaryColor,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: double.infinity,
                child: Image.asset(
                  'assets/images/only_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
                child: Image.asset(
                  'assets/images/only_logo.png',
                  width: 240,
                )),
          ],
        ));
    }else{
      //IOS Splash
      // return Container(
      //   color: Colors.white,
      //   width: double.infinity,
      //   height: double.infinity,
      //   child: Container(
      //     width: double.infinity,
      //     height: double.infinity,
      //     child: Image.asset('assets/images/FullSplashScreen.png',fit: BoxFit.contain,),
      //   ),
      // );

      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,

        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: size.height/1.5,
                child: Image.asset('assets/images/send_me_splash_bg_white.png',fit: BoxFit.fitHeight,),
              ),
            ),
            Container(
              height: size.height/2.5,
              child: Center(
                  child: Container(
                    width: size.width/3,
                    child: Image.asset('assets/images/SendMePicIcon.png'),)),
            ),
          ],
        ),

        // child: Center(child: Image.asset('assets/images/center_icon.png',width: 234,height: 172,)),

        // child: Center(child: LoadingSmall(size: 44,)),
      );
    }
  }
}
