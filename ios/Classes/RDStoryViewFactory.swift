import Flutter
import UIKit

class RDStoryViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger
  private var channel: FlutterMethodChannel

  init(messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
    self.messenger = messenger
    self.channel = channel
    super.init()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?)
    -> FlutterPlatformView
  {
    return RDStoryView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger,
      channel: self.channel)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}
