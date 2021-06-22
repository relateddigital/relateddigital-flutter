import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';
import 'package:relateddigital_flutter/response_models.dart';

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
  String exVisitorId;

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
              title: const Text('Event'),
              backgroundColor: Styles.borders,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                            TextInputListTile(
                              title: Constants.exVisitorId,
                              controller: tController,
                              onSubmitted: null,
                            ),
                            ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  TextButton(
                                      child: Text('Login'),
                                      style: Styles.buttonStyle,
                                      onPressed: () {
                                        login();
                                      })
                                ],
                              ),
                            )
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
                style: Styles.buttonStyle,
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
}
