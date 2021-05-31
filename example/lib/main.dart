import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter/recommendation_filter.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';

void main() {
  runApp(RootApp());
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

    await relatedDigitalPlugin.init(initRequest, _readNotificationCallback);
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
    await relatedDigitalPlugin.requestPermission(_getTokenCallback);
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

  Future<void> getRecommendations() async {
    String zoneId = '6';
    String productCode = '';

    // optional
    Map<String, Object> filter = {
      RDRecommendationFilter.attribute: RDRecommendationFilterAttribute.PRODUCTNAME,
      RDRecommendationFilter.filterType: RDRecommendationFilterType.like,
      RDRecommendationFilter.value: null
    };

    List filters = [
      filter
    ];

    List result = await relatedDigitalPlugin.getRecommendations(zoneId, productCode);
    // List result = await relatedDigitalPlugin.getRecommendations(zoneId, productCode, filters: filters);
    print(result.toString());
  }

  Future<void> clearStoryCache() async {
    await relatedDigitalPlugin.clearStoryCache();
  }

  Future<void> showMailSubscriptionForm() async {
    String pageName = '*pragmamail*';
    Map<String, String> parameters = {
      'OM.pv': '77',
      'OM.pn': 'Product',
      'OM.ppr': '39'
    };

    await relatedDigitalPlugin.customEvent(pageName, parameters);
  }

  Future<void> getFavoriteAttributeActions() async {
    String actionId = '474'; // optional
    Map result = await relatedDigitalPlugin.getFavoriteAttributeActions(actionId: actionId);
    // Map result = await relatedDigitalPlugin.getFavoriteAttributeActions();

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      child: RDStoryView(
                        actionId: '454',
                        relatedDigitalPlugin: relatedDigitalPlugin,
                        onItemClick: (Map<String, String> result) {
                          print(result);
                        },
                      )
                  ),
                  Visibility(
                    visible: Platform.isAndroid,
                    child: ElevatedButton(
                        onPressed: () {
                          clearStoryCache();
                        },
                        child: Text('Clear Story Cache')
                    ),
                  ),
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
                              customEvent();
                            },
                            child: Text('Trigger in app')
                        ),
                        ElevatedButton(
                            onPressed: () {
                              showMailSubscriptionForm();
                            },
                            child: Text('Show mail subscription form')
                        ),
                        ElevatedButton(
                            onPressed: () {
                              getRecommendations();
                            },
                            child: Text('Get recommendations')
                        ),
                        ElevatedButton(
                            onPressed: () {
                              getFavoriteAttributeActions();
                            },
                            child: Text('Get fav attributes')
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}