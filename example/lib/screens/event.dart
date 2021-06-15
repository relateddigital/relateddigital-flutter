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
  var inAppTypes = ['mini', 'full', 'image_text_button'];
  String ex;

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
              children: ListTile.divideTiles(context: context, tiles: [
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
              ]).toList(),
            )));
  }

  void login() {
    widget.relatedDigitalPlugin.requestPermission(_getTokenCallback, isProvisional: true);
    //widget.relatedDigitalPlugin.login(tController.text);
  }


  void _getTokenCallback(RDTokenResponseModel result) {
    if(result != null && result.deviceToken != null && result.deviceToken.isNotEmpty) {
      print('Token ' + result.deviceToken);
      setState(() {
        //token = result.deviceToken;
      });
    }
    else {
      setState(() {
        //token = 'Token not retrieved';
      });
    }
  }
}
