import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter_example/styles.dart';

typedef void TapCallback(String text);

class TextInputListTile extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final onSubmitted;
  final TextInputType type;

  TextInputListTile(
      {@required this.title,
      @required this.controller,
      @required this.onSubmitted,
      this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    var formatters = this.type == TextInputType.number ?  <TextInputFormatter>[ FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)] : <TextInputFormatter>[ FilteringTextInputFormatter.singleLineFormatter] ;
    return ListTile(
      leading: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10.0),
          child: Text(
            title,
            style: Styles.settingsPrimaryText,
          )),
      title: new TextField(
          key: Key(title),
          keyboardType: type,
          inputFormatters: formatters,
          controller: controller,
          textAlign: TextAlign.right,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: title,
          ),
          onSubmitted: onSubmitted),
    );
  }
}
