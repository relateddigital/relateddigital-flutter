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

class RDNotificationResponseModel {
  String url;
  String altUrl;
  String mediaUrl;
  String pushType;
  String title;
  String body;
  String pushId;
  String sound;
  int badge;
  dynamic payload;

  RDNotificationResponseModel({
    @required String url,
    @required String altUrl,
    @required String mediaUrl,
    @required String pushType,
    @required String title,
    @required String body,
    @required String pushId,
    @required String sound,
    @required int badge,
  }) {
    this.url = url;
    this.altUrl = altUrl;
    this.mediaUrl = mediaUrl;
    this.pushType = pushType;
    this.title = title;
    this.body = body;
    this.pushId = pushId;
    this.sound = sound;
    this.badge = badge;
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
