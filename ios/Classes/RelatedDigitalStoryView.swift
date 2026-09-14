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
		container.onHeightReady = { [weak self] height in
			self?.channel.invokeMethod(Constants.M_STORY_REQUEST_RESULT, arguments: [
				"height": height
			])
		}
		container.load(actionId: Self.parseActionId(args), urlDelegate: self)
	}

	func view() -> UIView {
		return container
	}

	func urlClicked(_ url: URL) {
		channel.invokeMethod(Constants.M_STORY_ITEM_CLICK, arguments: [
			"storyLink": url.absoluteString
		])
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

	var onHeightReady: ((Int) -> Void)?
	private var storyHomeView: VisilabsStoryHomeView?
	private var didRequest = false
	private var didReportHeight = false

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
				guard let self = self, let storyHomeView = storyHomeView else { return }
				self.embed(storyHomeView)
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
		reportHeightIfNeeded()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		guard let storyHomeView = storyHomeView, !bounds.isEmpty else { return }
		if storyHomeView.frame != bounds {
			storyHomeView.frame = bounds
		}
		storyHomeView.updateCollectionHeight()
		reportHeightIfNeeded()
	}

	private func reportHeightIfNeeded() {
		guard !didReportHeight, let storyHomeView = storyHomeView else { return }
		guard let collection = storyHomeView.subviews.compactMap({ $0 as? UICollectionView }).first else { return }
		collection.layoutIfNeeded()

		var itemHeight: CGFloat = 100
		let indexPath = IndexPath(item: 0, section: 0)
		if collection.numberOfItems(inSection: 0) > 0,
		   let flowDelegate = collection.delegate as? UICollectionViewDelegateFlowLayout,
		   let size = flowDelegate.collectionView?(collection, layout: collection.collectionViewLayout, sizeForItemAt: indexPath) {
			itemHeight = size.height
		} else if let cell = collection.visibleCells.first {
			itemHeight = cell.bounds.height
		}

		// Rectangle item is 220; label + native top inset need a bit more. Circle item is 100.
		let height = itemHeight >= 200 ? 258 : 100
		didReportHeight = true
		onHeightReady?(height)
	}
}
