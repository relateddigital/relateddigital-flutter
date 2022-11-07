
import 'relateddigital_flutter_platform_interface.dart';

class RelateddigitalFlutter {
  Future<String?> getPlatformVersion() {
    return RelateddigitalFlutterPlatform.instance.getPlatformVersion();
  }
}
