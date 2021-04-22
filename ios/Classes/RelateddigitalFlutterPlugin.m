#import "RelateddigitalFlutterPlugin.h"
#if __has_include(<relateddigital_flutter/relateddigital_flutter-Swift.h>)
#import <relateddigital_flutter/relateddigital_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "relateddigital_flutter-Swift.h"
#endif

@implementation RelateddigitalFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRelateddigitalFlutterPlugin registerWithRegistrar:registrar];
}
@end
