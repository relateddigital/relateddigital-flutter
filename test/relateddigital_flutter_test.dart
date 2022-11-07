import 'package:flutter_test/flutter_test.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/relateddigital_flutter_platform_interface.dart';
import 'package:relateddigital_flutter/relateddigital_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRelateddigitalFlutterPlatform
    with MockPlatformInterfaceMixin
    implements RelateddigitalFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RelateddigitalFlutterPlatform initialPlatform = RelateddigitalFlutterPlatform.instance;

  test('$MethodChannelRelateddigitalFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRelateddigitalFlutter>());
  });

  test('getPlatformVersion', () async {
    RelateddigitalFlutter relateddigitalFlutterPlugin = RelateddigitalFlutter();
    MockRelateddigitalFlutterPlatform fakePlatform = MockRelateddigitalFlutterPlatform();
    RelateddigitalFlutterPlatform.instance = fakePlatform;

    expect(await relateddigitalFlutterPlugin.getPlatformVersion(), '42');
  });
}
