import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:relateddigital_flutter_example/styles.dart';

typedef void TapCallback(String text);

class TextInputListTile extends StatelessWidget {
  final String title;


  TextInputListTile({@required this.title,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10.0),
          child: Text(
            title,
            style: Styles.settingsPrimaryText,
          )),
      title: new TextField(
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "Organization ID",
        ),
      ),
    );
  }
}
