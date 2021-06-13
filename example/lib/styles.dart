import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {

  static const homeButtonText = TextStyle(
    color: Color(0xfff0f0f0),
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const homePrimaryText = TextStyle(
    color: Color(0xfff0f0f0),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const homeSecondaryText = TextStyle(
    color: Color(0xff808080),
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const settingsPrimaryText = TextStyle(
    color: Color(0xff101010),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const settingsSecondaryText = TextStyle(
    color: Color(0xff808080),
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const transparentColor = Color(0x00000000);

  static const Color background = Color(0xff020202);

  static const Color airshipBlue = Color(0xff004bff);

  static const Color airshipRed = Color(0xffff0D49);

  static const Color borders = Color(0xff202020);

  static const preferenceIcon = IconData(
    0xf443,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );
}