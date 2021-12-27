import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter_example/models/rd_profile.dart';

class Home extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;
  final void Function(dynamic result) notificationHandler;

  Home({required this.relatedDigitalPlugin, required this.notificationHandler});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HashMap<String, TextEditingController> tControllers = createControllers();
  late RDProfile rdProfile;

  @override
  void initState() {
    rdProfile = RDProfile.fromConstant();
    readSharedPreferences();
    super.initState();
  }

  readSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rdProfileString = prefs.getString("RDProfile");
    if (rdProfileString == null) {
      rdProfile = RDProfile.fromConstant();
    } else {
      Map<String, dynamic> profileJson = jsonDecode(rdProfileString);
      rdProfile = RDProfile.fromJson(profileJson);
    }
    tControllers[Constants.appAlias]?.text = rdProfile.appAlias;
    tControllers[Constants.huaweiAppAlias]?.text = rdProfile.huaweiAppAlias;
    tControllers[Constants.androidPushIntent]?.text =
        rdProfile.androidPushIntent;
    tControllers[Constants.organizationId]?.text = rdProfile.organizationId;
    tControllers[Constants.profileId]?.text = rdProfile.profileId;
    tControllers[Constants.dataSource]?.text = rdProfile.dataSource;
    tControllers[Constants.maxGeofenceCount]?.text =
        rdProfile.maxGeofenceCount.toString();
  }

  static HashMap<String, TextEditingController> createControllers() {
    return HashMap.from({
      Constants.appAlias: TextEditingController(),
      Constants.huaweiAppAlias: TextEditingController(),
      Constants.androidPushIntent: TextEditingController(),
      Constants.organizationId: TextEditingController(),
      Constants.profileId: TextEditingController(),
      Constants.dataSource: TextEditingController(),
      Constants.maxGeofenceCount: TextEditingController()
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('INITIALIZE'),
              backgroundColor: Styles.borders,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                TextInputListTile(
                    title: Constants.appAlias,
                    controller: tControllers[Constants.appAlias] ??
                        TextEditingController(),
                    onChanged: (String aAlias) {
                      rdProfile.appAlias = aAlias;
                    }),
                TextInputListTile(
                    title: Constants.huaweiAppAlias,
                    controller: tControllers[Constants.huaweiAppAlias] ??
                        TextEditingController(),
                    onChanged: (String haAlias) {
                      rdProfile.huaweiAppAlias = haAlias;
                    }),
                TextInputListTile(
                    title: Constants.androidPushIntent,
                    controller: tControllers[Constants.androidPushIntent] ??
                        TextEditingController(),
                    onChanged: (String apIntent) {
                      rdProfile.androidPushIntent = apIntent;
                    }),
                TextInputListTile(
                    title: Constants.organizationId,
                    controller: tControllers[Constants.organizationId] ??
                        TextEditingController(),
                    onChanged: (String orgId) {
                      rdProfile.organizationId = orgId;
                    }),
                TextInputListTile(
                    title: Constants.profileId,
                    controller: tControllers[Constants.profileId] ??
                        TextEditingController(),
                    onChanged: (String pId) {
                      rdProfile.profileId = pId;
                    }),
                TextInputListTile(
                    title: Constants.dataSource,
                    controller: tControllers[Constants.dataSource] ??
                        TextEditingController(),
                    onChanged: (String dSource) {
                      rdProfile.dataSource = dSource;
                    }),
                SwitchListTile(
                  title: Text(
                    Constants.inAppNotificationsEnabled,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: rdProfile.inAppNotificationsEnabled,
                  onChanged: (bool enabled) {
                    rdProfile.inAppNotificationsEnabled = enabled;
                    updateState();
                  },
                ),
                SwitchListTile(
                  title: Text(
                    Constants.geofenceEnabled,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: rdProfile.geofenceEnabled,
                  onChanged: (bool enabled) {
                    rdProfile.geofenceEnabled = enabled;
                    updateState();
                  },
                ),
                TextInputListTile(
                    title: Constants.maxGeofenceCount,
                    type: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    controller: tControllers[Constants.maxGeofenceCount] ??
                        TextEditingController(),
                    onChanged: (String mgCount) {
                      rdProfile.maxGeofenceCount = int.tryParse(mgCount) ?? 20;
                    }),
                SwitchListTile(
                  title: Text(
                    Constants.logEnabled,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: rdProfile.logEnabled,
                  onChanged: (bool enabled) {
                    rdProfile.logEnabled = enabled;
                    updateState();
                  },
                ),
                SwitchListTile(
                  title: Text(
                    Constants.isIDFAEnabled,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: rdProfile.isIDFAEnabled,
                  onChanged: (bool enabled) {
                    rdProfile.isIDFAEnabled = enabled;
                    updateState();
                  },
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('INITIALIZE'),
                          style: Styles.inAppButtonStyle,
                          onPressed: () {
                            submit();
                          })
                    ],
                  ),
                )
              ]).toList(),
            )));
  }

  Future<void> submit() async {
    var initRequest = RDInitRequestModel(
      appAlias: rdProfile.appAlias,
      huaweiAppAlias: rdProfile
          .huaweiAppAlias, // pass empty String if your app does not support HMS
      androidPushIntent: rdProfile.androidPushIntent, // Android only
      organizationId: rdProfile.organizationId,
      siteId: rdProfile.profileId,
      dataSource: rdProfile.dataSource,
      maxGeofenceCount: rdProfile.maxGeofenceCount > 20
          ? 20
          : rdProfile.maxGeofenceCount, // iOS only
      geofenceEnabled: rdProfile.geofenceEnabled,
      inAppNotificationsEnabled: rdProfile.inAppNotificationsEnabled,
      logEnabled: rdProfile.logEnabled,
      isIDFAEnabled: rdProfile.isIDFAEnabled, // iOS only
    );
    await widget.relatedDigitalPlugin
        .init(initRequest, widget.notificationHandler);
    Navigator.pushNamed(context, '/tabBarView');
  }

  updateState() {
    setState(() {});
  }
}
