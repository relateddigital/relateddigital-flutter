import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter/recommendation_filter.dart';

class Event extends StatefulWidget {
  final RelatedDigital relatedDigitalPlugin;

  const Event({super.key, required this.relatedDigitalPlugin});

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  TextEditingController tController = TextEditingController();
  var inAppTypes = [
    'mini',
    'full',
    'full_image',
    'image_button',
    'image_text_button',
    'smile_rating',
    'nps_with_numbers',
    'nps',
    'alert_native',
    'alert_actionsheet',
    'subscription_email',
    'scratch_to_win',
    'nps-image-text-button',
    'nps-image-text-button-image',
    'nps-feedback',
    'spintowin',
    'half_screen_image',
    'product_stat_notifier',
    'inappcarousel',
    'drawer'
  ];
  String exVisitorId = '';

  @override
  void initState() {
    super.initState();
    setExVisitorID();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text(Constants.Event),
              backgroundColor: Styles.relatedOrange,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                            TextInputListTile(
                              title: Constants.exVisitorId,
                              controller: tController,
                              onChanged: (String exVisitor) {
                                exVisitorId = exVisitor;
                              },
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        login();
                                      },
                                      child: const Text('Login'))
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        getExVisitorID();
                                      },
                                      child: const Text('GetExVisitorID'))
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        getRecommendations();
                                      },
                                      child: const Text('Get Recommendations'))
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        logout();
                                      },
                                      child: const Text('Logout'))
                                ],
                              ),
                            ),
                            Visibility(
                              visible: Platform.isAndroid,
                              child: ListTile(
                                subtitle: Column(
                                  children: <Widget>[
                                    TextButton(
                                        style: Styles.eventButtonStyle,
                                        onPressed: () {
                                          sendTheListOfAppsInstalled();
                                        },
                                        child: const Text('App Tracking'))
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: Platform.isIOS,
                              child: ListTile(
                                subtitle: Column(
                                  children: <Widget>[
                                    TextButton(
                                        style: Styles.eventButtonStyle,
                                        onPressed: () {
                                          requestIDFA();
                                        },
                                        child: const Text('Request IDFA'))
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        sendLocationPermission();
                                      },
                                      child: const Text('Send Location Permission'))
                                ],
                              ),
                            ),
                          ] +
                          getInAppListTiles().toList())
                  .toList(),
            )));
  }

  Iterable<StatelessWidget> getInAppListTiles() {
    List<StatelessWidget> tiles = [];
    for (final inAppType in inAppTypes) {
      tiles.add(ListTile(
        subtitle: Column(
          children: <Widget>[
            TextButton(
                style: Styles.inAppButtonStyle,
                onPressed: () {
                  Map<String, String> parameters = {'OM.inapptype': inAppType};
                  if (inAppType == 'product_stat_notifier') {
                    parameters['OM.pv'] = 'CV7933-837-837';
                  }
                  widget.relatedDigitalPlugin
                      .customEvent("InAppTest", parameters);
                },
                child: Text(inAppType))
          ],
        ),
      ));
    }
    return tiles;
  }

  Future<void> getRecommendations() async {
    String zoneId = '6';
    String productCode = '';

    // optional
    Map<String, Object> filter = {
      RDRecommendationFilter.attribute:
          RDRecommendationFilterAttribute.PRODUCTNAME,
      RDRecommendationFilter.filterType: RDRecommendationFilterType.like,
      RDRecommendationFilter.value: 'Honey'
    };

    List filters = [filter];

    List result = await widget.relatedDigitalPlugin
        .getRecommendations(zoneId, productCode, filters: filters);
    developer.log(result.toString());
  }

  void login() {
    widget.relatedDigitalPlugin.login(exVisitorId);
  }

  void setExVisitorID() async {
    exVisitorId = await widget.relatedDigitalPlugin.getExVisitorId();
    setState(() {
      tController.text = exVisitorId;
    });
  }

  void getExVisitorID() async {
    String exVisitorID = await widget.relatedDigitalPlugin.getExVisitorId();
    showAlertDialog(title: 'ExVisitorId', content: exVisitorID);
  }

  void logout() async {
    await widget.relatedDigitalPlugin.logout();
  }

  void sendTheListOfAppsInstalled() async {
    await widget.relatedDigitalPlugin.sendTheListOfAppsInstalled();
  }

  void requestIDFA() async {
    await widget.relatedDigitalPlugin.requestIDFA();
  }

  void sendLocationPermission() async {
    await widget.relatedDigitalPlugin.sendLocationPermission();
  }

  Future<void> showAlertDialog({
    required String title,
    required String content,
  }) async {
    if (!Platform.isIOS) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    // todo : showDialog for ios
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
