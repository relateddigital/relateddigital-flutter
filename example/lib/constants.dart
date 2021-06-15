import 'dart:io';

class Constants {
  static String APP_ALIAS = Platform.isIOS ? 'pragma-flutter-ios-demo' : 'pragma-flutter-android-demo';
  static String HUAWEI_APP_ALIAS = 'flutter-android-huawei-demo';
  static String ANDROID_PUSH_INTENT = 'com.relateddigital.relateddigital_flutter_example.MainActivity';
  static bool LOG_ENABLED = true;
  static String ORGANIZATION_ID = '676D325830564761676D453D';
  static String SITE_ID = '356467332F6533766975593D';
  static String DATA_SOURCE = 'visistore';
  static bool GEOFENCE_ENABLED = true;
  static int MAX_GEOFENCE_COUNT = 20;
  static bool IN_APP_NOTIFICATIONS_ENABLED = true;
  static bool IS_IDFA_ENABLED = false;

  static const String appAlias = 'appAlias';
  static const String huaweiAppAlias = 'huaweiAppAlias';
  static const String androidPushIntent = 'androidPushIntent';
  static const String organizationId = 'organizationId';
  static const String profileId = 'profileId';
  static const String dataSource = 'dataSource';
  static const String inAppNotificationsEnabled = 'inAppNotificationsEnabled';
  static const String geofenceEnabled = 'geofenceEnabled';
  static const String maxGeofenceCount = 'maxGeofenceCount';
  static const String logEnabled = 'logEnabled';
  static const String isIDFAEnabled = 'isIDFAEnabled';

  static const String exVisitorId = 'exVisitorId';
  static const String token = 'token';
}
