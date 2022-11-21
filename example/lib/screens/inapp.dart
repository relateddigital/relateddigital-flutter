import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter/recommendation_filter.dart';

class InApp extends StatefulWidget {
  final RelatedDigital relatedDigitalPlugin;

  const InApp({super.key, required this.relatedDigitalPlugin});

  @override
  _InAppState createState() => _InAppState();
}

class _InAppState extends State<InApp> {
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
    'mailsubsform',
    'scratch-to-win',
    'spintowin',
    'socialproof',
    'inappcarousel',
    'nps-image-text-button',
    'nps-image-text-button-image',
    'nps-feedback',
    'halfscreen',
    'drawer',
    'mail_subs_form_2',
    'giftrain',
    'findtowin'
  ];
  String exVisitorId = '';

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
              title: const Text(Constants.InApp),
              backgroundColor: Styles.relatedPurple,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.storyButtonStyle,
                                      onPressed: () {
                                        enableInApp(true);
                                      },
                                      child: const Text('Enable InApp')),
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      style: Styles.pushButtonStyle,
                                      onPressed: () {
                                        enableInApp(false);
                                      },
                                      child: const Text('Disable InApp')),
                                ],
                              ),
                            )
                          ] +
                          getInAppListTiles().toList() +
                          [
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
                            )
                          ])
                  .toList(),
            )));
  }

  Iterable<ListTile> getInAppListTiles() {
    List<ListTile> tiles = [];
    for (final inAppType in inAppTypes) {
      tiles.add(ListTile(
        subtitle: Column(
          children: <Widget>[
            TextButton(
                style: Styles.inAppButtonStyle,
                onPressed: () {
                  Map<String, String> parameters = {'OM.inapptype': inAppType};
                  if (inAppType == 'socialproof') {
                    parameters['OM.pv'] = '584992';
                  }
                  widget.relatedDigitalPlugin.customEvent("in-app", parameters);
                },
                child: Text(inAppType))
          ],
        ),
      ));
    }
    return tiles;
  }

  Future<void> enableInApp(bool enable) async {
    await widget.relatedDigitalPlugin.setIsInAppNotificationEnabled(enable);
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
        .getRecommendations(zoneId, productCode: productCode, filters: filters);
    developer.log(result.toString());
  }
}
