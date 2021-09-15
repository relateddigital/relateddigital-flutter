import 'dart:io';
import 'package:flutter/material.dart';

T cast<T>(x) => x is T ? x : null;

bool equalsIgnoreCase(String string1, String string2) {
  return string1?.toLowerCase()?.replaceAll(RegExp(r'ı'), 'i') == string2?.toLowerCase()?.replaceAll(RegExp(r'ı'), 'i');
}

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => equalsIgnoreCase(type.toString().split(".").last, value),
      orElse: () => values.first);
}

enum PayloadType { text, image, carousel, video }

class Payload {
  Payload(
      this.type,
      this.formattedDate,
      this.title,
      this.message,
      this.mediaUrl,
      this.altUrl,
      this.pushId,
      this.campaignId,
      this.url,
      this.from,
      this.sound,
      this.emPushSp,
      this.collapseKey,
      this.params,
      this.elements,
      this.category,
      this.contentAvailable);
  PayloadType type;
  String formattedDate;
  String title;
  String message;
  String mediaUrl;
  String altUrl;
  String pushId;
  String campaignId;
  String url;
  String from;
  String sound;
  String emPushSp;
  String collapseKey;
  Map params;
  List elements;

  //IOS only
  String category;
  int contentAvailable;

  static Payload fromJson(dynamic json) {
    if (Platform.isIOS) {
      String title = '';
      String message = '';
      String category = '';
      String url = json['url'] ?? '';
      if (url.isEmpty) {
        url = json['deeplink'] ?? '';
      }
      String sound = '';
      int contentAvailable = 0;
      dynamic aps = json['aps'];
      if (aps != null) {
        category = aps['category'] ?? '';
        sound = aps['sound'] ?? '';
        contentAvailable = aps['contentAvailable'] ?? 0;
        dynamic alert = aps['alert'];
        if (alert != null) {
          title = alert['title'] ?? '';
          message = alert['body'] ?? '';
        }
      }

      return Payload(
          enumFromString<PayloadType>(PayloadType.values, json['pushType']),
          json['formattedDateString'] ?? '',
          title,
          message,
          json['mediaUrl'] ?? '',
          json['altUrl'] ?? '',
          json['pushId'] ?? '',
          json['cid'] ?? '',
          url,
          json['from'] ?? '',
          sound,
          json['emPushSp'] ?? '',
          json['collapseKey'] ?? '',
          json['params'] ?? Map(),
          json['elements'] ?? [],
          category,
          contentAvailable);
    } else {
      return Payload(
          enumFromString<PayloadType>(PayloadType.values, json['pushType']),
          json['date'] ?? '',
          json['title'] ?? '',
          json['message'] ?? '',
          json['mediaUrl'] ?? '',
          json['altUrl'] ?? '',
          json['pushId'] ?? '',
          json['campaignId'] ?? '',
          json['url'] ?? '',
          json['from'] ?? '',
          json['sound'] ?? '',
          json['emPushSp'] ?? '',
          json['collapseKey'] ?? '',
          json['params'] ?? Map(),
          json['elements'] ?? [],
          '',
          0);
    }
  }
}

class PayloadListResponse {
  List<Payload> payloads;
  String error;

  PayloadListResponse(this.payloads, this.error);

  PayloadListResponse.fromJson(dynamic json) {
    payloads = [];
    error = null;
    if (json == null) {
      error = "json is null";
    } else {
      List pushMessages = cast<List>(json['pushMessages']) ?? [];
      payloads = pushMessages.map(Payload.fromJson).toList();
    }
  }
}

class RDTokenResponseModel {
  String deviceToken;
  bool playServiceEnabled;

  RDTokenResponseModel.fromJson(dynamic json) {
    this.deviceToken = json["deviceToken"];
    this.playServiceEnabled = Platform.isIOS ? true : json["playServiceEnabled"];
  }
}

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
          this.pushType =
              (cast<String>(userInfo["pushType"]) ?? '').isEmpty ? this.pushType : cast<String>(userInfo["pushType"]);
          this.pushId =
              (cast<String>(userInfo["pushType"]) ?? '').isEmpty ? this.pushId : cast<String>(userInfo["pushId"]);
          this.url =
              this.deepLink = (cast<String>(userInfo["url"]) ?? '').isEmpty ? this.url : cast<String>(userInfo["url"]);
          this.url = this.deepLink =
              (cast<String>(userInfo["deepLink"]) ?? '').isEmpty ? this.deepLink : cast<String>(userInfo["deepLink"]);
          this.altUrl =
              (cast<String>(userInfo["altUrl"]) ?? '').isEmpty ? this.altUrl : cast<String>(userInfo["altUrl"]);
          this.mediaUrl =
              (cast<String>(userInfo["mediaUrl"]) ?? '').isEmpty ? this.mediaUrl : cast<String>(userInfo["mediaUrl"]);
          dynamic aps = userInfo["aps"];
          if (aps != null) {
            this.contentAvailable = (cast<int>(aps["content-available"]) ?? 0) == 0
                ? this.contentAvailable
                : cast<int>(aps["content-available"]);
            this.mutableContent =
                (cast<int>(aps["mutable-content"]) ?? 0) == 0 ? this.mutableContent : cast<int>(aps["mutable-content"]);
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
