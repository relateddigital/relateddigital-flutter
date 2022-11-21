import Flutter
import RelatedDigitalIOS

class RDChannelHandler: NSObject {
    weak var channel: FlutterMethodChannel?
    var functionHandler: RDFunctionHandler

    override init() {
        functionHandler = RDFunctionHandler()
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
        let args = call.arguments as? [String: Any]

        if call.method == Constants.initialize {
            if let oId = args?[Constants.organizationId] as? String, let pId = args?[Constants.profileId] as? String,
               let dSource = args?[Constants.dataSource] as? String {
                let askLocationPermissionAtStart = args?[Constants.askLocationPermissionAtStart] as? Bool
                functionHandler.initRD(organizationId: oId, profileId: pId, dataSource: dSource,
                                       launchOptions: nil,
                                       askLocationPermmissionAtStart: askLocationPermissionAtStart ?? true)
            }
            result(nil)
            if let dic = pushDictionary, let chan = self.channel {
                chan.invokeMethod(Constants.notificationOpened, arguments: [
                    Constants.userInfo: dic
                ])
            }
            pushDictionary = nil
        } else if call.method == Constants.setIsInAppNotificationEnabled {
            if let isInAppNotificationEnabled = args?[Constants.isInAppNotificationEnabled] as? Bool {
                functionHandler.setIsInAppNotificationEnabled(isInAppNotificationEnabled: isInAppNotificationEnabled)
            }
            result(nil)
        } else if call.method == Constants.setIsGeofenceEnabled {
            if let isGeofenceEnabled = args?[Constants.isGeofenceEnabled] as? Bool {
                functionHandler.setIsGeofenceEnabled(isGeofenceEnabled: isGeofenceEnabled)
            }
            result(nil)
        } else if call.method == Constants.setAdvertisingIdentifier {
            if let advertisingIdentifier = args?[Constants.advertisingIdentifier] as? String {
                functionHandler.setAdvertisingIdentifier(advertisingIdentifier: advertisingIdentifier)
            }
            result(nil)
        } else if call.method == Constants.signUp {
            if let exVisitorId = args?[Constants.exVisitorId] as? String {
                let properties = args?[Constants.properties] as? [String: String] ?? [:]
                functionHandler.signUp(exVisitorId: exVisitorId, properties: properties)
            }
            result(nil)
        } else if call.method == Constants.login {
            if let exVisitorId = args?[Constants.exVisitorId] as? String {
                let properties = args?[Constants.properties] as? [String: String] ?? [:]
                functionHandler.login(exVisitorId: exVisitorId, properties: properties)
            }
            result(nil)
        } else if call.method == Constants.logout {
            functionHandler.logout()
            result(nil)
        } else if call.method == Constants.customEvent {
            if let pageName = args?[Constants.pageName] as? String {
                let parameters = args?[Constants.parameters] as? [String: String] ?? [:]
                functionHandler.customEvent(pageName: pageName, parameters: parameters)
            }
            result(nil)
        } else if call.method == Constants.setIsPushNotificationEnabled {
            if let isPushNotificationEnabled = args?[Constants.isPushNotificationEnabled] as? Bool,
               let iosAppAlias = args?[Constants.iosAppAlias] as? String {
                let deliveredBadge = args?[Constants.deliveredBadge] as? Bool ?? true
                functionHandler.setIsPushNotificationEnabled(isPushNotificationEnabled: isPushNotificationEnabled, appAlias: iosAppAlias, launchOptions: nil, deliveredBadge: deliveredBadge)
            }
            result(nil)
        } else if call.method == Constants.setEmail {
            if let email = args?[Constants.email] as? String, let permission = args?[Constants.permission] as? Bool {
                functionHandler.setEmail(email: email, permission: permission)
            }
            result(nil)
        } else if call.method == Constants.sendCampaignParameters {
            if let parameters = args?[Constants.parameters] as? [String: String] {
                functionHandler.sendCampaignParameters(parameters: parameters)
            }
            result(nil)
        } else if call.method == Constants.setTwitterId {
            if let twitterId = args?[Constants.twitterId] as? String {
                functionHandler.setTwitterId(twitterId: twitterId)
            }
            result(nil)
        } else if call.method == Constants.setFacebookId {
            if let facebookId = args?[Constants.facebookId] as? String {
                functionHandler.setFacebookId(facebookId: facebookId)
            }
            result(nil)
        } else if call.method == Constants.setRelatedDigitalUserId {
            if let relatedDigitalUserId = args?[Constants.relatedDigitalUserId] as? String {
                functionHandler.setRelatedDigitalUserId(relatedDigitalUserId: relatedDigitalUserId)
            }
            result(nil)
        } else if call.method == Constants.setNotificationLoginId {
            if let notificationLoginId = args?[Constants.notificationLoginId] as? String {
                functionHandler.setNotificationLoginId(notificationLoginId: notificationLoginId)
            }
            result(nil)
        } else if call.method == Constants.setPhoneNumber {
            if let msisdn = args?[Constants.msisdn] as? String, let permission = args?[Constants.permission] as? Bool {
                functionHandler.setPhoneNumber(msisdn: msisdn, permission: permission)
            }
            result(nil)
        } else if call.method == Constants.setUserProperty {
            if let key = args?[Constants.key] as? String, let value = args?[Constants.value] as? String {
                functionHandler.setUserProperty(key: key, value: value)

            }
            result(nil)
        } else if call.method == Constants.removeUserProperty {
            if let key = args?[Constants.key] as? String {
                functionHandler.removeUserProperty(key: key)
            }
            result(nil)
        } else if call.method == Constants.registerEmail {
            if let email = args?[Constants.email] as? String,
               let permission = args?[Constants.permission] as? Bool,
               let isCommercial = args?[Constants.isCommercial] as? Bool {
                functionHandler.registerEmail(email: email, permission: permission, isCommercial: isCommercial, result: result)
            }
            result(nil)
        } else if call.method == Constants.getPushMessages {
            functionHandler.getPushMessages(result: result)
        } else if call.method == Constants.getPushMessagesWithId {
            functionHandler.getPushMessagesWithId(result: result)
        } else if call.method == Constants.sendLocationPermission {
            functionHandler.sendLocationPermission()
            result(nil)
        } else if call.method == Constants.requestLocationPermission {
            functionHandler.sendLocationPermission()
            result(nil)
        } else if call.method == Constants.getFavoriteAttributeActions {
            let actionId = args?[Constants.actionId] as? String
            functionHandler.getFavoriteAttributeActions(actionId: actionId, result: result)
        } else if call.method == Constants.getRecommendations {
            if let zoneId = args?[Constants.zoneId] as? String {
                let productCode = args?[Constants.productCode] as? String
                let filters = args?[Constants.filters] as? [NSDictionary] ?? [NSDictionary]()
                functionHandler.getRecommendations(zoneId: zoneId, productCode: productCode, filters: filters, result: result)
            } else {
                result(nil)
            }
        } else if call.method == Constants.getExVisitorId {
            result(functionHandler.getExVisitorId())
        } else if call.method == Constants.setBadge {
            if let count = args?[Constants.count] as? Int {
                functionHandler.setBadge(count: count)
            }
            result(nil)
        } else if call.method == Constants.requestPushNotificationPermission {
            let isProvisional = args?[Constants.isProvisional] as? Bool ?? false
            functionHandler.requestPushNotificationPermission(isProvisional: isProvisional)
            result(nil)
        } else if call.method == Constants.requestIdfa {
            functionHandler.requestIdfa()
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    public func registerToken(deviceToken: Data) {
        functionHandler.registerToken(deviceToken: deviceToken)
    }

    public func handlePush(pushDictionary: [AnyHashable: Any]) {
        functionHandler.handlePush(pushDictionary: pushDictionary)
    }
}
