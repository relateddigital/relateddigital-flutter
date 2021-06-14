import 'package:flutter/material.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter_example/widgets/notifications_enabled_button.dart';
//import 'package:airship_flutter/airship_flutter.dart';

import 'package:relateddigital_flutter/relateddigital_flutter.dart';

class Home extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Home({@required this.relatedDigitalPlugin});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String appAlias = "";
  String huaweiAppAlias = "";
  String organizationID = "";
  String siteID = "";
  bool inAppNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
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
                    title: "App Alias",
                    onSubmitted: (String aAlias) {
                      appAlias = aAlias;
                      updateState();
                    }),
                TextInputListTile(
                    title: "Huawei App Alias",
                    onSubmitted: (String haAlias) {
                      huaweiAppAlias = haAlias;
                      updateState();
                    }),
                TextInputListTile(
                    title: "Organization Id",
                    onSubmitted: (String orgId) {
                      organizationID = orgId;
                      updateState();
                    }),
                TextInputListTile(
                    title: "Site Id",
                    onSubmitted: (String sId) {
                      siteID = sId;
                      updateState();
                    }),
                SwitchListTile(
                  title: Text(
                    'In App Notifications Enabled',
                    style: Styles.settingsPrimaryText,
                  ),
                  value: inAppNotificationsEnabled,
                  onChanged: (bool enabled) {
                    inAppNotificationsEnabled = enabled;
                    updateState();
                  },
                ),
                ListTile(
                  title: Text('title'),
                  subtitle: Column(
                    children: <Widget>[
                      Text('inapp'),
                      FlatButton(
                          child: Text('button'),
                          onPressed: () {
                            customEvent();
                          })
                    ],
                  ),
                )
              ]).toList(),
            )));
  }

  Future<void> customEvent() async {
    String pageName = 'pragmahome';
    Map<String, String> parameters = {
      'OM.inapptype': 'image_button',
    };
    await widget.relatedDigitalPlugin.customEvent(pageName, parameters);
  }

  updateState() {
    setState(() {});
    print(appAlias);
    print(huaweiAppAlias);
    print(organizationID);
    print(siteID);
  }
}
