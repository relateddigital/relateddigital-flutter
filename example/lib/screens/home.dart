import 'package:flutter/material.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/notifications_enabled_button.dart';
//import 'package:airship_flutter/airship_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool inAppNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('INITIALIZE'),
          backgroundColor: Styles.borders,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              leading: Container(
                  padding: EdgeInsets.only(top:10, bottom: 10.0),
                  child: Text(
                    'Organization ID',
                    style: Styles.settingsPrimaryText,
                  )),
              title: new TextField(
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "Organization ID",
                ),
              ),
            ),
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
            )
          ]).toList(),
        ));
  }

  updateState() {
    setState(() {});
  }
}
