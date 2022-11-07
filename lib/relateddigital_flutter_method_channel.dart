import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'relateddigital_flutter_platform_interface.dart';

/// An implementation of [RelateddigitalFlutterPlatform] that uses method channels.
class MethodChannelRelateddigitalFlutter extends RelateddigitalFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('relateddigital_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
