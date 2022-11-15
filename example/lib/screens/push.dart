import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

class Push extends StatefulWidget {
  final RelatedDigital relatedDigitalPlugin;

  Push({required this.relatedDigitalPlugin});

  @override
  _PushState createState() => _PushState();
}

class _PushState extends State<Push> {
  TextEditingController tokenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userPropertyKeyController = TextEditingController();
  TextEditingController userPropertyValueController = TextEditingController();
  bool emailPermission = true;
  bool notificationPermission = true;
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
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            widget.relatedDigitalPlugin.requestPermission(
                                _getTokenCallback,
                                isProvisional: true);
                          },
                          child: const Text('Request Permission'))
                    ],
                  ),
                ),
                TextInputListTile(
                  title: Constants.email,
                  controller: emailController,
                  onChanged: null,
                ),
                TextInputListTile(
                  title: "${Constants.userProperty} Key",
                  controller: userPropertyKeyController,
                  onChanged: null,
                ),
                TextInputListTile(
                  title: "${Constants.userProperty} Value",
                  controller: userPropertyValueController,
                  onChanged: null,
                ),
                SwitchListTile(
                  title: const Text(
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
                  title: const Text(
                    Constants.notificationPermission,
                    style: Styles.settingsPrimaryText,
                  ),
                  value: notificationPermission,
                  onChanged: (bool nPermission) {
                    notificationPermission = nPermission;
                    widget.relatedDigitalPlugin
                        .setNotificationPermission(nPermission);
                    updateState();
                  },
                ),
                SwitchListTile(
                  title: const Text(
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
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.setEmail);
                          },
                          child: const Text('Set Email'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.setEmailWithPermission);
                          },
                          child: const Text('Set Email With Permission'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.registerEmail);
                          },
                          child: const Text('Register Email'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            removeEmailPermit();
                          },
                          child: const Text('Remove Email Permit'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            setUserProperty();
                          },
                          child: const Text('Set User Property'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            removeUserProperty();
                          },
                          child: const Text('Remove User Property'))
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            showNotificationCenter();
                          },
                          child: const Text('Show Notification Center'))
                    ],
                  ),
                ),
              ]).toList(),
            )));
  }

  Future<void> submit(SubmitType submitType) async {
    if (submitType == SubmitType.setEmail) {
      widget.relatedDigitalPlugin.setEmail(emailController.text, emailPermission);
    } else if (submitType == SubmitType.setEmailWithPermission) {
      widget.relatedDigitalPlugin
          .setEmail(emailController.text, emailPermission);
    } else if (submitType == SubmitType.registerEmail) {
      widget.relatedDigitalPlugin
          .registerEmail(emailController.text,
              permission: emailPermission, isCommercial: isCommercial)
          .then((value) => removeEmailPermit());
    }
  }

  setUserProperty() {
    widget.relatedDigitalPlugin.setUserProperty(
        userPropertyKeyController.text, userPropertyValueController.text);
  }

  removeUserProperty() {
    widget.relatedDigitalPlugin
        .removeUserProperty(userPropertyKeyController.text);
  }

  removeEmailPermit() {
    widget.relatedDigitalPlugin.removeUserProperty("emailPermit");
  }

  showNotificationCenter() {
    Navigator.pushNamed(context, '/notificationCenter');
  }

  updateState() {
    setState(() {});
  }

  void _getTokenCallback(RDTokenResponseModel result) {
    print('RDTokenResponseModel :');
    if (result.deviceToken.isNotEmpty) {
      print(result.deviceToken);
      setState(() {
        tokenController.text = result.deviceToken;
      });
    } else {
      setState(() {
        tokenController.text = 'Token not retrieved';
      });
    }
  }
}

enum SubmitType {
  setEmail,
  setEmailWithPermission,
  registerEmail,
  stopped,
  paused
}
