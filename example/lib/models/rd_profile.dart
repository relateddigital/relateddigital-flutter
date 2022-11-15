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
      this.isIDFAEnabled);

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
        isIDFAEnabled = Constants.IS_IDFA_ENABLED;

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
        isIDFAEnabled = json['isIDFAEnabled'];

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
  };

  bool validate() {
    return true;
  }

}
