
class RDInitRequestModel {
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

  RDInitRequestModel(
      {required this.appAlias,
      required this.huaweiAppAlias,
      required this.androidPushIntent,
      required this.organizationId,
      required this.profileId,
      required this.dataSource,
      required this.maxGeofenceCount,
      required this.geofenceEnabled,
      required this.inAppNotificationsEnabled,
      required this.logEnabled,
      this.isIDFAEnabled = false});
}
