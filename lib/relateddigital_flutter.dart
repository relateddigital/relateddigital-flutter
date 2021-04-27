import 'dart:async';
import 'dart:io';

import 'package:relateddigital_flutter/constants.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:flutter/services.dart';

class RelateddigitalFlutter {
  MethodChannel _channel = MethodChannel(Constants.CHANNEL_NAME);
  Function(RDTokenResponseModel) _setTokenHandler;
  Function(dynamic) _readNotificationHandler;

  String appAlias;
  String huaweiAppAlias;

  RelatedDigitalPlugin() {
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

  Future<String> get platformVersion async {
    // change
    // 0.0.3
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
