import 'dart:ui';

import 'package:send_me_pic/app/constants/constants.dart';

enum LoginType{
  facebook,
  google,
  apple
}

extension LoginTypeEnumration on LoginType{
  int _value(){
    switch(this){
      case LoginType.facebook:
        return 3;
        break;
      case LoginType.google:
        return 4;
        break;
      case LoginType.apple:
        return 5;
        break;
      default:
        return 0;
        break;
    }
  }

  int get getValue => this._value();
}

enum PlatformEnum{
  iOS,
  Android
}

extension PlatformEnumration on PlatformEnum{
  int _value(){
    switch(this){
      case PlatformEnum.iOS:
        return 7;
        break;
      case PlatformEnum.Android:
        return 6;
        break;
      default:
        return 0;
        break;
    }
  }

  int get getValue => this._value();
}

enum UserBadge{
  Default,
  Bronze,
  Silver,
  Gold,
}

extension UserStatus on UserBadge{

  Color getStatusColor(){
    return kPrimaryColor;
    switch(this){
      case UserBadge.Default:
        return kPrimaryColor;
        break;
      case UserBadge.Bronze:
        return kBronzeColor;
        break;
      case UserBadge.Silver:
        return kSilverColor;
        break;
      case UserBadge.Gold:
        return kGoldColor;
        break;
    }
    return kPrimaryColor;
  }

  static UserBadge getBadgeStatus(int id){
    switch(id){
      case 18:
        return UserBadge.Default;
        break;
      case 19:
        return UserBadge.Bronze;
        break;
      case 20:
        return UserBadge.Silver;
        break;
      case 21:
        return UserBadge.Gold;
        break;
      default:
        return UserBadge.Default;
        break;
    }
  }
}

enum ImageStatus{
  Confirm,
  Rejected,
  Complete,
  Pending
}

extension ImgStatus on ImageStatus{

  String getStatusColor(){
    switch(this){
      case ImageStatus.Confirm:
        return "#3498db";//#6a89cc
        break;
      case ImageStatus.Rejected:
        return "#ff7979";
        break;
      case ImageStatus.Complete:
        return "#b8e994";
        break;
      case ImageStatus.Pending:
        return "#FFDE6D";
        break;
    }
    return "#FFDE6D";

}

  String getString(){
    switch(this){
      case ImageStatus.Confirm:
        return "Confirmed";
        break;
      case ImageStatus.Rejected:
        return "Rejected";
        break;
      case ImageStatus.Complete:
        return "Completed";
        break;
      case ImageStatus.Pending:
        return "Pending";
        break;
    }
    return "Pending";
  }

  static ImageStatus getImgStatus(String id){
    switch(id){
      case "11":
        return ImageStatus.Pending;
        break;
      case "12":
        return ImageStatus.Confirm;
        break;
      case "13":
        return ImageStatus.Complete;
        break;
      case "14":
        return ImageStatus.Rejected;
        break;
      default:
        return ImageStatus.Pending;
        break;
    }
  }

  int getId(){
    switch(this){
      case ImageStatus.Confirm:
        return 12;
        break;
      case ImageStatus.Rejected:
        return 14;
        break;
      case ImageStatus.Complete:
        return 13;
        break;
      case ImageStatus.Pending:
        return 11;
        break;
    }
    return 0;
  }

}