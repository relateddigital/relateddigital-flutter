import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter_example/styles.dart';

class TextLabelListTile extends StatelessWidget {
  final Payload payload;
  final GestureTapCallback onTap;

  TextLabelListTile({required this.payload, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5.0),
          child: Text(
            payload.formattedDate + '\n\n' + payload.pushId,
            style: Styles.payloadDateText,
          )),
      title: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5.0),
          child: Text(
            payload.title,
            style: Styles.settingsPrimaryText,
          )),
      subtitle: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5.0),
          child: Text(
            payload.message,
            style: Styles.settingsSecondaryText,
          )),
      onTap: onTap,
    );
  }
}
