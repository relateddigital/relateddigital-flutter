import 'dart:io';

class Constants {
  static String APP_ALIAS = Platform.isIOS ? 'pragma-flutter-ios-demo' : 'pragma-flutter-android-demo';
  static String HUAWEI_APP_ALIAS = 'pragma-flutter-huawei-android-demo';
  static String ANDROID_PUSH_INTENT = 'com.relateddigital.relateddigital_flutter_example.MainActivity';
  static bool LOG_ENABLED = true;

  static String ORGANIZATION_ID = '676D325830564761676D453D';
  static String SITE_ID = '356467332F6533766975593D';
  static String DATA_SOURCE = 'visistore';
  static bool GEOFENCE_ENABLED = true;
  static int MAX_GEOFENCE_COUNT = 20;
  static bool IN_APP_NOTIFICATIONS_ENABLED = true;
}