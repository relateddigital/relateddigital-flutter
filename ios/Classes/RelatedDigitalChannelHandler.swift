import Flutter
import VisilabsIOS

class RelatedDigitalChannelHandler: NSObject {
	var functionHandler: RelatedDigitalFunctionHandler
	
	override init() {
			self.functionHandler = RelatedDigitalFunctionHandler()
	}
	
	public func handleResult(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		let args = call.arguments as? [String : Any]
			
		if(call.method == Constants.M_INIT) {
			let appAlias = args?["appAlias"] as! String
			let enableLog = args?["enableLog"] as! Bool
			
			let organizationId = args?["organizationId"] as! String;
			let siteId = args?["siteId"] as! String;
			let dataSource = args?["dataSource"] as! String;
			let geofenceEnabled = args?["geofenceEnabled"] as! Bool;
			let inAppNotificationsEnabled = args?["inAppNotificationsEnabled"] as! Bool;
			let maxGeofenceCount = args?["maxGeofenceCount"] as! Int;
			
			self.functionHandler.initEuroMsg(appAlias: appAlias, enableLog: enableLog)
			self.functionHandler.initVisilabs(organizationId: organizationId, profileId: siteId, dataSource: dataSource, inAppNotificationsEnabled: inAppNotificationsEnabled, geofenceEnabled: geofenceEnabled, maxGeofenceCount: maxGeofenceCount)
			
			result(nil)
		}
		else if(call.method == Constants.M_PERMISSION) {
			self.functionHandler.requestPermission()
			result(nil)
		}
		else if(call.method == Constants.M_EURO_USER_ID) {
			let userId = args?["userId"] as! String
			
			self.functionHandler.setEuroUserId(userId: userId)
			result(nil)
		}
		else if(call.method == Constants.M_EMAIL_WITH_PERMISSION) {
			let email = args?["email"] as! String
			let permission = args?["permission"] as! Bool
			
			self.functionHandler.setEmail(email: email, permission: permission)
			result(nil)
		}
		else if(call.method == Constants.M_USER_PROPERTY) {
			let key = args?["key"] as! String
			let value = args?["value"] as! String
			
			self.functionHandler.setUserProperty(key: key, value: value)
			result(nil)
		}
		else if(call.method == Constants.M_APP_VERSION) {
			let appVersion = args?["appVersion"] as! String
			
			self.functionHandler.setAppVersion(appVersion: appVersion)
			result(nil)
		}
		else if(call.method == Constants.M_NOTIFICATION_PERMISSION) {
			let permission = args?["permission"] as! Bool
			
			self.functionHandler.setPushNotificationPermission(permission: permission)
			result(nil)
		}
		else if(call.method == Constants.M_EMAIL_PERMISSION) {
			let permission = args?["permission"] as! Bool
			
			self.functionHandler.setEmailPermission(permission: permission)
			result(nil)
		}
		else if(call.method == Constants.M_PHONE_PERMISSION) {
			let permission = args?["permission"] as! Bool
			
			self.functionHandler.setPhoneNumberPermission(permission: permission)
			result(nil)
		}
		else if(call.method == Constants.M_BADGE) {
			let count = args?["count"] as! Int
			
			self.functionHandler.setBadgeCount(badgeCount: count)
			result(nil)
		}
		else if(call.method == Constants.M_ADVERTISING) {
			let advertisingId = args?["advertisingId"] as? String
			
			self.functionHandler.setAdvertisingIdentifier(identifier: advertisingId)
			result(nil)
		}
		else if(call.method == Constants.M_TWITTER) {
			let twitterId = args?["twitterId"] as? String
			
			self.functionHandler.setTwitterId(twitterId: twitterId)
			result(nil)
		}
		else if(call.method == Constants.M_FACEBOOK) {
			let facebookId = args?["facebookId"] as? String
			
			self.functionHandler.setFacebookId(facebookId: facebookId)
			result(nil)
		}
		else if(call.method == Constants.M_CUSTOM_EVENT) {
			let pageName = args?["pageName"] as! String
			let parameters = args?["parameters"] as! [String : String]
			
			self.functionHandler.customEvent(pageName: pageName, properties: parameters)
			result(nil)
		}
		else if(call.method == Constants.M_REGISTER_EMAIL) {
			let email = args?["email"] as! String
			let permission = args?["permission"] as! Bool
			let isCommercial = args?["isCommercial"] as! Bool
			
			self.functionHandler.registerEmail(email: email, permission: permission, isCommercial: isCommercial)
			result(nil)
		}
		else if(call.method == Constants.M_RECOMMENDATIONS) {
			let zoneId = args?["zoneId"] as! String
			let productCode = args?["productCode"] as! String
			let filters = args?["filters"] as! [NSDictionary]
			
			self.functionHandler.getRecommendations(zoneId: zoneId, productCode: productCode, filters: filters, result: result)
		}
		else if(call.method == Constants.M_FAV_ATTRIBUTE) {
			let actionId = args?["actionId"] as? String
			
			self.functionHandler.getFavoriteAttributeActions(actionId: actionId, result: result)
		}
		else {
			result(FlutterMethodNotImplemented)
		}
	}
	
	public func registerToken(deviceToken: Data) {
		self.functionHandler.registerToken(deviceToken: deviceToken)
	}
	
	public func handlePush(pushDictionary: [AnyHashable: Any]) {
		self.functionHandler.handlePush(pushDictionary: pushDictionary)
	}
}