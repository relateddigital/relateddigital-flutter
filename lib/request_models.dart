class RDInitRequestModel {
  String appAlias = '';
  String huaweiAppAlias = '';
  String androidPushIntent = '';
  String organizationId = '';
  String siteId = '';
  String dataSource = '';
  int maxGeofenceCount = 20;
  bool geofenceEnabled = false;
  bool inAppNotificationsEnabled = true;
  bool logEnabled = true;
  bool isIDFAEnabled = true;

  RDInitRequestModel(
      {required String appAlias,
      required String huaweiAppAlias,
      required String androidPushIntent,
      required String organizationId,
      required String siteId,
      required String dataSource,
      int maxGeofenceCount = 20,
      bool geofenceEnabled = false,
      bool inAppNotificationsEnabled = true,
      bool logEnabled = true,
      bool isIDFAEnabled = false}) {
    this.appAlias = appAlias;
    this.huaweiAppAlias = huaweiAppAlias;
    this.androidPushIntent = androidPushIntent;
    this.organizationId = organizationId;
    this.siteId = siteId;
    this.dataSource = dataSource;
    this.maxGeofenceCount = maxGeofenceCount;
    this.geofenceEnabled = geofenceEnabled;
    this.inAppNotificationsEnabled = inAppNotificationsEnabled;
    this.logEnabled = logEnabled;
    this.isIDFAEnabled = isIDFAEnabled;
  }
}
