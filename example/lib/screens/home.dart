import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter_example/models/rd_profile.dart';

class Home extends StatefulWidget {
  final RelatedDigital relatedDigitalPlugin;
  final void Function(dynamic result) notificationHandler;

  const Home(
      {required this.relatedDigitalPlugin, required this.notificationHandler});

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
      Map<String, dynamic>? profileJson = jsonDecode(rdProfileString);
      if (profileJson == null) {
        rdProfile = RDProfile.fromConstant();
      } else {
        rdProfile = RDProfile.fromJson(profileJson);
      }
    }
    tControllers[Constants.organizationId]?.text = rdProfile.organizationId;
    tControllers[Constants.profileId]?.text = rdProfile.profileId;
    tControllers[Constants.dataSource]?.text = rdProfile.dataSource;
  }

  static HashMap<String, TextEditingController> createControllers() {
    return HashMap.from({
      Constants.organizationId: TextEditingController(),
      Constants.profileId: TextEditingController(),
      Constants.dataSource: TextEditingController(),
      Constants.askLocationPermissionAtStart: TextEditingController()
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
                    title: Constants.organizationId,
                    controller: tControllers[Constants.organizationId],
                    onChanged: (String orgId) {
                      rdProfile.organizationId = orgId;
                    }),
                TextInputListTile(
                    title: Constants.profileId,
                    controller: tControllers[Constants.profileId],
                    onChanged: (String pId) {
                      rdProfile.profileId = pId;
                    }),
                TextInputListTile(
                    title: Constants.dataSource,
                    controller: tControllers[Constants.dataSource],
                    onChanged: (String dSource) {
                      rdProfile.dataSource = dSource;
                    }),
                SwitchListTile(
                  title: const Text(
                    Constants.askLocationPermissionAtStart,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: rdProfile.askLocationPermissionAtStart,
                  onChanged: (bool enabled) {
                    rdProfile.askLocationPermissionAtStart = enabled;
                    updateState();
                  },
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.inAppButtonStyle,
                          onPressed: () {
                            submit();
                          },
                          child: const Text('INITIALIZE'))
                    ],
                  ),
                )
              ]).toList(),
            )));
  }

  Future<void> submit() async {
    var initRequest = RDInitRequestModel(
        organizationId: rdProfile.organizationId,
        profileId: rdProfile.profileId,
        dataSource: rdProfile.dataSource,
        askLocationPermissionAtStart: rdProfile.askLocationPermissionAtStart);
    await widget.relatedDigitalPlugin
        .init(initRequest, widget.notificationHandler);
    Navigator.pushNamed(context, '/tabBarView');
  }

  updateState() {
    setState(() {});
  }
}
