import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

class Push extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Push({@required this.relatedDigitalPlugin});

  @override
  _PushState createState() => _PushState();
}

class _PushState extends State<Push> {
  TextEditingController tController = TextEditingController();

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
              title: const Text('Push'),
              backgroundColor: Styles.borders,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                TextInputListTile(
                  title: Constants.token,
                  controller: tController, onChanged: null,),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Request Permission'),
                          style: Styles.buttonStyle,
                          onPressed: () {
                            this.widget.relatedDigitalPlugin.requestPermission(_getTokenCallback, isProvisional: true);
                          })
                    ],
                  ),
                )
              ]).toList(),
            )));
  }

  void _getTokenCallback(RDTokenResponseModel result) {
    print('RDTokenResponseModel ' + result.toString());
    if(result != null && result.deviceToken != null && result.deviceToken.isNotEmpty) {
      setState(() {
        tController.text = result.deviceToken;
      });
    }
    else {
      setState(() {
        tController.text = 'Token not retrieved';
      });
    }
  }
}
