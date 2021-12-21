import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static const payloadDateText = TextStyle(
    color: relatedRed,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static ButtonStyle eventButtonStyle = ButtonStyle (
    backgroundColor: MaterialStateProperty.all<Color>(relatedOrange),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  static ButtonStyle pushButtonStyle = ButtonStyle (
    backgroundColor: MaterialStateProperty.all<Color>(relatedRed),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  static ButtonStyle inAppButtonStyle = ButtonStyle (
    backgroundColor: MaterialStateProperty.all<Color>(relatedPurple),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  static ButtonStyle storyButtonStyle = ButtonStyle (
    backgroundColor: MaterialStateProperty.all<Color>(relatedBlue),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  static ButtonStyle refreshButtonStyle = ButtonStyle (
    backgroundColor: MaterialStateProperty.all<Color>(relatedOrange),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  static const transparentColor = Color(0x00000000);

  static const Color background = relatedPurple; // Color(0xff020202);

  static const Color relatedOrange = Color(0xfff8aa29);

  static const Color relatedRed = Color(0xffd52028);

  static const Color relatedPurple = Color(0xff824198);

  static const Color relatedBlue = Color(0xff3cc1dd);





  static const Color borders = relatedPurple; // Color(0xff202020);

  static const preferenceIcon = IconData(
    0xf443,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );
}