import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

class Push extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Push({required this.relatedDigitalPlugin});

  @override
  _PushState createState() => _PushState();
}

class _PushState extends State<Push> {
  TextEditingController tokenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool emailPermission = true;
  bool isCommercial = false;

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
              backgroundColor: Styles.relatedRed,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                TextInputListTile(
                  title: Constants.token,
                  controller: tokenController,
                  onChanged: null,
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Request Permission'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            this.widget.relatedDigitalPlugin.requestPermission(
                                _getTokenCallback,
                                isProvisional: true);
                          })
                    ],
                  ),
                ),
                TextInputListTile(
                  title: Constants.email,
                  controller: emailController,
                  onChanged: null,
                ),
                SwitchListTile(
                  title: Text(
                    Constants.emailPermission,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: emailPermission,
                  onChanged: (bool ePermission) {
                    emailPermission = ePermission;
                    updateState();
                  },
                ),
                SwitchListTile(
                  title: Text(
                    Constants.isCommercial,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: isCommercial,
                  onChanged: (bool iCommercial) {
                    isCommercial = iCommercial;
                    updateState();
                  },
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Set Email'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.setEmail);
                          })
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Register Email'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.registerEmail);
                          })
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Show Notification Center'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            showNotificationCenter();
                          })
                    ],
                  ),
                ),
              ]).toList(),
            )));
  }

  Future<void> submit(SubmitType submitType) async {
    if (submitType == SubmitType.setEmail) {
      this
          .widget
          .relatedDigitalPlugin
          .setEmail(emailController.text, emailPermission);
    } else if (submitType == SubmitType.registerEmail) {
      this.widget.relatedDigitalPlugin.registerEmail(emailController.text,
          permission: emailPermission, isCommercial: isCommercial);
    }
  }

  showNotificationCenter() {
    Navigator.pushNamed(context, '/notificationCenter');
  }

  updateState() {
    setState(() {});
  }

  void _getTokenCallback(RDTokenResponseModel result) {
    print('RDTokenResponseModel :');
    if (result.deviceToken != null && result.deviceToken!.isNotEmpty) {
      print(result.deviceToken);
      setState(() {
        tokenController.text = result.deviceToken ?? '';
      });
    } else {
      setState(() {
        tokenController.text = 'Token not retrieved';
      });
    }
  }
}

enum SubmitType { setEmail, registerEmail, stopped, paused }
