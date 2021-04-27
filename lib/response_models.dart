import 'dart:io';

class RDTokenResponseModel {
  String deviceToken;
  bool playServiceEnabled;

  RDTokenResponseModel.fromJson(dynamic json){
    this.deviceToken = json["deviceToken"];
    this.playServiceEnabled = Platform.isIOS ? true : json["playServiceEnabled"];
  }
}