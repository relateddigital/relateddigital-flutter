import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relateddigital_flutter_example/styles.dart';

class TextInputListTile extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType type;

  const TextInputListTile(
      {super.key, required this.title,
      required this.controller,
      required this.onChanged,
      this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    var formatters = type == TextInputType.number
        ? <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2)
          ]
        : <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter];
    return ListTile(
      leading: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
          child: Text(
            title,
            style: Styles.settingsPrimaryText,
          )),
      title: TextField(
          key: Key(title),
          keyboardType: type,
          inputFormatters: formatters,
          controller: controller,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
          ),
          onChanged: onChanged),
    );
  }
}
