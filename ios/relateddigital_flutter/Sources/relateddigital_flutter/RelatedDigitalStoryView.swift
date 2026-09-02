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
		self._view = UIView(frame: frame)
		self._view.backgroundColor = UIColor.clear
		self.channel = channel
		super.init()
		
		// View'ın frame'ini ayarla
		self._view.frame = frame
		
		if let argsNew = args as? [String:Any] {
			let actionId = argsNew["actionId"] as? String
			if(actionId != nil && actionId != "") {
				// Küçük bir gecikme ile view'ı oluştur - layout hazır olsun
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
					self.createNativeView(actionId: actionId)
				}
			}
			else {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
					self.createNativeView(actionId: nil)
				}
			}
		}
		else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
				self.createNativeView(actionId: nil)
			}
		}
	}
	
	func view() -> UIView {
		return _view
	}
	
	func createNativeView(actionId: String?){
		do {
			try getStoryView(actionId: actionId)
		} catch {
			print(error)
		}
	}
	
	func getStoryView(actionId: String?) throws {
		var _actionId: Int?
		if(actionId != nil && actionId != "") {
			_actionId = Int(actionId!)
		}
		else {
			_actionId = nil
		}
		
		// Mevcut subview'ları temizle
		_view.subviews.forEach { $0.removeFromSuperview() }
		
		let storyView = Visilabs.callAPI().getStoryView(actionId: _actionId, urlDelegate: self)
		
		// View'ın frame'ini ve layout constraint'lerini düzgün ayarla
		storyView.translatesAutoresizingMaskIntoConstraints = false
		_view.addSubview(storyView)
		
		// Constraint'leri ekle - view'ı parent'ın tüm alanını kaplayacak şekilde
		NSLayoutConstraint.activate([
			storyView.topAnchor.constraint(equalTo: _view.topAnchor),
			storyView.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
			storyView.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
			storyView.bottomAnchor.constraint(equalTo: _view.bottomAnchor)
		])
		
		// Frame'i güncelle
		_view.frame = _view.superview?.bounds ?? _view.frame
		
		// Layout'u güncellemek için küçük bir gecikme ekle
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			storyView.setNeedsLayout()
			storyView.layoutIfNeeded()
			self._view.setNeedsLayout()
			self._view.layoutIfNeeded()
		}
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
		result.setValue(url.absoluteString, forKey: "storyLink")
		
		self.channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, arguments: result)
	}
}
