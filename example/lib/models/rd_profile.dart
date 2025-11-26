import 'package:relateddigital_flutter_example/constants.dart';

class RDProfile {
  String appAlias;
  String huaweiAppAlias;
  String androidPushIntent;
  String organizationId;
  String profileId;
  String dataSource;
  int maxGeofenceCount;
  bool geofenceEnabled;
  bool inAppNotificationsEnabled;
  bool logEnabled;
  bool isIDFAEnabled;
  bool useNotificationLargeIcon;
  String androidIconName;

  RDProfile(
      this.appAlias,
      this.huaweiAppAlias,
      this.androidPushIntent,
      this.organizationId,
      this.profileId,
      this.dataSource,
      this.maxGeofenceCount,
      this.geofenceEnabled,
      this.inAppNotificationsEnabled,
      this.logEnabled,
      this.isIDFAEnabled,
      this.useNotificationLargeIcon,
      this.androidIconName);

  RDProfile.fromConstant()
      : appAlias = Constants.APP_ALIAS,
        huaweiAppAlias = Constants.HUAWEI_APP_ALIAS,
        androidPushIntent = Constants.ANDROID_PUSH_INTENT,
        organizationId = Constants.ORGANIZATION_ID,
        profileId = Constants.SITE_ID,
        dataSource = Constants.DATA_SOURCE,
        maxGeofenceCount = Constants.MAX_GEOFENCE_COUNT,
        geofenceEnabled = Constants.GEOFENCE_ENABLED,
        inAppNotificationsEnabled = Constants.IN_APP_NOTIFICATIONS_ENABLED,
        logEnabled = Constants.LOG_ENABLED,
        isIDFAEnabled = Constants.IS_IDFA_ENABLED,
        useNotificationLargeIcon = Constants.USE_NOTIFICATION_LARGE_ICON,
        androidIconName = Constants.ANDROID_ICON_NAME;

  RDProfile.fromJson(Map<String, dynamic> json)
      : appAlias = json['appAlias'],
        huaweiAppAlias = json['huaweiAppAlias'],
        androidPushIntent = json['androidPushIntent'],
        organizationId = json['organizationId'],
        profileId = json['profileId'],
        dataSource = json['dataSource'],
        maxGeofenceCount = json['maxGeofenceCount'],
        geofenceEnabled = json['geofenceEnabled'],
        inAppNotificationsEnabled = json['inAppNotificationsEnabled'],
        logEnabled = json['logEnabled'],
        isIDFAEnabled = json['isIDFAEnabled'],
        useNotificationLargeIcon = json['useNotificationLargeIcon'],
        androidIconName = json['androidIconName'];

  Map<String, dynamic> toJson() => {
        'appAlias': appAlias,
        'huaweiAppAlias': huaweiAppAlias,
        'androidPushIntent': androidPushIntent,
        'organizationId': organizationId,
        'profileId': profileId,
        'dataSource': dataSource,
        'maxGeofenceCount': maxGeofenceCount,
        'geofenceEnabled': geofenceEnabled,
        'inAppNotificationsEnabled': inAppNotificationsEnabled,
        'logEnabled': logEnabled,
        'isIDFAEnabled': isIDFAEnabled,
        'useNotificationLargeIcon': useNotificationLargeIcon,
        'androidIconName': androidIconName,
      };

  bool validate() {
    return true;
  }

}
