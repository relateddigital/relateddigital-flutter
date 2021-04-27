import 'package:flutter/material.dart';

class RDInitRequestModel {
  String appAlias;
  String huaweiAppAlias;
  String androidPushIntent;
  String organizationId;
  String siteId;
  String dataSource;
  int maxGeofenceCount;
  bool geofenceEnabled;
  bool inAppNotificationsEnabled;
  bool logEnabled;

  RDInitRequestModel({@required String appAlias, String huaweiAppAlias, String androidPushIntent, @required String organizationId, @required String siteId, @required String dataSource, int maxGeofenceCount, bool geofenceEnabled, bool inAppNotificationsEnabled, @required bool logEnabled}) {
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
  }
}