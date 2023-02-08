import 'dart:io';

bool equalsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase().replaceAll(RegExp(r'ı'), 'i') ==
      string2.toLowerCase().replaceAll(RegExp(r'ı'), 'i');
}

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere(
      (type) => equalsIgnoreCase(type.toString().split(".").last, value),
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
  List<Payload> payloads = [];
  String? error;

  PayloadListResponse(this.payloads, this.error);

  PayloadListResponse.fromJson(dynamic json) {
    payloads = [];
    error = null;
    if (json == null) {
      error = "json is null";
    } else {
      List pushMessages = json['pushMessages'] as List;
      payloads = pushMessages.map(Payload.fromJson).toList();
    }
  }
}

class RDTokenResponseModel {
  String deviceToken = '';
  bool playServiceEnabled = true;

  RDTokenResponseModel.fromJson(dynamic json) {
    this.deviceToken = json["deviceToken"];
    this.playServiceEnabled =
        Platform.isIOS ? true : json["playServiceEnabled"];
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

  RDNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    payload = json;
    if (payload != null) {
      if (Platform.isIOS) {
        dynamic userInfo = payload['userInfo'];
        if (userInfo != null) {
          if (userInfo.containsKey('pushType') &&
              userInfo['pushType'] != null &&
              userInfo['pushType'].runtimeType == String) {
            String tempPushType = userInfo['pushType'] as String;
            if (tempPushType.isNotEmpty) {
              pushType = tempPushType;
            }
          }
          if (userInfo.containsKey('pushId') &&
              userInfo['pushId'] != null &&
              userInfo['pushId'].runtimeType == String) {
            pushId = userInfo['pushId'] as String;
          }
          if (userInfo.containsKey('url') &&
              userInfo['url'] != null &&
              userInfo['url'].runtimeType == String) {
            url = userInfo['url'] as String;
            deepLink = userInfo['url'] as String;
          }
          if (userInfo.containsKey('deepLink') &&
              userInfo['deepLink'] != null &&
              userInfo['deepLink'].runtimeType == String) {
            url = userInfo['deepLink'] as String;
            deepLink = userInfo['deepLink'] as String;
          }
          if (userInfo.containsKey('altUrl') &&
              userInfo['altUrl'] != null &&
              userInfo['altUrl'].runtimeType == String) {
            altUrl = userInfo['altUrl'] as String;
          }
          if (userInfo.containsKey('mediaUrl') &&
              userInfo['mediaUrl'] != null &&
              userInfo['mediaUrl'].runtimeType == String) {
            altUrl = userInfo['mediaUrl'] as String;
          }

          if (userInfo.containsKey('aps') &&
              userInfo['aps'] != null &&
              userInfo['mediaUrl'].runtimeType == Map<String, dynamic>) {
            Map<String, dynamic> aps = userInfo["aps"] as Map<String, dynamic>;
            if (aps.containsKey('content-available') &&
                aps['content-available'] != null &&
                aps['content-available'].runtimeType == int) {
              contentAvailable = aps['content-available'] as int;
            }
            if (aps.containsKey('mutable-content') &&
                aps['mutable-content'] != null &&
                aps['mutable-content'].runtimeType == int) {
              mutableContent = aps['mutable-content'] as int;
            }
            if (aps.containsKey('badge') &&
                aps['badge'] != null &&
                aps['badge'].runtimeType == int) {
              badge = aps['badge'] as int;
            }
            if (aps.containsKey('sound') &&
                aps['sound'] != null &&
                aps['sound'].runtimeType == String) {
              sound = aps['sound'] as String;
            }
            if (aps.containsKey('alert') &&
                aps['alert'] != null &&
                aps.runtimeType == Map<String, dynamic>) {
              Map<String, dynamic> alert = aps["alert"] as Map<String, dynamic>;
              if (alert.containsKey('title') &&
                  alert['title'] != null &&
                  alert['title'].runtimeType == String) {
                title = alert['title'] as String;
              }
              if (alert.containsKey('body') &&
                  alert['body'] != null &&
                  alert['body'].runtimeType == String) {
                body = alert['body'] as String;
              }
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
    required this.id,
    required this.title,
    required this.content,
    required this.url,
    required this.picture,
  });
}
