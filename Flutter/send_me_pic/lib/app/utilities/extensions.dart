import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

var emailRegex =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
var nameRegex = r'[0–9]';

extension ExtendedString on String {
  bool get isValidName {
    return !this.contains(new RegExp(nameRegex));
  }

  bool get isValidEmail {
    return this.contains(new RegExp(emailRegex));
  }

  bool get isValidMobile {
    return this.length >= 7 && this.length <= 13;
  }

  bool get isValidPassword {
    return this.length >= 8;
  }

  Color get getHexColor {
    try {
      var hexColor = this.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      if (hexColor.length == 8) {
        return Color(int.parse("0x$this"));
      } else {
        return Colors.black;
      }
    } catch (e) {
      print("error getting hash code: " + this);
      return Colors.black;
    }
  }

  int parseInt() {
    try {
      return int.parse(this);
    } catch (err) {
      return 0;
    }
  }

  double parseDouble() {
    try {
      return double.parse(this);
    } catch (err) {
      return 0.0;
    }
  }

  String get formatDate => formatDateTxt(input: this);

}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

String formatDate({ @required DateTime myDate, String format}) {
  format ??= 'MMM d, yyyy HH:mm';

  try {
    return DateFormat(format).format(myDate);
  } catch (e) {
    return 'Wrong Date Format';
  }
}

String formatDateTxt({@required String input, String toFormat, String fromFormat}){
  fromFormat ??= "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
  toFormat ??= 'MMM d, yyyy hh:mm a';

  try {
    DateTime parseDate = DateFormat(fromFormat).parse(input);
    return DateFormat(toFormat).format(parseDate);
  } catch (e) {
    return 'Wrong Date Format';
  }
}

extension Date on DateTime {
  String formatDate(){
    try {
      String formattedDate = DateFormat('MMM d, yyyy hh:mm a').format(this);
      return formattedDate;
    } catch (e) {
      return 'Wrong Date Format';
    }
  }
}