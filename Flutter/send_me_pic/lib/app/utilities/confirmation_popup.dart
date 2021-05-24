import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationPopup{

  ConfirmationPopup({@required this.context,@required this.title,@required this.message,@required this.yesAction}){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            child: Text('Yes'),
            onPressed: (){
              Navigator.of(context).pop();
              yesAction();
            },
          )
        ],
      ));
    }else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              InkWell(
                child: Text('Cancel'),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              InkWell(
                child: Text('Yes'),
                onTap: (){
                  Navigator.of(context).pop();
                  yesAction();
                },
              )
            ],
          )
      );
    }
  }

  final BuildContext context;
  final String title;
  final String message;
  final VoidCallback yesAction;

}