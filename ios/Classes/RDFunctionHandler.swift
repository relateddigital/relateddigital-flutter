import Flutter
import RelatedDigitalIOS

public class RegisterDelegate: RDPushDelegate {
    var flutterResult: FlutterResult?
    
    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
    }
    
    public func didRegisterSuccessfully() {
        flutterResult?(true)
    }
    public func didFailRegister(error: PushAPIError) {
        flutterResult?(false)
    }
}

class RDFunctionHandler {
    
    public func initRD(organizationId: String, profileId: String, dataSource: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?, askLocationPermmissionAtStart: Bool) {
        RelatedDigital.initialize(organizationId: organizationId, profileId: profileId, dataSource: dataSource, launchOptions: launchOptions, askLocationPermmissionAtStart: askLocationPermmissionAtStart)
    }
    
    public func setIsInAppNotificationEnabled(isInAppNotificationEnabled: Bool) {
        RelatedDigital.inAppNotificationsEnabled = isInAppNotificationEnabled
    }
    
    public func setIsGeofenceEnabled(isGeofenceEnabled: Bool) {
        RelatedDigital.geofenceEnabled = isGeofenceEnabled
    }
    
    public func setAdvertisingIdentifier(advertisingIdentifier: String) {
        RelatedDigital.setAdvertisingIdentifier(adIdentifier: advertisingIdentifier)
    }
    
    public func signUp(exVisitorId: String, properties: [String: String]) {
        RelatedDigital.signUp(exVisitorId: exVisitorId, properties: properties)
    }
    
    public func login(exVisitorId: String, properties: [String: String]) {
        RelatedDigital.login(exVisitorId: exVisitorId, properties: properties)
    }
    
    public func logout() {
        RelatedDigital.logout()
    }
    
    public func customEvent(pageName: String, parameters: [String: String]) {
        RelatedDigital.customEvent(pageName, properties: parameters)
    }
    
    public func setIsPushNotificationEnabled(isPushNotificationEnabled: Bool,
                                             appAlias: String,
                                             launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                             deliveredBadge: Bool = true) {
        if isPushNotificationEnabled {
            RelatedDigital.enablePushNotifications(appAlias: appAlias,
                                                   launchOptions: launchOptions,
                                                   deliveredBadge: deliveredBadge)
            RelatedDigital.setPushNotification(permission: true)
        } else {
            RelatedDigital.setPushNotification(permission: false)
        }
    }
    
    public func setEmail(email: String, permission: Bool) {
        RelatedDigital.setEmail(email: email, permission: permission)
    }
    
    public func sendCampaignParameters(parameters: [String: String]) {
        RelatedDigital.sendCampaignParameters(properties: parameters)
    }
    
    public func setTwitterId(twitterId: String) {
        RelatedDigital.setTwitterId(twitterId: twitterId)
        RelatedDigital.sync()
    }
    
    public func setFacebookId(facebookId: String) {
        RelatedDigital.setFacebook(facebookId: facebookId)
        RelatedDigital.sync()
    }
    
    public func setRelatedDigitalUserId(relatedDigitalUserId: String) {
        RelatedDigital.setEuroUserId(userKey: relatedDigitalUserId)
        RelatedDigital.sync()
    }
    
    public func setNotificationLoginId(notificationLoginId: String) {
        RelatedDigital.setNotificationLoginID(notificationLoginID: notificationLoginId)
    }
    
    public func setPhoneNumber(msisdn: String, permission: Bool) {
        RelatedDigital.setPhoneNumber(msisdn: msisdn, permission: permission)
        RelatedDigital.sync()
    }
    
    public func setUserProperty(key: String, value: String) {
        RelatedDigital.setUserProperty(key: key, value: value)
        RelatedDigital.sync()
    }
    
    public func removeUserProperty(key: String) {
        RelatedDigital.removeUserProperty(key: key)
        RelatedDigital.sync()
    }
    
    var customDelegate: RegisterDelegate?
    
    public func registerEmail(email: String, permission: Bool, isCommercial: Bool, result: @escaping FlutterResult) {
        customDelegate = RegisterDelegate(flutterResult: result)
        RelatedDigital.registerEmail(email: email, permission: permission, isCommercial: isCommercial, customDelegate: customDelegate)
    }
    
    public func getPushMessages(result: @escaping FlutterResult) {
        RelatedDigital.getPushMessages(completion: { messages in
            var resultObj = [String: [RDPushMessage]]()
            resultObj[Constants.pushMessages] = messages
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(resultObj)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                result(json)
            } catch {
                result(nil)
            }
            
        })
    }
    
    public func getPushMessagesWithId(result: @escaping FlutterResult) {
        RelatedDigital.getPushMessagesWithID(completion: { messages in
            var resultObj = [String: [RDPushMessage]]()
            resultObj[Constants.pushMessages] = messages
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(resultObj)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                result(json)
            } catch {
                result(nil)
            }
        })
    }
    
    public func sendLocationPermission() {
        RelatedDigital.sendLocationPermission()
    }
    
    public func requestLocationPermission() {
        RelatedDigital.requestLocationPermissions()
    }
    
    public func getFavoriteAttributeActions(actionId: String?, result: @escaping FlutterResult) {
        if actionId != nil && actionId != "" {
            RelatedDigital.getFavoriteAttributeActions(actionId: Int(actionId!)) { (response) in
                self.handleFavAttrResponse(response: response, result: result)
            }
        } else {
            RelatedDigital.getFavoriteAttributeActions { (response) in
                self.handleFavAttrResponse(response: response, result: result)
            }
        }
    }
    
    public func getRecommendations(zoneId: String, productCode: String?, filters: [NSDictionary] = [], result: @escaping FlutterResult) {
        var rdRecoFilters: [RDRecommendationFilter] = []
        
        for filter in filters {
            let attribute = RDProductFilterAttribute(rawValue: filter["attribute"] as! String)
            let filterType = RDRecommendationFilterType(rawValue: filter["filterType"] as! Int)
            let value = filter["value"] as? String  ?? ""
            
            let filter = RDRecommendationFilter(attribute: attribute!, filterType: filterType!, value: value)
            
            rdRecoFilters.append(filter)
        }
        
        RelatedDigital.recommend(zoneId: zoneId, productCode: productCode, filters: rdRecoFilters) { response in
            let resultObj: NSMutableDictionary = NSMutableDictionary()
            
            if response.error != nil {
                resultObj.setValue("recommendation error", forKey: "error")
            } else {
                var recommendations: [RDRecommendationProduct] = []
                
                for product in response.products {
                    recommendations.append(RDRecommendationProduct(code: product.code, title: product.title, img: product.img
                                                                   , brand: product.brand, price: product.price, dprice: product.dprice, cur: product.cur, dcur: product.dcur, freeshipping: product.freeshipping, samedayshipping: product.samedayshipping, rating: product.rating, comment: product.comment, discount: product.discount, attr1: product.attr1, attr2: product.attr2, attr3: product.attr3, attr4: product.attr4, attr5: product.attr5))
                }
                
                do {
                    let jsonEncoder = JSONEncoder()
                    
                    let jsonData = try jsonEncoder.encode(recommendations)
                    let json = String(data: jsonData, encoding: String.Encoding.utf8)
                    result(json)
                } catch {
                    result(nil)
                }
            }
        }
    }
    
    private func handleFavAttrResponse( response: RDFavoriteAttributeActionResponse, result: @escaping FlutterResult) {
        let jsonObj: NSMutableDictionary = NSMutableDictionary()
        
        jsonObj.setValue(response.favorites[.ageGroup], forKey: RDFavoriteAttribute.ageGroup.rawValue)
        jsonObj.setValue(response.favorites[.attr1], forKey: RDFavoriteAttribute.attr1.rawValue)
        jsonObj.setValue(response.favorites[.attr2], forKey: RDFavoriteAttribute.attr2.rawValue)
        jsonObj.setValue(response.favorites[.attr3], forKey: RDFavoriteAttribute.attr3.rawValue)
        jsonObj.setValue(response.favorites[.attr4], forKey: RDFavoriteAttribute.attr4.rawValue)
        jsonObj.setValue(response.favorites[.attr5], forKey: RDFavoriteAttribute.attr5.rawValue)
        jsonObj.setValue(response.favorites[.attr6], forKey: RDFavoriteAttribute.attr6.rawValue)
        jsonObj.setValue(response.favorites[.attr7], forKey: RDFavoriteAttribute.attr7.rawValue)
        jsonObj.setValue(response.favorites[.attr8], forKey: RDFavoriteAttribute.attr8.rawValue)
        jsonObj.setValue(response.favorites[.attr9], forKey: RDFavoriteAttribute.attr9.rawValue)
        jsonObj.setValue(response.favorites[.attr10], forKey: RDFavoriteAttribute.attr10.rawValue)
        jsonObj.setValue(response.favorites[.brand], forKey: RDFavoriteAttribute.brand.rawValue)
        jsonObj.setValue(response.favorites[.category], forKey: RDFavoriteAttribute.category.rawValue)
        jsonObj.setValue(response.favorites[.color], forKey: RDFavoriteAttribute.color.rawValue)
        jsonObj.setValue(response.favorites[.gender], forKey: RDFavoriteAttribute.gender.rawValue)
        jsonObj.setValue(response.favorites[.material], forKey: RDFavoriteAttribute.material.rawValue)
        jsonObj.setValue(response.favorites[.title], forKey: RDFavoriteAttribute.title.rawValue)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: JSONSerialization.WritingOptions()) as NSData
            let json = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            result(json)
        } catch {
            result(nil)
        }
    }
    
    public func getExVisitorId() -> String {
        return RelatedDigital.exVisitorId ?? ""
    }
    
    public func setBadge(count: Int) {
        RelatedDigital.setBadge(count: count)
    }
    
    public func requestPushNotificationPermission(isProvisional: Bool) {
        if isProvisional {
            RelatedDigital.askForNotificationPermissionProvisional(register: true)
        } else {
            RelatedDigital.askForNotificationPermission(register: true)
        }
    }
    
    public func requestIdfa() {
        RelatedDigital.requestIDFA()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public func registerToken(deviceToken: Data) {
        RelatedDigital.registerToken(tokenData: deviceToken)
    }
    
    public func handlePush(pushDictionary: [AnyHashable: Any]) {
        RelatedDigital.handlePush(pushDictionary: pushDictionary)
    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
