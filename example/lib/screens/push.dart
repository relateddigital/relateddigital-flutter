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
  TextEditingController tokenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userPropertyKeyController = TextEditingController();
  TextEditingController userPropertyValueController = TextEditingController();
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
                TextInputListTile(
                  title: Constants.userProperty + " Key",
                  controller: userPropertyKeyController,
                  onChanged: null,
                ),
                TextInputListTile(
                  title: Constants.userProperty+ " Value",
                  controller: userPropertyValueController,
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
                          child: Text('Set Email With Permission'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            submit(SubmitType.setEmailWithPermission);
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
                          child: Text('Remove Email Permit'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            removeEmailPermit();
                          })
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Set User Property'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            setUserProperty();
                          })
                    ],
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('Remove User Property'),
                          style: Styles.pushButtonStyle,
                          onPressed: () {
                            removeUserProperty();
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
      this.widget.relatedDigitalPlugin.setEmail(emailController.text);
    } else if (submitType == SubmitType.setEmailWithPermission) {
      this
          .widget
          .relatedDigitalPlugin
          .setEmailWithPermission(emailController.text, emailPermission);
    } else if (submitType == SubmitType.registerEmail) {
      this
          .widget
          .relatedDigitalPlugin
          .registerEmail(emailController.text,
              permission: emailPermission, isCommercial: isCommercial)
          .then((value) => removeEmailPermit());
    }
  }

  setUserProperty() {
    this.widget.relatedDigitalPlugin.setUserProperty(userPropertyKeyController.text, userPropertyValueController.text);
  }

  removeUserProperty() {
    this.widget.relatedDigitalPlugin.removeUserProperty(userPropertyKeyController.text);
  }

  removeEmailPermit() {
    this.widget.relatedDigitalPlugin.removeUserProperty("emailPermit");
  }

  showNotificationCenter() {
    Navigator.pushNamed(context, '/notificationCenter');
  }

  updateState() {
    setState(() {});
  }

  void _getTokenCallback(RDTokenResponseModel result) {
    print('RDTokenResponseModel :');
    if (result != null &&
        result.deviceToken != null &&
        result.deviceToken.isNotEmpty) {
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
