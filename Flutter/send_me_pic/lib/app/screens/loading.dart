import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,//kPrimaryColor,
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
        ));
  }
}
