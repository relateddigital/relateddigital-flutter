import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'constants.dart';
import 'rd_story_view.dart';
import 'rd_banner_view.dart';
import 'request_models.dart';
import 'response_models.dart';

class RelateddigitalFlutter {
  MethodChannel _channel = MethodChannel(Constants.CHANNEL_NAME);
  Function(RDTokenResponseModel)? _setTokenHandler;
  void Function(dynamic result)? _readNotificationHandler;
  StoryPlatformCallbackHandler? _storyPlatformCallbackHandler;
  BannerPlatformCallbackHandler? _bannerPlatformCallbackHandler;
  bool _logEnabled = true;

  String appAlias = '';
  String huaweiAppAlias = '';

  RelateddigitalFlutter() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    if (methodCall.method == Constants.M_TOKEN_RETRIEVED) {
      RDTokenResponseModel response =
          RDTokenResponseModel.fromJson(methodCall.arguments);
      if (_setTokenHandler != null) {
        _setTokenHandler!(response);
      }
      _handleTokenRegister(response);
    } else if (methodCall.method == Constants.M_NOTIFICATION_OPENED) {
      if (_readNotificationHandler != null) {
        _readNotificationHandler!(methodCall.arguments);
      }
      _handleUtmParameters(methodCall.arguments);
    } else if (methodCall.method == Constants.M_STORY_ITEM_CLICK) {
      Map<String, String> map = {
        'storyLink': methodCall.arguments['storyLink']
      };
      _storyPlatformCallbackHandler?.onItemClick(map);
    } else if (methodCall.method == Constants.M_BANNER_ITEM_CLICK) {
      Map<String, String> map = {
        'bannerLink': methodCall.arguments['bannerLink']
      };
      _bannerPlatformCallbackHandler?.onItemClick(map);
    } else if (methodCall.method == Constants.M_BANNER_REQUEST_RESULT) {
      Map<String, String> map = {
        'isAvailable': methodCall.arguments['isAvailable']?.toString() ?? 'false',
        'width': methodCall.arguments['width']?.toString() ?? '0',
        'height': methodCall.arguments['height']?.toString() ?? '0'
      };
      _bannerPlatformCallbackHandler?.onRequestResult(map);
    }
  }

  Future<void> init(RDInitRequestModel initRequest,
      void Function(dynamic result) notificationHandler) async {
    this.appAlias = initRequest.appAlias;
    this.huaweiAppAlias = initRequest.huaweiAppAlias;
    this._readNotificationHandler = notificationHandler;
    this._logEnabled = initRequest.logEnabled;

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
      'inAppNotificationsEnabled': initRequest.inAppNotificationsEnabled,
      'isIDFAEnabled': initRequest.isIDFAEnabled
    });
  }

  Future<void> requestPermission(Function(RDTokenResponseModel) tokenHandler,
      {bool isProvisional = false}) async {
    _setTokenHandler = tokenHandler;
    await _channel
        .invokeMethod(Constants.M_PERMISSION, {'isProvisional': isProvisional});
  }

  Future<void> setEuroUserId(String userId) async {
    await _channel.invokeMethod(Constants.M_EURO_USER_ID, {'userId': userId});
  }

  Future<void> setEmailWithPermission(String email, bool permission) async {
    await _channel.invokeMethod(Constants.M_EMAIL_WITH_PERMISSION,
        {'email': email, 'permission': permission});
  }

  Future<void> setEmail(String email) async {
    await _channel.invokeMethod(Constants.M_SET_EMAIL, {'email': email});
  }

  Future<void> setUserProperty(String key, String value) async {
    await _channel
        .invokeMethod(Constants.M_USER_PROPERTY, {'key': key, 'value': value});
  }

  Future<void> removeUserProperty(String key) async {
    await _channel.invokeMethod(Constants.M_REMOVE_USER_PROPERTY, {'key': key});
  }

  Future<void> setAppVersion(String appVersion) async {
    await _channel
        .invokeMethod(Constants.M_APP_VERSION, {'appVersion': appVersion});
  }

  Future<void> setNotificationPermission(bool permission) async {
    await _channel.invokeMethod(
        Constants.M_NOTIFICATION_PERMISSION, {'permission': permission});
  }

  Future<void> setEmailPermission(bool permission) async {
    await _channel
        .invokeMethod(Constants.M_EMAIL_PERMISSION, {'permission': permission});
  }

  Future<void> setPhoneNumberPermission(bool permission) async {
    await _channel
        .invokeMethod(Constants.M_PHONE_PERMISSION, {'permission': permission});
  }

  Future<void> setBadgeCount(int count) async {
    if (Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod(Constants.M_BADGE, {'count': count});
  }

  Future<void> setAdvertisingIdentifier(String advertisingId) async {
    await _channel.invokeMethod(
        Constants.M_ADVERTISING, {'advertisingId': advertisingId});
  }

  Future<void> setTwitterId(String twitterId) async {
    await _channel.invokeMethod(Constants.M_TWITTER, {'twitterId': twitterId});
  }

  Future<void> setFacebookId(String facebookId) async {
    await _channel
        .invokeMethod(Constants.M_FACEBOOK, {'facebookId': facebookId});
  }

  Future<void> customEvent(
      String pageName, Map<String, String> parameters) async {
    await _channel.invokeMethod(Constants.M_CUSTOM_EVENT,
        {'pageName': pageName, 'parameters': parameters});
  }

  Future<bool> registerEmail(String email,
      {bool permission = false, bool isCommercial = false}) async {
    var val = await _channel.invokeMethod(Constants.M_REGISTER_EMAIL, {
      'email': email,
      'permission': permission,
      'isCommercial': isCommercial
    });
    if (val != null && val.runtimeType == bool) {
      return val as bool;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getRecommendations(String zoneId,
      {String productCode = '',
      Map<String, String> properties = const {},
      List filters = const []}) async {
    String? rawResponse =
        await _channel.invokeMethod(Constants.M_RECOMMENDATIONS, {
      'zoneId': zoneId,
      'productCode': productCode,
      'properties': properties,
      'filters': filters
    });
    if (rawResponse != null && rawResponse.isNotEmpty) {
      try {
         Map<String, dynamic> parsedJson;
         if (Platform.isIOS) {
            parsedJson = json.decode(rawResponse)[0];
         } else {
            parsedJson = json.decode(rawResponse);
         }

         return parsedJson;
      } on Exception catch (ex) {
        print(ex);
      }
    }
    return {};
  }

  Future<void> trackRecommendationClick(String qs) async {
    await _channel.invokeMethod(Constants.M_TRACK_RECOMMENDATION, {'qs': qs});
  }

  void setStoryPlatformHandler(StoryPlatformCallbackHandler handler) {
    _storyPlatformCallbackHandler = handler;
  }

  void setBannerPlatformHandler(BannerPlatformCallbackHandler handler) {
    _bannerPlatformCallbackHandler = handler;
  }

  Future<void> clearStoryCache() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod(Constants.M_STORY_CLEAR_CACHE);
    }
  }

  Future<Map> getFavoriteAttributeActions({String actionId = ''}) async {
    try {
      String rawResponse = await _channel
          .invokeMethod(Constants.M_FAV_ATTRIBUTE, {'actionId': actionId});

      if (rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return result;
      }
    } on Exception catch (ex) {
      print(ex);
    }
    return {};
  }

  Future<void> logout() async {
    await _channel.invokeMethod(Constants.M_LOGOUT);
  }

  Future<void> login(String userId,
      {Map<String, String> properties = const {}}) async {
    await _channel.invokeMethod(
        Constants.M_LOGIN, {'exVisitorId': userId, 'properties': properties});
  }

  Future<void> signUp(String userId,
      {Map<String, String> properties = const {}}) async {
    await _channel.invokeMethod(
        Constants.M_SIGNUP, {'exVisitorId': userId, 'properties': properties});
  }

  void _handleTokenRegister(RDTokenResponseModel response) {
    Map<String, String> vlTokenParameters = {
      Constants.VL_TOKEN_PARAM: response.deviceToken,
      Constants.VL_APP_ID_PARAM:
          response.playServiceEnabled ? appAlias : huaweiAppAlias
    };

    this.customEvent(Constants.VL_TOKEN_KEY, vlTokenParameters);
  }

  void _handleUtmParameters(dynamic payload) {
    try {
      if (payload != null &&
          payload[Constants.VL_UTM_EVENT_PARAMS_KEY] != null) {
        dynamic payloadParams = payload[Constants.VL_UTM_EVENT_PARAMS_KEY];

        String? utmCampaign = payloadParams[Constants.VL_UTM_CAMPAIGN_PARAM];
        String? utmSource = payloadParams[Constants.VL_UTM_SOURCE_PARAM];
        String? utmMedium = payloadParams[Constants.VL_UTM_MEDIUM_PARAM];

        if ((utmCampaign != null && utmCampaign.isNotEmpty) ||
            (utmSource != null && utmSource.isNotEmpty) ||
            (utmMedium != null && utmMedium.isNotEmpty)) {
          Map<String, String> utmMap = {
            Constants.VL_UTM_CAMPAIGN_PARAM: utmCampaign!,
            Constants.VL_UTM_SOURCE_PARAM: utmSource!,
            Constants.VL_UTM_MEDIUM_PARAM: utmMedium!
          };
          customEvent(Constants.VL_UTM_EVENT_KEY, utmMap);
        }
      }
    } on Exception catch (ex) {
      print(ex.toString());
    }
  }

  Future<String> getExVisitorID() async {
    return _channel
        .invokeMethod<String?>(Constants.M_GET_EXVISITORID)
        .then<String>((String? value) => value ?? '');
  }

  Future<void> sendTheListOfAppsInstalled() async {
    if (Platform.isIOS) {
      if (this._logEnabled) {
        print('Related Digital - Method not supported on iOS');
      }
      return;
    }
    await _channel.invokeMethod(Constants.M_APP_TRACKER);
  }

  Future<PayloadListResponse> getPushMessages() async {
    try {
      String? rawResponse =
          await _channel.invokeMethod(Constants.M_GET_PUSH_MESSAGES);
      if (rawResponse != null && rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return PayloadListResponse.fromJson(result);
      }
    } on PlatformException catch (e) {
      return PayloadListResponse([], '${e.code}:${e.message}:${e.stacktrace}');
    } on Exception catch (ex) {
      print(ex.toString());
      return PayloadListResponse([], ex.toString());
    }
    return PayloadListResponse([], 'Unknown error');
  }

  Future<void> requestIDFA() async {
    if (Platform.isAndroid) {
      if (this._logEnabled) {
        print('Related Digital - Method not supported on Android');
      }
      return;
    }
    await _channel.invokeMethod(Constants.M_REQUEST_IDFA);
  }

  Future<void> sendLocationPermission() async {
    await _channel.invokeMethod(Constants.M_SEND_LOCATION_PERMISSION);
  }

  Future<void> requestLocationPermission() async {
    await _channel.invokeMethod(Constants.M_REQUEST_LOCATION_PERMISSION);
  }
}
