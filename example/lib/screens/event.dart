import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

class Event extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Event({@required this.relatedDigitalPlugin});

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
    'mailsubsform',
    'scratchToWin',
    'spintowin',
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
                                      child: Text('Login'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        login();
                                      })
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('GetExVisitorID'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        getExVisitorID();
                                      })
                                ],
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Logout'),
                                      style: Styles.eventButtonStyle,
                                      onPressed: () {
                                        logout();
                                      })
                                ],
                              ),
                            ),
                          ] +
                          getInAppListTiles())
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
                child: Text(inAppType),
                style: Styles.eventButtonStyle,
                onPressed: () {
                  widget.relatedDigitalPlugin.customEvent("InAppTest", {'OM.inapptype': inAppType});
                })
          ],
        ),
      ));
    }
    return tiles;
  }

  void login() {
    widget.relatedDigitalPlugin.login(exVisitorId);
  }

  void setExVisitorID() async {
    exVisitorId = await widget.relatedDigitalPlugin.getExVisitorID();
    tController.text = exVisitorId;
  }

  void getExVisitorID() async {
    String exVisitorID = await widget.relatedDigitalPlugin.getExVisitorID();
    showAlertDialog(title: 'ExVisitorId', content: exVisitorID);
  }

  void logout() {
    widget.relatedDigitalPlugin.logout();
  }

  Future<bool> showAlertDialog({
    @required String title,
    @required String content,
  }) async {
    if (!Platform.isIOS) {
      return showDialog(
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
    return showCupertinoDialog(
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
