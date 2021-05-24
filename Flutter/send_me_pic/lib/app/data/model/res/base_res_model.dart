import 'package:flutter/cupertino.dart';

// class BaseResModel{
//  int status;
//  String message;
// }

abstract class BaseRes<T> {
  int status;
  String message;
  final T data;

  BaseRes({@required this.data});
}

class CommonRes {
  final int status;
  final String message;

  CommonRes({this.status, this.message});

  factory CommonRes.fromJson(Map<String, dynamic> json) {
    return CommonRes(
      message: json['message'],
      status: json['status'],
    );
  }
}
