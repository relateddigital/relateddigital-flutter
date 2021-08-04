import Flutter
import Euromsg
import VisilabsIOS

class RelatedDigitalFunctionHandler {
    public func initEuroMsg(appAlias: String, enableLog: Bool) {
        Euromsg.configure(appAlias: appAlias, enableLog: enableLog)
        Euromsg.sync()
    }
    
    public func initVisilabs(organizationId: String, profileId: String, dataSource: String, inAppNotificationsEnabled: Bool, geofenceEnabled: Bool, maxGeofenceCount: Int, enableLog: Bool, isIDFAEnabled: Bool) {
        Visilabs.createAPI(organizationId: organizationId, profileId: profileId, dataSource: dataSource, inAppNotificationsEnabled: inAppNotificationsEnabled, channel: Constants.VL_CHANNEL, requestTimeoutInSeconds: Constants.VL_REQUEST_TIMEOUT, geofenceEnabled: geofenceEnabled, maxGeofenceCount: maxGeofenceCount, isIDFAEnabled: isIDFAEnabled)
        Visilabs.callAPI().loggingEnabled = enableLog
    }
    
    public func requestPermission(isProvisional: Bool) {
        if (isProvisional) {
            Euromsg.askForNotificationPermissionProvisional(register: true)
        } else {
            Euromsg.askForNotificationPermission(register: true)
        }
    }
    
    public func registerToken(deviceToken: Data) {
        Euromsg.registerToken(tokenData: deviceToken)
    }
    
    public func handlePush(pushDictionary: [AnyHashable: Any]) {
        Euromsg.handlePush(pushDictionary: pushDictionary)
    }
    
    public func setEuroUserId(userId: String) {
        Euromsg.setEuroUserId(userKey: userId)
    }
    
    public func setEmail(email: String, permission: Bool) {
        Euromsg.setEmail(email: email, permission: permission)
    }
    
    public func setUserProperty(key: String, value: String) {
        Euromsg.setUserProperty(key: key, value: value)
    }
    
    public func setAppVersion(appVersion: String) {
        Euromsg.setAppVersion(appVersion: appVersion)
    }
    
    public func setPushNotificationPermission(permission: Bool) {
        Euromsg.setPushNotification(permission: permission)
    }
    
    public func setEmailPermission(permission: Bool) {
        Euromsg.setEmail(permission: permission)
    }
    
    public func setPhoneNumberPermission(permission: Bool) {
        Euromsg.setPhoneNumber(permission: permission)
    }
    
    public func setBadgeCount(badgeCount: Int) {
        Euromsg.setBadge(count: badgeCount)
    }
    
    public func setAdvertisingIdentifier(identifier: String?) {
        Euromsg.setAdvertisingIdentifier(adIdentifier: identifier)
    }
    
    public func setTwitterId(twitterId: String?) {
        Euromsg.setTwitterId(twitterId: twitterId)
    }
    
    public func setFacebookId(facebookId: String?) {
        Euromsg.setFacebook(facebookId: facebookId)
    }
    
    public func customEvent(pageName: String, properties: [String : String]) {
        Visilabs.callAPI().customEvent(pageName, properties: properties)
    }
    
    public func registerEmail(email: String, permission: Bool, isCommercial: Bool) {
        Euromsg.registerEmail(email: email, permission: permission, isCommercial: isCommercial)
    }
    
    public func getRecommendations(zoneId: String, productCode: String, filters: [NSDictionary] = [], result: @escaping FlutterResult) {
        var visilabsRecoFilters: [VisilabsRecommendationFilter] = []
        
        for filter in filters {
            let attribute = VisilabsProductFilterAttribute(rawValue: filter["attribute"] as! String)
            let filterType = VisilabsRecommendationFilterType(rawValue: filter["filterType"] as! Int)
            let value = filter["value"] as? String  ?? ""
            
            let filter = VisilabsRecommendationFilter(attribute: attribute!, filterType: filterType!, value: value)
            
            visilabsRecoFilters.append(filter)
        }
        
        Visilabs.callAPI().recommend(zoneID: zoneId, productCode: productCode, filters: visilabsRecoFilters){ response in
            let resultObj: NSMutableDictionary = NSMutableDictionary()
            
            if response.error != nil {
                resultObj.setValue("recommendation error", forKey: "error")
            }
            else {
                var recommendations: [RelatedDigitalRecommendationProduct] = []
                
                for product in response.products {
                    recommendations.append(RelatedDigitalRecommendationProduct(code: product.code, title: product.title, img: product.img
                                                                               , brand: product.brand, price: product.price, dprice: product.dprice, cur: product.cur, dcur: product.dcur, freeshipping: product.freeshipping, samedayshipping: product.samedayshipping, rating: product.rating, comment: product.comment, discount: product.discount, attr1: product.attr1, attr2: product.attr2, attr3: product.attr3, attr4: product.attr4, attr5: product.attr5))
                }
                
                do {
                    let jsonEncoder = JSONEncoder()
                    
                    let jsonData = try jsonEncoder.encode(recommendations)
                    let json = String(data: jsonData, encoding: String.Encoding.utf8)
                    result(json)
                }
                catch {
                    result(nil)
                }
            }
        }
    }
    
    public func getFavoriteAttributeActions(actionId: String?, result: @escaping FlutterResult) {
        if(actionId != nil && actionId != "") {
            Visilabs.callAPI().getFavoriteAttributeActions(actionId: Int(actionId!)) { (response) in
                self.handleFavAttrResponse(response: response, result: result)
            }
        }
        else {
            Visilabs.callAPI().getFavoriteAttributeActions { (response) in
                self.handleFavAttrResponse(response: response, result: result)
            }
        }
    }
    
    private func handleFavAttrResponse( response: VisilabsFavoriteAttributeActionResponse, result: @escaping FlutterResult) {
        let jsonObj: NSMutableDictionary = NSMutableDictionary()
        
        jsonObj.setValue(response.favorites[.ageGroup], forKey: RelatedDigitalFavoriteAttribute.ageGroup.rawValue)
        jsonObj.setValue(response.favorites[.attr1], forKey: RelatedDigitalFavoriteAttribute.attr1.rawValue)
        jsonObj.setValue(response.favorites[.attr2], forKey: RelatedDigitalFavoriteAttribute.attr2.rawValue)
        jsonObj.setValue(response.favorites[.attr3], forKey: RelatedDigitalFavoriteAttribute.attr3.rawValue)
        jsonObj.setValue(response.favorites[.attr4], forKey: RelatedDigitalFavoriteAttribute.attr4.rawValue)
        jsonObj.setValue(response.favorites[.attr5], forKey: RelatedDigitalFavoriteAttribute.attr5.rawValue)
        jsonObj.setValue(response.favorites[.attr6], forKey: RelatedDigitalFavoriteAttribute.attr6.rawValue)
        jsonObj.setValue(response.favorites[.attr7], forKey: RelatedDigitalFavoriteAttribute.attr7.rawValue)
        jsonObj.setValue(response.favorites[.attr8], forKey: RelatedDigitalFavoriteAttribute.attr8.rawValue)
        jsonObj.setValue(response.favorites[.attr9], forKey: RelatedDigitalFavoriteAttribute.attr9.rawValue)
        jsonObj.setValue(response.favorites[.attr10], forKey: RelatedDigitalFavoriteAttribute.attr10.rawValue)
        jsonObj.setValue(response.favorites[.brand], forKey: RelatedDigitalFavoriteAttribute.brand.rawValue)
        jsonObj.setValue(response.favorites[.category], forKey: RelatedDigitalFavoriteAttribute.category.rawValue)
        jsonObj.setValue(response.favorites[.color], forKey: RelatedDigitalFavoriteAttribute.color.rawValue)
        jsonObj.setValue(response.favorites[.gender], forKey: RelatedDigitalFavoriteAttribute.gender.rawValue)
        jsonObj.setValue(response.favorites[.material], forKey: RelatedDigitalFavoriteAttribute.material.rawValue)
        jsonObj.setValue(response.favorites[.title], forKey: RelatedDigitalFavoriteAttribute.title.rawValue)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: JSONSerialization.WritingOptions()) as NSData
            let json = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            result(json)
        }
        catch {
            result(nil)
        }
    }
    
    public func logout() {
        Euromsg.logout()
        Visilabs.callAPI().logout()
    }
    
    public func login(exVisitorId: String, properties: [String: String]) {
        if(properties.isEmpty) {
            Visilabs.callAPI().login(exVisitorId: exVisitorId)
        }
        else {
            Visilabs.callAPI().login(exVisitorId: exVisitorId, properties: properties)
        }
    }
    
    public func signUp(exVisitorId: String, properties: [String: String]) {
        if(properties.isEmpty) {
            Visilabs.callAPI().signUp(exVisitorId: exVisitorId)
        }
        else {
            Visilabs.callAPI().signUp(exVisitorId: exVisitorId, properties: properties)
        }
    }
    
    public func getExVisitorID() -> String  {
        return Visilabs.callAPI().getExVisitorId() ?? ""
    }
    
    
}

public enum RelatedDigitalFavoriteAttribute: String, Encodable {
    case ageGroup
    case attr1
    case attr2
    case attr3
    case attr4
    case attr5
    case attr6
    case attr7
    case attr8
    case attr9
    case attr10
    case brand
    case category
    case color
    case gender
    case material
    case title
}

public class RelatedDigitalRecommendationProduct: Encodable {
    
    public enum PayloadKey {
        public static let code = "code"
        public static let title = "title"
        public static let img = "img"
        public static let brand = "brand"
        public static let price = "price"
        public static let dprice = "dprice"
        public static let cur = "cur"
        public static let dcur = "dcur"
        public static let freeshipping = "freeshipping"
        public static let samedayshipping = "samedayshipping"
        public static let rating = "rating"
        public static let comment = "comment"
        public static let discount = "discount"
        public static let attr1 = "attr1"
        public static let attr2 = "attr2"
        public static let attr3 = "attr3"
        public static let attr4 = "attr4"
        public static let attr5 = "attr5"
    }
    
    public var code: String
    public var title: String
    public var img: String
    public var brand: String
    public var price: Double = 0.0
    public var dprice: Double = 0.0
    public var cur: String
    public var dcur: String
    public var freeshipping: Bool = false
    public var samedayshipping: Bool  = false
    public var rating: Int = 0
    public var comment: Int = 0
    public var discount: Double = 0.0
    public var attr1: String
    public var attr2: String
    public var attr3: String
    public var attr4: String
    public var attr5: String
    
    internal init(code: String, title: String, img: String, brand: String, price: Double, dprice: Double, cur: String, dcur: String, freeshipping: Bool, samedayshipping: Bool, rating: Int, comment: Int, discount: Double, attr1: String, attr2: String, attr3: String, attr4: String, attr5: String) {
        self.code = code
        self.title = title
        self.img = img
        self.brand = brand
        self.price = price
        self.dprice = dprice
        self.cur = cur
        self.dcur = dcur
        self.freeshipping = freeshipping
        self.samedayshipping = samedayshipping
        self.rating = rating
        self.comment = comment
        self.discount = discount
        self.attr1 = attr1
        self.attr2 = attr2
        self.attr3 = attr3
        self.attr4 = attr4
        self.attr5 = attr5
    }
    
    internal init?(JSONObject: [String: Any?]?) {
        
        guard let object = JSONObject else {
            return nil
        }
        
        guard let code = object[PayloadKey.code] as? String else {
            return nil
        }
        
        self.code = code
        self.title = object[PayloadKey.title] as? String ?? ""
        self.img = object[PayloadKey.img] as? String ?? ""
        self.brand = object[PayloadKey.brand] as? String ?? ""
        self.price = object[PayloadKey.price] as? Double ?? 0.0
        self.dprice = object[PayloadKey.dprice] as? Double ?? 0.0
        self.cur = object[PayloadKey.cur] as? String ?? ""
        self.dcur = object[PayloadKey.dcur] as? String ?? ""
        self.freeshipping = object[PayloadKey.freeshipping] as? Bool ?? false
        self.samedayshipping = object[PayloadKey.samedayshipping] as? Bool ?? false
        self.rating = object[PayloadKey.rating] as? Int ?? 0
        self.comment = object[PayloadKey.comment] as? Int ?? 0
        self.discount = object[PayloadKey.discount] as? Double ?? 0.0
        self.attr1 = object[PayloadKey.attr1] as? String ?? ""
        self.attr2 = object[PayloadKey.attr2] as? String ?? ""
        self.attr3 = object[PayloadKey.attr3] as? String ?? ""
        self.attr4 = object[PayloadKey.attr4] as? String ?? ""
        self.attr5 = object[PayloadKey.attr5] as? String ?? ""
    }
}
