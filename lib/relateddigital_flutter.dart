import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

import 'constants.dart';
import 'rd_story_view.dart';
import 'request_models.dart';
import 'response_models.dart';

class RelatedDigital {
  final MethodChannel _channel = const MethodChannel(Constants.channelName);
  Function(RDTokenResponseModel)? _setTokenHandler;
  void Function(dynamic result)? _readNotificationHandler;
  StoryPlatformCallbackHandler? _storyPlatformCallbackHandler;

  bool _logEnabled = true;
  String appAlias = '';
  String huaweiAppAlias = '';

  RelatedDigital() {
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
    }
  }

  Future<void> init(RDInitRequestModel initRequest,
      void Function(dynamic result) notificationHandler) async {
    appAlias = initRequest.appAlias;
    huaweiAppAlias = initRequest.huaweiAppAlias;
    _readNotificationHandler = notificationHandler;
    _logEnabled = initRequest.logEnabled;

    await _channel.invokeMethod(Constants.init, {
      'appAlias': initRequest.appAlias,
      'huaweiAppAlias': initRequest.huaweiAppAlias,
      'pushIntent': initRequest.androidPushIntent,
      'enableLog': initRequest.logEnabled,
      'organizationId': initRequest.organizationId,
      'profileId': initRequest.profileId,
      'dataSource': initRequest.dataSource,
      'geofenceEnabled': initRequest.geofenceEnabled,
      'maxGeofenceCount': initRequest.maxGeofenceCount,
      'inAppNotificationsEnabled': initRequest.inAppNotificationsEnabled,
      'isIDFAEnabled': initRequest.isIDFAEnabled
    });
  }

  Future<void> setIsInAppNotificationEnabled(bool isInAppNotificationEnabled,
      String googleAppAlias, String huaweiAppAlias, String iosAppAlias) async {
    await _channel.invokeMethod(Constants.setIsInAppNotificationEnabled, {
      Constants.isInAppNotificationEnabled: isInAppNotificationEnabled,
      Constants.googleAppAlias: googleAppAlias,
      Constants.huaweiAppAlias: huaweiAppAlias,
      Constants.iosAppAlias: iosAppAlias
    });
  }

  Future<void> setIsGeofenceEnabled(bool isGeofenceEnabled) async {
    await _channel.invokeMethod(Constants.setIsGeofenceEnabled,
        {Constants.isGeofenceEnabled: isGeofenceEnabled});
  }

  Future<void> setAdvertisingIdentifier(String advertisingIdentifier) async {
    await _channel.invokeMethod(Constants.setAdvertisingIdentifier,
        {Constants.advertisingIdentifier: advertisingIdentifier});
  }

  Future<void> signUp(String exVisitorId,
      {Map<String, String> properties = const {}}) async {
    await _channel.invokeMethod(Constants.signUp,
        {Constants.exVisitorId: exVisitorId, Constants.properties: properties});
  }

  Future<void> login(String exVisitorId,
      {Map<String, String> properties = const {}}) async {
    await _channel.invokeMethod(Constants.login,
        {Constants.exVisitorId: exVisitorId, Constants.properties: properties});
  }

  Future<void> logout() async {
    await _channel.invokeMethod(Constants.logout);
  }

  Future<void> customEvent(
      String pageName, Map<String, String> parameters) async {
    await _channel.invokeMethod(Constants.customEvent,
        {Constants.pageName: pageName, Constants.parameters: parameters});
  }

  Future<void> setEmail(String email, bool permission) async {
    await _channel.invokeMethod(Constants.setEmail,
        {Constants.email: email, Constants.permission: permission});
  }

  Future<void> sendCampaignParameters(Map<String, String> parameters) async {
    await _channel.invokeMethod(
        Constants.sendCampaignParameters, {Constants.parameters: parameters});
  }

  Future<void> setTwitterId(String twitterId) async {
    await _channel
        .invokeMethod(Constants.setTwitterId, {Constants.twitterId: twitterId});
  }

  Future<void> setFacebookId(String facebookId) async {
    await _channel.invokeMethod(
        Constants.setFacebookId, {Constants.facebookId: facebookId});
  }

  Future<void> setRelatedDigitalUserId(String relatedDigitalUserId) async {
    await _channel.invokeMethod(Constants.setRelatedDigitalUserId,
        {Constants.relatedDigitalUserId: relatedDigitalUserId});
  }

  Future<void> setNotificationLoginID(String notificationLoginId) async {
    await _channel.invokeMethod(Constants.setNotificationLoginID,
        {Constants.notificationLoginId: notificationLoginId});
  }

  Future<void> setPhoneNumber(String msisdn, bool permission) async {
    await _channel.invokeMethod(Constants.setPhoneNumber,
        {Constants.msisdn: msisdn, Constants.permission: permission});
  }

  Future<void> setUserProperty(String key, String value) async {
    await _channel.invokeMethod(Constants.setUserProperty,
        {Constants.key: key, Constants.value: value});
  }

  Future<void> removeUserProperty(String key) async {
    await _channel
        .invokeMethod(Constants.removeUserProperty, {Constants.key: key});
  }

  Future<bool> registerEmail(String email,
      {bool permission = false, bool isCommercial = false}) async {
    var val = await _channel.invokeMethod(Constants.registerEmail, {
      Constants.email: email,
      Constants.permission: permission,
      Constants.isCommercial: isCommercial
    });
    if (val != null && val.runtimeType == bool) {
      return val as bool;
    } else {
      return false;
    }
  }

  Future<PayloadListResponse> getPushMessages() async {
    try {
      String? rawResponse =
          await _channel.invokeMethod(Constants.getPushMessages);
      if (rawResponse != null && rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return PayloadListResponse.fromJson(result);
      }
    } on PlatformException catch (e) {
      return PayloadListResponse([], '${e.code}:${e.message}:${e.stacktrace}');
    } on Exception catch (ex) {
      developer.log(ex.toString());
      return PayloadListResponse([], ex.toString());
    }
    return PayloadListResponse([], 'Unknown error');
  }

  Future<PayloadListResponse> getPushMessagesWithID() async {
    try {
      String? rawResponse =
          await _channel.invokeMethod(Constants.getPushMessagesWithID);
      if (rawResponse != null && rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return PayloadListResponse.fromJson(result);
      }
    } on PlatformException catch (e) {
      return PayloadListResponse([], '${e.code}:${e.message}:${e.stacktrace}');
    } on Exception catch (ex) {
      developer.log(ex.toString());
      return PayloadListResponse([], ex.toString());
    }
    return PayloadListResponse([], 'Unknown error');
  }

  Future<void> sendTheListOfAppsInstalled() async {
    if (Platform.isIOS) {
      if (_logEnabled) {
        developer.log('Related Digital - Method not supported on iOS');
      }
      return;
    }
    await _channel.invokeMethod(Constants.sendTheListOfAppsInstalled);
  }

  Future<void> sendLocationPermission() async {
    await _channel.invokeMethod(Constants.sendLocationPermission);
  }

  Future<void> requestLocationPermission() async {
    await _channel.invokeMethod(Constants.requestLocationPermission);
  }

  Future<Map> getFavoriteAttributeActions({String? actionId}) async {
    try {
      String? rawResponse = await _channel.invokeMethod(
          Constants.getFavoriteAttributeActions,
          {Constants.actionId: actionId});

      if (rawResponse != null && rawResponse.isNotEmpty) {
        Map result = json.decode(rawResponse);
        return result;
      }
    } on Exception catch (ex) {
      developer.log(ex.toString());
      return {};
    }
    return {};
  }

  Future<List> getRecommendations(String zoneId, String productCode,
      {List filters = const [],
      Map<String, String> properties = const {}}) async {
    String? rawResponse =
        await _channel.invokeMethod(Constants.getRecommendations, {
      Constants.zoneId: zoneId,
      Constants.productCode: productCode,
      Constants.filters: filters,
      Constants.properties: properties
    });
    if (rawResponse != null && rawResponse.isNotEmpty) {
      List result = json.decode(rawResponse);
      return result;
    } else {
      return [];
    }
  }

  Future<String> getExVisitorId() async {
    return _channel
        .invokeMethod<String?>(Constants.getExVisitorId)
        .then<String>((String? value) => value ?? '');
  }

  Future<void> setBadge(int count) async {
    if (Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod(Constants.setBadge, {Constants.count: count});
  }



















  Future<void> requestPermission(Function(RDTokenResponseModel) tokenHandler,
      {bool isProvisional = false}) async {
    _setTokenHandler = tokenHandler;
    await _channel
        .invokeMethod(Constants.M_PERMISSION, {'isProvisional': isProvisional});
  }

  Future<void> setAppVersion(String appVersion) async {
    await _channel
        .invokeMethod(Constants.M_APP_VERSION, {'appVersion': appVersion});
  }

  Future<void> setNotificationPermission(bool permission) async {
    await _channel.invokeMethod(
        Constants.M_NOTIFICATION_PERMISSION, {'permission': permission});
  }

  void setStoryPlatformHandler(StoryPlatformCallbackHandler handler) {
    _storyPlatformCallbackHandler = handler;
  }

  Future<void> clearStoryCache() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod(Constants.M_STORY_CLEAR_CACHE);
    }
  }

  void _handleTokenRegister(RDTokenResponseModel response) {
    Map<String, String> vlTokenParameters = {
      Constants.VL_TOKEN_PARAM: response.deviceToken,
      Constants.VL_APP_ID_PARAM:
          response.playServiceEnabled ? appAlias : huaweiAppAlias
    };
    customEvent(Constants.VL_TOKEN_KEY, vlTokenParameters);
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
      developer.log(ex.toString());
    }
  }

  Future<void> requestIDFA() async {
    if (Platform.isAndroid) {
      if (_logEnabled) {
        developer.log('Related Digital - Method not supported on Android');
      }
      return;
    }
    await _channel.invokeMethod(Constants.M_REQUEST_IDFA);
  }
}
