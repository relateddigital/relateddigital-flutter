import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

class Event extends StatefulWidget {
  final RelatedDigital relatedDigitalPlugin;

  const Event({super.key, required this.relatedDigitalPlugin});

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  TextEditingController tController = TextEditingController();
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
              children: ListTile.divideTiles(context: context, tiles: [
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
              ]).toList(),
            )));
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
    await widget.relatedDigitalPlugin.requestIdfa();
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
