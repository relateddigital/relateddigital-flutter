import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_label_list_tile.dart';

class NotificationCenter extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  NotificationCenter({@required this.relatedDigitalPlugin});

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  List pushNotifications = [];

  @override
  void initState() {
    super.initState();
    getPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              title: const Text(Constants.NotificationCenter),
              backgroundColor: Styles.relatedOrange,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: <Widget>[
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Refresh'),
                                      style: Styles.refreshButtonStyle,
                                      onPressed: () {
                                        getPushNotifications();
                                      })
                                ],
                              ),
                            ),
                          ] + getPushNotificationListTiles())
                  .toList(),
            )));
  }

  Iterable<Widget> getPushNotificationListTiles() {
    List<Widget> tiles = [];
    print("pushNotifications.length");
    print(pushNotifications.length);


    for (final pushNotification in pushNotifications) {
      tiles.add(
        TextLabelListTile(
          title: "TOdDO",
          formattedDateString: "TODO: DATE",
        ),
      );
    }
    //tiles.add(TextLabelListTile(title:"sdfsdf", formattedDateString: "ggg"));

    /*tiles.add(ListTile(
      subtitle: Column(
        children: <Widget>[
          TextButton(
              child: Text('Login'),
              style: Styles.eventButtonStyle,
              onPressed: () {
              })
        ],
      ),
    ),);*/




    /*
    for (final pushNotification in pushNotifications) {
      tiles.add(
        TextLabelListTile(
          title: "TODO",
          formattedDateString: "TODO: DATE",
        ),
      );
    }
     */
    return tiles;
  }

  void getPushNotifications() async {
    pushNotifications = await widget.relatedDigitalPlugin.getPushMessages();
    updateState();
  }



  updateState() {
    setState(() {});
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
