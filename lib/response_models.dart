import 'dart:io';
import 'package:flutter/material.dart';

class RDTokenResponseModel {
  String deviceToken;
  bool playServiceEnabled;

  RDTokenResponseModel.fromJson(dynamic json) {
    this.deviceToken = json["deviceToken"];
    this.playServiceEnabled = Platform.isIOS ? true : json["playServiceEnabled"];
  }
}

T cast<T>(x) => x is T ? x : null;

//TODO: after investigating all payload parameters use this model.
class RDNotificationResponseModel {
  dynamic payload;
  String pushType = 'Text';
  String pushId = '';
  String url = '';
  String deepLink = '';
  String altUrl = '';
  String mediaUrl = '';
  int contentAvailable = 0;
  int mutableContent = 0;
  int badge = 0;
  String sound = '';
  String title = '';
  String body = '';

  RDNotificationResponseModel.fromJson(dynamic json) {
    this.payload = json;
    print(this.payload);
    if (this.payload != null) {
      if (Platform.isIOS) {
        dynamic userInfo = this.payload["userInfo"];
        if (userInfo != null) {
          this.pushType = (cast<String>(userInfo["pushType"]) ?? '').isEmpty ? this.pushType : cast<String>(userInfo["pushType"]);
          this.pushId = (cast<String>(userInfo["pushType"]) ?? '').isEmpty ? this.pushId : cast<String>(userInfo["pushId"]);
          this.url = this.deepLink = (cast<String>(userInfo["url"]) ?? '').isEmpty ? this.url : cast<String>(userInfo["url"]);
          this.url = this.deepLink = (cast<String>(userInfo["deepLink"]) ?? '').isEmpty ? this.deepLink : cast<String>(userInfo["deepLink"]);
          this.altUrl = (cast<String>(userInfo["altUrl"]) ?? '').isEmpty ? this.altUrl : cast<String>(userInfo["altUrl"]);
          this.mediaUrl = (cast<String>(userInfo["mediaUrl"]) ?? '').isEmpty ? this.mediaUrl : cast<String>(userInfo["mediaUrl"]);
          dynamic aps = userInfo["aps"];
          if (aps != null) {
            this.contentAvailable = (cast<int>(aps["content-available"]) ?? 0) == 0 ? this.contentAvailable : cast<int>(aps["content-available"]);
            this.mutableContent = (cast<int>(aps["mutable-content"]) ?? 0) == 0 ? this.mutableContent : cast<int>(aps["mutable-content"]);
            this.badge = (cast<int>(aps["badge"]) ?? 0) == 0 ? this.badge : cast<int>(aps["badge"]);
            this.sound = (cast<String>(aps["sound"]) ?? '').isEmpty ? this.sound : cast<String>(aps["sound"]);
            dynamic alert = aps["alert"];
            if (alert != null) {
              this.title = (cast<String>(alert["title"]) ?? '').isEmpty ? this.title : cast<String>(alert["title"]);
              this.body = (cast<String>(alert["body"]) ?? '').isEmpty ? this.body : cast<String>(alert["body"]);
            }
          }
        }
      }
    }
  }
}

class RDNotificationCarouselElementModel {
  int id;
  String title;
  String content;
  String url;
  String picture;

  RDNotificationCarouselElementModel({
    @required int id,
    @required String title,
    @required String content,
    @required String url,
    @required String picture,
  }) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.url = url;
    this.picture = picture;
  }
}
