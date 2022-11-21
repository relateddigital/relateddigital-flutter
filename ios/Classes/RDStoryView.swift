import Flutter
import RelatedDigitalIOS
import UIKit

class RDStoryView: NSObject, FlutterPlatformView, RDStoryURLDelegate {

  private var _view: UIView
  private var channel: FlutterMethodChannel

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?,
    channel: FlutterMethodChannel
  ) {
    self._view = UIView()
    self.channel = channel
    super.init()

    if let argsNew = args as? [String: Any] {
      if let actionId = argsNew[Constants.actionId] as? String, !actionId.isEmpty {
        createNativeView(actionId: actionId)
      } else {
        createNativeView(actionId: nil)
      }
    } else {
      createNativeView(actionId: nil)
    }

  }

  func view() -> UIView {
    return _view
  }

  func createNativeView(actionId: String?) {
    do {
      try getStoryView(actionId: actionId)
    } catch {
      print(error)
    }
  }

  func getStoryView(actionId: String?) throws {
    var _actionId: Int?
    if actionId != nil && actionId != "" {
      _actionId = Int(actionId!)
    } else {
      _actionId = nil
    }

    _view = RelatedDigital.getStoryView(actionId: _actionId, urlDelegate: self)
  }

  func urlClicked(_ url: URL) {
    do {
      try handleUrlClick(url)
    } catch {
      print(error)
    }
  }

  func handleUrlClick(_ url: URL) throws {
    let result: NSMutableDictionary = NSMutableDictionary()
    result.setValue(url.absoluteString, forKey: Constants.storyLink)
    self.channel.invokeMethod(Constants.onStoryItemClick, arguments: result)
  }
    
}
