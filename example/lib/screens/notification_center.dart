import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
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
  PayloadListResponse pushNotifications = PayloadListResponse([], null);

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
              leading: IconButton(
                icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
    if(pushNotifications.error != null) {
      print(pushNotifications.error);
    } else if(pushNotifications.payloads.length == 0) {
      print("pushNotifications.payloads.length == 0");
    } else {
      for (final Payload payload in pushNotifications.payloads) {
        tiles.add(
          TextLabelListTile(
            payload: payload,
            onTap: () {
              String content = 'title: ${payload.title}\nmessage: ${payload.message}\nformattedDate: ${payload.formattedDate}'
              + '\ntype: ${payload.type}\nurl: ${payload.url}\nmediaUrl: ${payload.mediaUrl}';
              showAlertDialog(title: payload.title ?? '', content: content);
            },
          ),
        );
      }
    }
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
