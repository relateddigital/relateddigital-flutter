//
//  RelatedDigitalBannerView.swift
//  react-native-related-digital
//
//  Created by Baris Arslan.
//

import Flutter
import UIKit
import VisilabsIOS

class RelatedDigitalBannerView: NSObject, FlutterPlatformView, BannerDelegate {
    
    private var _view: UIView
	private var channel: FlutterMethodChannel

    static let viewTag: Int = 999
    
    var properties: [String: Any]? {
        didSet {
            //self.setupView()
        }
    }

	init(
		frame: CGRect,
		viewIdentifier viewId: Int64,
		arguments args: Any?,
		binaryMessenger messenger: FlutterBinaryMessenger?,
		channel: FlutterMethodChannel
	) {
		self._view = UIView()
		self.channel = channel
        self.properties = args as? [String: Any]
		super.init()
        self.setupView()
	}
	
	func view() -> UIView {
		return _view
	}
    
    private func setupView() {
        if(_view.subviews.contains(where: { $0.tag == RelatedDigitalBannerView.viewTag })) {
            _view.subviews.first(where: { $0.tag == RelatedDigitalBannerView.viewTag })?.removeFromSuperview()
        }

        let props = validateProperties(properties)
        
        Visilabs.getBannerView(properties: props) { banner in
            if let banner = banner {
                banner.delegate = self
                banner.translatesAutoresizingMaskIntoConstraints = false
                banner.isUserInteractionEnabled = true
                self._view.addSubview(banner as UIView)

                let height = banner.heightRD ?? 0
                let width = banner.widthRD ?? 0

                print("banner.heightRD: \(banner.heightRD)")
                print("banner.widthRD: \(banner.widthRD)")
                
                NSLayoutConstraint.activate([banner.topAnchor.constraint(equalTo: self._view.topAnchor),
                                             banner.bottomAnchor.constraint(equalTo: self._view.bottomAnchor),
                                             banner.leadingAnchor.constraint(equalTo: self._view.leadingAnchor),
                                             banner.trailingAnchor.constraint(equalTo: self._view.trailingAnchor)])
                
                self.bannerRequestResult(isAvailable:true, width: width, height: height)
            } else {
                print("Banner view could not be created. Please check your properties.")
                self.bannerRequestResult(isAvailable:false, width: 0, height: 0)
            }
        }
        
        _view.tag = RelatedDigitalBannerView.viewTag
    }

	func bannerItemClickListener(url: String) {
		do {
			try handleUrlClick(url)
		} catch {
			print(error)
		}
	}
    
    func bannerRequestResult(isAvailable: Bool, width: Int, height: Int) {
        let result: NSMutableDictionary = NSMutableDictionary()
        result.setValue(isAvailable, forKey: "isAvailable")
        result.setValue(width, forKey: "width")
        result.setValue(height, forKey: "height")
        self.channel.invokeMethod(Constants.M_BANNER_REQUEST_RESULT, arguments: result)
    }

	func handleUrlClick(_ url: String) throws {
		let result: NSMutableDictionary = NSMutableDictionary()
		result.setValue(url, forKey: "bannerLink")
		
		self.channel.invokeMethod(Constants.M_BANNER_ITEM_CLICK, arguments: result)
	}
    
    func validateProperties(_ properties: [String: Any]?) -> [String: String] {
        // Check if properties is nil or empty
        var validatedProperties = [String: String]()
        
        guard let properties = properties, !properties.isEmpty else {
            return validatedProperties
        }
        
        // Create a new dictionary to store the validated properties
        
        // Loop through the properties and validate them
        for (key, value) in properties {
            // Check if the value is of the correct type
            if let stringValue = value as? String {
                // Add the property to the validated dictionary
                validatedProperties[key] = stringValue
            }
        }
        
        // Return the validated properties
        return validatedProperties
    }


}
