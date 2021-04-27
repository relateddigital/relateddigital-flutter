
import 'dart:async';

import 'package:flutter/services.dart';

class RelateddigitalFlutter {
  static const MethodChannel _channel =
      const MethodChannel('relateddigital_flutter');

  static Future<String> get platformVersion async {
    // change
    // 0.0.3
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
