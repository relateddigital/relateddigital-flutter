import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
void main_eski() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final RelateddigitalFlutter relatedDigitalPlugin = RelateddigitalFlutter();
  String token = '-';
  String email = '';
  final bool emailPermission = true;
  @override
  void initState() {
    super.initState();
    initLib();
  }
  Future<void> initLib() async {
    var initRequest = RDInitRequestModel(
      appAlias: Constants.APP_ALIAS,
      huaweiAppAlias: Constants.HUAWEI_APP_ALIAS, // Android only
      androidPushIntent: Constants.ANDROID_PUSH_INTENT, // Android only
      organizationId: Constants.ORGANIZATION_ID,
      siteId: Constants.SITE_ID,
      dataSource: Constants.DATA_SOURCE,
      maxGeofenceCount: Constants.MAX_GEOFENCE_COUNT,  // IOS only
      geofenceEnabled: Constants.GEOFENCE_ENABLED,
      inAppNotificationsEnabled: Constants.IN_APP_NOTIFICATIONS_ENABLED, // IOS only
      logEnabled: Constants.LOG_ENABLED,
    );
    await relatedDigitalPlugin.init(initRequest);
  }
  void _getTokenCallback(RDTokenResponseModel result) {
    print('RDTokenResponseModel ' + result.toString());
    if(result != null && result.deviceToken != null && result.deviceToken.isNotEmpty) {
      setState(() {
        token = result.deviceToken;
      });
    }
    else {
      setState(() {
        token = 'Token not retrieved';
      });
    }
  }
  void _readNotificationCallback(dynamic result) {
    print('_readNotificationCallback');
    print(result);
  }
  Future<void> requestPermission() async {
    await relatedDigitalPlugin.requestPermission(_getTokenCallback, _readNotificationCallback);
  }
  Future<void> setEmail() async {
    await relatedDigitalPlugin.setEmail(email, emailPermission);
  }
  Future<void> registerEmail() async {
    bool permission = true;
    bool isCommercial = false;
    await relatedDigitalPlugin.registerEmail(email, permission: permission, isCommercial: isCommercial);
  }
  Future<void> customEvent() async {
    String pageName = 'pragmahome';
    Map<String, String> parameters = {
      'OM.pv': '77',
      'OM.pn': 'Nectarine Blossom & Honey Body & Hand Lotion',
      'OM.ppr': '39'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> barisAlert() async {
    String pageName = 'barisAlert';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> anketInApp() async {
    String pageName = 'anketInApp';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> gorselBaslikMetin() async {
    String pageName = 'GorselBaslikMetin';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> gorselBaslikMetinII() async {
    String pageName = 'gorselBaslikMetinII';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> miniIconText() async {
    String pageName = 'MiniIconText';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> nPSINAPP() async {
    String pageName = 'NPSINAPP';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> sadeceGorsel() async {
    String pageName = 'SadeceGorsel';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> tamEkranInApp() async {
    String pageName = 'TamEkranInApp';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  Future<void> barisSurvey() async {
    String pageName = 'barisSurvey';
    Map<String, String> parameters = {
      'OM.exVisitorID': 'baris.arslan@euromsg.com'
    };
    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Token: $token\n'),
                ElevatedButton(
                    onPressed: () {
                      requestPermission();
                    },
                    child: Text('Get Token')
                ),
                Container(
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setEmail();
                          },
                          child: Text('Set Email')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            registerEmail();
                          },
                          child: Text('Register Email')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            barisAlert();
                          },
                          child: Text('barisAlert')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            anketInApp();
                          },
                          child: Text('anketInApp')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            gorselBaslikMetin();
                          },
                          child: Text('gorselBaslikMetin')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            gorselBaslikMetinII();
                          },
                          child: Text('gorselBaslikMetinII')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            miniIconText();
                          },
                          child: Text('miniIconText')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            nPSINAPP();
                          },
                          child: Text('nPSINAPP')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            sadeceGorsel();
                          },
                          child: Text('sadeceGorsel')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            tamEkranInApp();
                          },
                          child: Text('TamEkranInApp')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            barisSurvey();
                          },
                          child: Text('barisSurvey')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}