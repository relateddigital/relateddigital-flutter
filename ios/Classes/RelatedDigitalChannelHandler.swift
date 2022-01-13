import Flutter
import VisilabsIOS

class RelatedDigitalChannelHandler: NSObject {
    weak var channel: FlutterMethodChannel?
    var functionHandler: RelatedDigitalFunctionHandler
    
    override init() {
        self.functionHandler = RelatedDigitalFunctionHandler()
    }
    
    public func handleResult(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            try handleCall(call, result: result)
        } catch {
            print(error)
        }
    }
    
    var pushDictionary: [AnyHashable: Any]?
    
    private func handleCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) throws {
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
            let isIDFAEnabled = args?["isIDFAEnabled"] as! Bool;
            
            self.functionHandler.initEuroMsg(appAlias: appAlias, enableLog: enableLog)
            self.functionHandler.initVisilabs(organizationId: organizationId, profileId: siteId, dataSource: dataSource, inAppNotificationsEnabled: inAppNotificationsEnabled
                                              , geofenceEnabled: geofenceEnabled, maxGeofenceCount: maxGeofenceCount, enableLog: enableLog, isIDFAEnabled: isIDFAEnabled)
            
            result(nil)
            
            if let dic = pushDictionary, let chan = self.channel {
                chan.invokeMethod(Constants.M_NOTIFICATION_OPENED, arguments: [
                    "userInfo": dic
                ])
            }
            pushDictionary = nil
            
        }
        else if(call.method == Constants.M_PERMISSION) {
            let isProvisional = args?["isProvisional"] as? Bool ?? false
            self.functionHandler.requestPermission(isProvisional: isProvisional)
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
            
            self.functionHandler.setEmailWithPermission(email: email, permission: permission)
            result(nil)
        }
        else if(call.method == Constants.M_SET_EMAIL) {
            let email = args?["email"] as! String
            
            self.functionHandler.setEmail(email: email)
            result(nil)
        }
        else if(call.method == Constants.M_USER_PROPERTY) {
            let key = args?["key"] as! String
            let value = args?["value"] as! String
            
            self.functionHandler.setUserProperty(key: key, value: value)
            result(nil)
        }
        else if(call.method == Constants.M_REMOVE_USER_PROPERTY) {
            let key = args?["key"] as! String

            self.functionHandler.removeUserProperty(key: key)
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
        else if(call.method == Constants.M_LOGOUT) {
            self.functionHandler.logout()
            result(nil)
        }
        else if(call.method == Constants.M_LOGIN) {
            let exVisitorId = args?["exVisitorId"] as! String
            let properties = args?["properties"] as? [String: String] ?? [:]
            
            self.functionHandler.login(exVisitorId: exVisitorId, properties: properties)
            result(nil)
        }
        else if(call.method == Constants.M_SIGNUP) {
            let exVisitorId = args?["exVisitorId"] as! String
            let properties = args?["properties"] as? [String: String] ?? [:]
            
            self.functionHandler.signUp(exVisitorId: exVisitorId, properties: properties)
            result(nil)
        }
        else if(call.method == Constants.M_GET_EXVISITORID) {
            result(self.functionHandler.getExVisitorID())
        }
        else if(call.method == Constants.M_GET_PUSH_MESSAGES) {
            self.functionHandler.getPushMessages(result: result)
        }
        else if(call.method == Constants.M_REQUEST_IDFA) {
            self.functionHandler.requestIDFA()
            result(nil)
        }
        else if(call.method == Constants.M_SEND_LOCATION_PERMISSION) {
            self.functionHandler.sendLocationPermission()
            result(nil)
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
