import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'relateddigital_flutter_method_channel.dart';

abstract class RelateddigitalFlutterPlatform extends PlatformInterface {
  /// Constructs a RelateddigitalFlutterPlatform.
  RelateddigitalFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static RelateddigitalFlutterPlatform _instance = MethodChannelRelateddigitalFlutter();

  /// The default instance of [RelateddigitalFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelRelateddigitalFlutter].
  static RelateddigitalFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RelateddigitalFlutterPlatform] when
  /// they register themselves.
  static set instance(RelateddigitalFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
