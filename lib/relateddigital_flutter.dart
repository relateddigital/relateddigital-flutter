import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:relateddigital_flutter/constants.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:flutter/services.dart';

class RelateddigitalFlutter {
  MethodChannel _channel = MethodChannel(Constants.CHANNEL_NAME);
  Function(RDTokenResponseModel) _setTokenHandler;
  Function(dynamic) _readNotificationHandler;
  StoryPlatformCallbackHandler _storyPlatformCallbackHandler;

  String appAlias;
  String huaweiAppAlias;

  RelateddigitalFlutter() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    if(methodCall.method == Constants.M_TOKEN_RETRIEVED) {
      RDTokenResponseModel response = RDTokenResponseModel.fromJson(methodCall.arguments);

      Map<String, String> vlTokenParameters = {
        Constants.VL_TOKEN_PARAM: response.deviceToken,
        Constants.VL_APP_ID_PARAM: response.playServiceEnabled ? appAlias : huaweiAppAlias
      };

      this.customEvent(Constants.VL_TOKEN_KEY, vlTokenParameters);

      _setTokenHandler(response);
    }
    else if(methodCall.method == Constants.M_NOTIFICATION_OPENED) {
      _readNotificationHandler(methodCall.arguments);
    }
    else if(methodCall.method == Constants.M_STORY_ITEM_CLICK) {
      Map<String, String> map = {
        'storyLink': methodCall.arguments['storyLink']
      };
      _storyPlatformCallbackHandler.onItemClick(map);
    }
  }

  Future<void> init(RDInitRequestModel initRequest) async {
    this.appAlias = initRequest.appAlias;
    this.huaweiAppAlias = initRequest.huaweiAppAlias;

    await _channel.invokeMethod(Constants.M_INIT, {
      'appAlias': initRequest.appAlias,
      'huaweiAppAlias': initRequest.huaweiAppAlias,
      'pushIntent': initRequest.androidPushIntent,
      'enableLog': initRequest.logEnabled,
      'organizationId': initRequest.organizationId,
      'siteId': initRequest.siteId,
      'dataSource': initRequest.dataSource,
      'geofenceEnabled': initRequest.geofenceEnabled,
      'maxGeofenceCount': initRequest.maxGeofenceCount,
      'inAppNotificationsEnabled': initRequest.inAppNotificationsEnabled
    });
  }

  Future<void> requestPermission(Function(RDTokenResponseModel) tokenHandler, Function(dynamic) notificationHandler) async {
    _setTokenHandler = tokenHandler;
    _readNotificationHandler = notificationHandler;

    await _channel.invokeMethod(Constants.M_PERMISSION);
  }

  Future<void> setEuroUserId(String userId) async {
    await _channel.invokeMethod(Constants.M_EURO_USER_ID, {
      'userId': userId
    });
  }

  Future<void> setEmail(String email, bool permission) async {
    await _channel.invokeMethod(Constants.M_EMAIL_WITH_PERMISSION, {
      'email': email,
      'permission': permission
    });
  }

  Future<void> setUserProperty(String key, String value) async {
    await _channel.invokeMethod(Constants.M_USER_PROPERTY, {
      'key': key,
      'value': value
    });
  }

  Future<void> setAppVersion(String appVersion) async {
    await _channel.invokeMethod(Constants.M_APP_VERSION, {
      'appVersion': appVersion
    });
  }

  Future<void> setNotificationPermission(bool permission) async {
    await _channel.invokeMethod(Constants.M_NOTIFICATION_PERMISSION, {
      'permission': permission
    });
  }

  Future<void> setEmailPermission(bool permission) async {
    await _channel.invokeMethod(Constants.M_EMAIL_PERMISSION, {
      'permission': permission
    });
  }

  Future<void> setPhoneNumberPermission(bool permission) async {
    await _channel.invokeMethod(Constants.M_PHONE_PERMISSION, {
      'permission': permission
    });
  }

  Future<void> setBadgeCount(int count) async {
    if(Platform.isAndroid) {
      return;
    }

    await _channel.invokeMethod(Constants.M_BADGE, {
      'count': count
    });
  }

  Future<void> setAdvertisingIdentifier(String advertisingId) async {
    await _channel.invokeMethod(Constants.M_ADVERTISING, {
      'advertisingId': advertisingId
    });
  }

  Future<void> setTwitterId(String twitterId) async {
    await _channel.invokeMethod(Constants.M_TWITTER, {
      'twitterId': twitterId
    });
  }

  Future<void> setFacebookId(String facebookId) async {
    await _channel.invokeMethod(Constants.M_FACEBOOK, {
      'facebookId': facebookId
    });
  }

  Future<void> customEvent(String pageName, Map<String, String> parameters) async {
    await _channel.invokeMethod(Constants.M_CUSTOM_EVENT, {
      'pageName': pageName,
      'parameters': parameters
    });
  }

  Future<void> registerEmail(String email, {bool permission = false, bool isCommercial = false}) async {
    await _channel.invokeMethod(Constants.M_REGISTER_EMAIL, {
      'email': email,
      'permission': permission,
      'isCommercial': isCommercial
    });
  }

  Future<List> getRecommendations(String zoneId, String productCode, {List filters}) async {
    String rawResponse = await _channel.invokeMethod(Constants.M_RECOMMENDATIONS, {
      'zoneId': zoneId,
      'productCode': productCode,
      'filters': filters ?? []
    });

    if(rawResponse != null && rawResponse.isNotEmpty) {
      List result = json.decode(rawResponse);
      return result;
    }

    return null;
  }

  void setStoryPlatformHandler(StoryPlatformCallbackHandler handler) {
    _storyPlatformCallbackHandler = handler;
  }

  Future<void> clearStoryCache() async {
    if(Platform.isAndroid) {
      await _channel.invokeMethod(Constants.M_STORY_CLEAR_CACHE);
    }
  }

  Future<Map> getFavoriteAttributeActions({String actionId}) async {
    try {
      String rawResponse = await _channel.invokeMethod(Constants.M_FAV_ATTRIBUTE, {
        'actionId': actionId
      });

      if(rawResponse != null && rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return result;
      }
    }
    on Exception catch(ex) {
      print(ex);
      return null;
    }

    return null;
  }


}
