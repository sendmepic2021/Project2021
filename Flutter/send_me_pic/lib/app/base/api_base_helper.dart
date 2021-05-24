import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/user_pref.dart';

class ApiBaseHelper {
  Future<dynamic> getApi(String path) async {
    var responseJson;
    try {
      var user = await UserPreferences().getUser();

      var uri = Uri.parse(kBaseURL + path);

      print('URL: $uri');

      print('Bearer ${user.token}');

      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "access-token": 'Bearer ${user.token}',
          "userId" : '${user.id}'
        },
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw 'No Internet connection';
    } on FetchDataException{
      throw 'Issue With Fetching the Right Data';
    }catch(e){
      rethrow;
    }

    return responseJson;
  }

  Future<dynamic> getApiFromURL(String url) async {
    var responseJson;
    try {
      var user = await UserPreferences().getUser();

      var uri = Uri.parse(url);

      print('URL: $uri');
      print('Bearer ${user.token}');
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "access-token": 'Bearer ${user.token}',
          "userId" : '${user.id}'
        },
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw 'No Internet connection';
    } on FetchDataException catch(e){
      throw 'Issue With Fetching the Right Data';
    }catch(e){
      rethrow;
    }

    return responseJson;
  }

  Future<dynamic> postApi(String path, Map<String, dynamic> body) async {
    var responseJson;
    try {
      var user = await UserPreferences().getUser();

      var uri = Uri.parse(kBaseURL + path);

      print('URL: $uri, Req: $body');
      print('Bearer ${user.token}');
      final response = await http.post(
        uri,
        body: body,
        headers: {
          // HttpHeaders.contentTypeHeader: "application/json",
          "access-token": 'Bearer ${user.token}',
          "userId" : '${user.id}'
        },
      );

      print(response);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw 'No Internet connection';
    }catch(e){
      print(e);
    }

    return responseJson;
  }

  Future<dynamic> uploadImage(
      {filepath, path, Map<String, String> body,String imgName}) async {
    print(path);

    var responseJson;

    try {
      var user = await UserPreferences().getUser();

      var request = http.MultipartRequest('POST', Uri.parse(kBaseURL + path));

      if (filepath != null) {
        request.files.add(http.MultipartFile.fromBytes(
          imgName,
          File(filepath).readAsBytesSync(),
          filename: filepath.split("/").last,
        ));
      }

      request.headers.addAll({
        // HttpHeaders.contentTypeHeader: "application/json",
        "access-token": 'Bearer ${user.token}',
        "userId" : '${user.id}'
      });

      request.fields.addAll(body);

      print('body: $body');

      print(request);

      http.Response response =
          await http.Response.fromStream(await request.send());

      responseJson = _returnResponse(response);
    } on SocketException {
      print("error 0 is: ");
      throw 'No Internet connection';
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    print('Response: ${response.body}');

    try{
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseJson = jsonDecode(response.body);
        return responseJson;
      }else{
        throw 'Error occurred while Communication with Server, with StatusCode : ${response.statusCode}';
      }
    }catch(e){
      print(e);
      // throw 'Error occurred while Communication with Server, with StatusCode : ${response.statusCode}';
      rethrow;
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class ApiResponse<T> {
  Status state;
  T data;
  String msg;

  ApiResponse();

  ApiResponse.loading(this.msg) : state = Status.LOADING;

  ApiResponse.completed(this.data) : state = Status.COMPLETED;

  ApiResponse.error(this.msg) : state = Status.ERROR;

  @override
  String toString() {
    return "Status : $state \n Message : $msg \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
