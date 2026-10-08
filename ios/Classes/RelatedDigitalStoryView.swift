import Flutter
import UIKit
import VisilabsIOS

class RelatedDigitalStoryView: NSObject, FlutterPlatformView, VisilabsStoryURLDelegate {

	private let container: StoryPlatformContainerView
	private let channel: FlutterMethodChannel

	init(
		frame: CGRect,
		viewIdentifier viewId: Int64,
		arguments args: Any?,
		binaryMessenger messenger: FlutterBinaryMessenger?,
		channel: FlutterMethodChannel
	) {
		self.channel = channel
		self.container = StoryPlatformContainerView(frame: frame)
		super.init()
		if let backgroundColor = Self.parseBackgroundColor(args) {
			container.backgroundColor = backgroundColor
		}
		container.onRequestResult = { [weak self] isAvailable, width, height in
			self?.storyRequestResult(isAvailable: isAvailable, width: width, height: height)
		}
		container.load(actionId: Self.parseActionId(args), urlDelegate: self)
	}

	func view() -> UIView {
		return container
	}

	func storyRequestResult(isAvailable: Bool, width: Int, height: Int) {
		let result: NSMutableDictionary = NSMutableDictionary()
		result.setValue(isAvailable, forKey: "isAvailable")
		result.setValue(width, forKey: "width")
		result.setValue(height, forKey: "height")
		channel.invokeMethod(Constants.M_STORY_REQUEST_RESULT, arguments: result)
	}

	func urlClicked(_ url: URL) {
		channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, arguments: [
			"storyLink": url.absoluteString
		])
		// Visilabs opens links with the deprecated openURL: selector, which iOS rejects.
		// Skin-based stories only notify this delegate and never open the link themselves.
		openStoryURL(url)
	}

	private func openStoryURL(_ url: URL) {
		let open = {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		if Thread.isMainThread {
			open()
		} else {
			DispatchQueue.main.async(execute: open)
		}
	}

	private static func parseActionId(_ args: Any?) -> Int? {
		guard let dict = args as? [String: Any],
			  let actionId = dict["actionId"] as? String,
			  !actionId.isEmpty else {
			return nil
		}
		return Int(actionId)
	}

	private static func parseBackgroundColor(_ args: Any?) -> UIColor? {
		guard let dict = args as? [String: Any],
			  let argb = dict["backgroundColor"] as? Int else {
			return nil
		}
		let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
		let red = CGFloat((argb >> 16) & 0xFF) / 255.0
		let green = CGFloat((argb >> 8) & 0xFF) / 255.0
		let blue = CGFloat(argb & 0xFF) / 255.0
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}

/// Hosts the native story strip and keeps its frame in sync with the Flutter platform view.
/// Uses `getStoryViewAsync` (same as the native sample) so cells are created after story
/// properties are known. The sync API first inserts a loading cell with circle constraints,
/// then reuses it as the first rectangle story — that is what made the first item look tiny.
private class StoryPlatformContainerView: UIView {

	var onRequestResult: ((Bool, Int, Int) -> Void)?
	private var storyHomeView: VisilabsStoryHomeView?
	private var didRequest = false

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		clipsToBounds = true
		isUserInteractionEnabled = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func load(actionId: Int?, urlDelegate: VisilabsStoryURLDelegate?) {
		guard !didRequest else { return }
		didRequest = true

		Visilabs.callAPI().getStoryViewAsync(actionId: actionId, urlDelegate: urlDelegate) { [weak self] storyHomeView in
			DispatchQueue.main.async {
				guard let self = self else { return }
				guard let storyHomeView = storyHomeView else {
					self.onRequestResult?(false, 0, 0)
					return
				}
				self.embed(storyHomeView)
				let size = self.resolvedStorySize(storyHomeView)
				self.onRequestResult?(true, size.width, size.height)
			}
		}
	}

	private func embed(_ storyHomeView: VisilabsStoryHomeView) {
		self.storyHomeView?.removeFromSuperview()
		self.storyHomeView = storyHomeView

		storyHomeView.translatesAutoresizingMaskIntoConstraints = true
		storyHomeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		storyHomeView.backgroundColor = backgroundColor
		storyHomeView.frame = bounds.isEmpty ? storyHomeView.frame : bounds
		addSubview(storyHomeView)
		storyHomeView.updateCollectionHeight()
		setNeedsLayout()
		layoutIfNeeded()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		guard let storyHomeView = storyHomeView, !bounds.isEmpty else { return }
		if storyHomeView.frame != bounds {
			storyHomeView.frame = bounds
		}
		storyHomeView.updateCollectionHeight()
	}

	/// Height is the native item size from `sizeForItemAt` (rectangle 220, circle 100).
	/// The collection's own height constraint is taller than the cell and leaves a gap.
	private func resolvedStorySize(_ storyHomeView: VisilabsStoryHomeView) -> (width: Int, height: Int) {
		let width = Int(UIScreen.main.bounds.width.rounded())
		guard let collection = storyHomeView.subviews.compactMap({ $0 as? UICollectionView }).first else {
			return (width, 100)
		}

		let indexPath = IndexPath(item: 0, section: 0)
		if collection.numberOfItems(inSection: 0) > 0,
		   let flowDelegate = collection.delegate as? UICollectionViewDelegateFlowLayout,
		   let size = flowDelegate.collectionView?(collection, layout: collection.collectionViewLayout, sizeForItemAt: indexPath),
		   size.height > 0 {
			return (width, Int(size.height.rounded()))
		}

		if let heightConstraint = collection.constraints.first(where: { $0.firstAttribute == .height && $0.constant > 0 }) {
			return (width, Int(heightConstraint.constant.rounded()))
		}
		return (width, 100)
	}
}
