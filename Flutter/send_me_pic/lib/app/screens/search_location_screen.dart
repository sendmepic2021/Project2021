import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:send_me_pic/app/constants/constants.dart';

class SearchLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // height: 45,
          margin: EdgeInsets.all(20),
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: TextField(
            autofocus: true,
            style: TextStyle(color: kPrimaryColor, fontSize: 15),
            textInputAction: TextInputAction.search,
            onSubmitted: (text){
              Navigator.of(context).pop();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search here...",
              hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),),
          ),
        ),
      ),
    );
  }
}
