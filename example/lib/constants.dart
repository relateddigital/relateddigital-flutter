import 'dart:io';

class Constants {

  static const String IOS_APP_ALIAS = 'relateddigital-flutter-example-ios';
  static const String ANDROID_APP_ALIAS = 'flutter-android-demo';

  static String getAppAlias() {
    return Platform.isIOS ? IOS_APP_ALIAS : ANDROID_APP_ALIAS;
  }

  static const String HUAWEI_APP_ALIAS = 'flutter-android-huawei-demo';
  static const  String ANDROID_PUSH_INTENT = 'com.relateddigital.relateddigital_flutter_example.MainActivity';
  static const  bool LOG_ENABLED = true;
  static const  String ORGANIZATION_ID = '676D325830564761676D453D';
  static const  String SITE_ID = '356467332F6533766975593D';
  static const  String DATA_SOURCE = 'visistore';
  static const  bool GEOFENCE_ENABLED = false;
  static const  int MAX_GEOFENCE_COUNT = 20;
  static const  bool IN_APP_NOTIFICATIONS_ENABLED = true;
  static const  bool IS_IDFA_ENABLED = false;

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
  static const String email = 'email';
  static const String emailPermission = 'emailPermission';
  static const String isCommercial = 'isCommercial';

  static const String Event = "Event";
  static const String Push = "Push";
  static const String InApp = "InApp";
  static const String Story = "Story";
  static const String NotificationCenter = "NotificationCenter";
}
