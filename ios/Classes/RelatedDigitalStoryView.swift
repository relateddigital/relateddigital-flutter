import Flutter
import UIKit
import VisilabsIOS

class RelatedDigitalStoryView: NSObject, FlutterPlatformView, VisilabsStoryURLDelegate {
	
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
		
		if let argsNew = args as? [String:Any] {
			let actionId = argsNew["actionId"] as? String
			if(actionId != nil && actionId != "") {
				createNativeView(actionId: actionId)
			}
			else {
				createNativeView(actionId: nil)
			}
		}
		else {
			createNativeView(actionId: nil)
		}
		
		
	}
	
	func view() -> UIView {
		return _view
	}
	
	func createNativeView(actionId: String?){
		var _actionId: Int?
		if(actionId != nil && actionId != "") {
			_actionId = Int(actionId!)
		}
		else {
			_actionId = nil
		}
		
		_view = Visilabs.callAPI().getStoryView(actionId: _actionId, urlDelegate: self)
	}
	
	func urlClicked(_ url: URL) {
		let result: NSMutableDictionary = NSMutableDictionary()
		result.setValue(url.absoluteString, forKey: "storyLink")
		
		self.channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, arguments: result)
	}
}