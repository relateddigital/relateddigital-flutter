//
//  RelatedDigitalBannerView.swift
//  relateddigital_flutter
//

import Flutter
import UIKit
import VisilabsIOS

class RelatedDigitalBannerView: NSObject, FlutterPlatformView {

	private let container: BannerPlatformContainerView
	private let channel: FlutterMethodChannel

	init(
		frame: CGRect,
		viewIdentifier viewId: Int64,
		arguments args: Any?,
		binaryMessenger messenger: FlutterBinaryMessenger?,
		channel: FlutterMethodChannel
	) {
		self.channel = channel
		self.container = BannerPlatformContainerView(frame: frame)
		super.init()
		container.onItemClick = { [weak self] url in
			self?.handleUrlClick(url)
		}
		container.onRequestResult = { [weak self] isAvailable, width, height in
			self?.bannerRequestResult(isAvailable: isAvailable, width: width, height: height)
		}
		container.load(properties: Self.validateProperties(args as? [String: Any]))
	}

	func view() -> UIView {
		return container
	}

	func bannerRequestResult(isAvailable: Bool, width: Int, height: Int) {
		let result: NSMutableDictionary = NSMutableDictionary()
		result.setValue(isAvailable, forKey: "isAvailable")
		result.setValue(width, forKey: "width")
		result.setValue(height, forKey: "height")
		channel.invokeMethod(Constants.M_BANNER_REQUEST_RESULT, arguments: result)
	}

	func handleUrlClick(_ url: String) {
		let result: NSMutableDictionary = NSMutableDictionary()
		result.setValue(url, forKey: "bannerLink")
		channel.invokeMethod(Constants.M_BANNER_ITEM_CLICK, arguments: result)
	}

	private static func validateProperties(_ properties: [String: Any]?) -> [String: String] {
		var validatedProperties = [String: String]()
		guard let properties = properties, !properties.isEmpty else {
			return validatedProperties
		}
		for (key, value) in properties {
			if let stringValue = value as? String {
				validatedProperties[key] = stringValue
			}
		}
		return validatedProperties
	}
}

/// Hosts the native banner and keeps its frame in sync with the Flutter platform view.
/// `BannerView` sizes its cells on the first layout only; without this, Flutter's
/// fallback 110pt lock in and a later 300pt `SizedBox` never reaches the carousel.
private class BannerPlatformContainerView: UIView, BannerDelegate {

	var onRequestResult: ((Bool, Int, Int) -> Void)?
	var onItemClick: ((String) -> Void)?

	private var bannerView: BannerView?
	private var lastLaidOutSize: CGSize = .zero

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		clipsToBounds = true
		isUserInteractionEnabled = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func load(properties: [String: String]) {
		Visilabs.getBannerView(properties: properties) { [weak self] banner in
			DispatchQueue.main.async {
				guard let self = self else { return }
				guard let banner = banner else {
					self.onRequestResult?(false, 0, 0)
					return
				}
				self.embed(banner)
				self.onRequestResult?(true, banner.widthRD ?? 0, banner.heightRD ?? 0)
			}
		}
	}

	func bannerItemClickListener(url: String) {
		onItemClick?(url)
	}

	private func embed(_ banner: BannerView) {
		bannerView?.removeFromSuperview()
		bannerView = banner

		banner.delegate = self
		banner.isUserInteractionEnabled = true
		Self.deactivateSizeConstraints(on: banner)
		banner.translatesAutoresizingMaskIntoConstraints = true
		banner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		banner.frame = bounds.isEmpty ? banner.frame : bounds
		addSubview(banner)
		lastLaidOutSize = .zero
		setNeedsLayout()
		layoutIfNeeded()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		guard let banner = bannerView, !bounds.isEmpty else { return }
		banner.frame = bounds
		let size = bounds.size
		guard size != lastLaidOutSize else { return }
		lastLaidOutSize = size
		Self.deactivateSizeConstraints(on: banner)
		relayoutBannerCollection(banner)
	}

	private func relayoutBannerCollection(_ banner: BannerView) {
		banner.layoutIfNeeded()
		guard let collection = Self.findCollectionView(in: banner) else {
			banner.reloadBannerViewData()
			return
		}
		if let flow = collection.collectionViewLayout as? UICollectionViewFlowLayout {
			flow.itemSize = CGSize(width: max(bounds.width, 1), height: max(bounds.height, 1))
			flow.invalidateLayout()
		}
		banner.reloadBannerViewData()
		collection.collectionViewLayout.invalidateLayout()
		collection.reloadData()
	}

	private static func deactivateSizeConstraints(on view: UIView) {
		view.constraints
			.filter { $0.firstAttribute == .height || $0.firstAttribute == .width }
			.forEach { $0.isActive = false }
	}

	private static func findCollectionView(in view: UIView) -> UICollectionView? {
		if let collection = view as? UICollectionView {
			return collection
		}
		for subview in view.subviews {
			if let found = findCollectionView(in: subview) {
				return found
			}
		}
		return nil
	}
}
