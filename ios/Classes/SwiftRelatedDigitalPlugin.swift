import Flutter
import UIKit
import UserNotifications
import Euromsg

public class SwiftRelatedDigitalPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
    var channel: FlutterMethodChannel = FlutterMethodChannel()
    var channelHandler: RelatedDigitalChannelHandler
    
    override public init() {
        self.channelHandler = RelatedDigitalChannelHandler.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let _channel = FlutterMethodChannel(name: Constants.CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftRelatedDigitalPlugin()
        let factory = RelatedDigitalStoryViewFactory(messenger: registrar.messenger(), channel: _channel)
        let bannerFactory = RelatedDigitalBannerViewFactory(messenger: registrar.messenger(), channel: _channel)
        
        registrar.addMethodCallDelegate(instance, channel: _channel)
        registrar.addApplicationDelegate(instance)
        registrar.register(factory, withId: Constants.STORY_VIEW_NAME)
        registrar.register(bannerFactory, withId: Constants.BANNER_VIEW_NAME)
        
        instance.setChannel(fChannel: _channel)
        RelatedDigitalPushHandler.log("plugin registered")
    }
    
    func setChannel(fChannel: FlutterMethodChannel) {
        self.channel = fChannel
        self.channelHandler.channel = fChannel
        RelatedDigitalPushHandler.channel = fChannel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.channelHandler.handleResult(call, result: result)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        let center = UNUserNotificationCenter.current()
        RelatedDigitalPushHandler.log("didFinishLaunching existing delegate=\(String(describing: center.delegate))")
        if center.delegate == nil {
            if let appDelegate = application.delegate as? UNUserNotificationCenterDelegate {
                center.delegate = appDelegate
                RelatedDigitalPushHandler.log("assigned Flutter AppDelegate as notification delegate")
            } else {
                center.delegate = self
                RelatedDigitalPushHandler.log("assigned plugin as notification delegate")
            }
        } else {
            RelatedDigitalPushHandler.log("left existing notification delegate in place: \(String(describing: center.delegate))")
        }

        if let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            RelatedDigitalPushHandler.logPayload("launchOptions", userInfo)
            if RelatedDigitalPushHandler.isRelatedDigitalPayload(userInfo) {
                self.channelHandler.channel = self.channel
                self.channelHandler.handlePush(pushDictionary: userInfo)
                self.channelHandler.pushDictionary = userInfo
            }
        }
        
        return true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        RelatedDigitalPushHandler.log("APNs token=\(tokenString)")
        self.channelHandler.registerToken(deviceToken: deviceToken)
        
        self.channel.invokeMethod(Constants.M_TOKEN_RETRIEVED, arguments: [
            "deviceToken": tokenString
        ])
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        RelatedDigitalPushHandler.logPayload("didReceiveRemoteNotification", userInfo)
        guard RelatedDigitalPushHandler.isRelatedDigitalPayload(userInfo) else {
            RelatedDigitalPushHandler.log("didReceiveRemoteNotification skipping – NOT Related Digital (FCM/other)")
            return false
        }
        RelatedDigitalPushHandler.log("didReceiveRemoteNotification entering RELATED DIGITAL variant")
        self.channelHandler.handlePush(pushDictionary: userInfo)
        
        self.channel.invokeMethod(Constants.M_NOTIFICATION_OPENED, arguments: [
            "userInfo": userInfo
        ])
        completionHandler(.newData)
        return true
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        RelatedDigitalPushHandler.logPayload("didReceive-tap", userInfo)
        if RelatedDigitalPushHandler.isRelatedDigitalPayload(userInfo) {
            RelatedDigitalPushHandler.log("didReceive-tap entering RELATED DIGITAL variant")
            self.channelHandler.handlePush(pushDictionary: userInfo)
            self.channel.invokeMethod(Constants.M_NOTIFICATION_OPENED, arguments: [
                "userInfo": userInfo
            ])
        } else {
            RelatedDigitalPushHandler.log("didReceive-tap skipping – NOT Related Digital (FCM/other)")
        }
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        RelatedDigitalPushHandler.logPayload("willPresent", notification.request.content.userInfo)
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        RelatedDigitalPushHandler.flushAppGroupLogs()
        RelatedDigitalPushHandler.flushPendingLogs()
        RelatedDigitalPushHandler.log("applicationDidBecomeActive")
    }
}

@objc public class RelatedDigitalPushHandler: NSObject {
    static weak var channel: FlutterMethodChannel?
    static var enableLog = false
    private static var logBuffer: [String] = []
    private static let bufferLimit = 80
    private static let nseLogKey = "RDPushNSELog"
    private static let exampleAppGroupId = "group.com.relateddigital.relateddigital-flutter-example.relateddigital"

    @objc public static func isRelatedDigitalPayload(_ userInfo: [AnyHashable: Any]?) -> Bool {
        guard let userInfo = userInfo else {
            return false
        }
        return userInfo["emPushSp"] != nil || userInfo["pushId"] != nil
    }

    @objc public static func log(_ message: String) {
        guard enableLog else {
            return
        }
        let line = "[RDPush] \(message)"
        print(line)
        NSLog("%@", line)
        logBuffer.append(line)
        if logBuffer.count > bufferLimit {
            logBuffer.removeFirst(logBuffer.count - bufferLimit)
        }
        DispatchQueue.main.async {
            channel?.invokeMethod(Constants.M_DEBUG_LOG, arguments: line)
        }
    }

    @objc public static func isFcmPayload(_ userInfo: [AnyHashable: Any]?) -> Bool {
        guard let userInfo = userInfo else {
            return false
        }
        return userInfo["gcm.message_id"] != nil
            || userInfo["google.c.sender.id"] != nil
            || userInfo["google.c.a.e"] != nil
            || userInfo["fcm_options"] != nil
    }

    @objc public static func payloadVariant(_ userInfo: [AnyHashable: Any]?) -> String {
        if isRelatedDigitalPayload(userInfo) {
            return "RELATED_DIGITAL"
        }
        if isFcmPayload(userInfo) {
            return "FCM"
        }
        return "OTHER"
    }

    @objc public static func logPayload(_ source: String, _ userInfo: [AnyHashable: Any]?) {
        let variant = payloadVariant(userInfo)
        let keys = userInfo?.keys.map { String(describing: $0) }.sorted().joined(separator: ",") ?? ""
        let emPushSp = userInfo?["emPushSp"].map { String(describing: $0) } ?? "nil"
        let pushId = userInfo?["pushId"].map { String(describing: $0) } ?? "nil"
        let fcmId = userInfo?["gcm.message_id"].map { String(describing: $0) } ?? "nil"
        log("[\(source)] variant=\(variant) emPushSp=\(emPushSp) pushId=\(pushId) gcm.message_id=\(fcmId) keys=[\(keys)]")
        log("[\(source)] userInfo=\(String(describing: userInfo))")
    }

    @objc public static func handlePush(_ userInfo: [AnyHashable: Any]) {
        logPayload("handlePush", userInfo)
        guard isRelatedDigitalPayload(userInfo) else {
            log("[handlePush] not Related Digital – skip Euromsg.handlePush")
            return
        }
        log("[handlePush] calling Euromsg.handlePush")
        Euromsg.handlePush(pushDictionary: userInfo)
    }

    @objc public static func registerToken(_ deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        log("[registerToken] \(tokenString)")
        Euromsg.registerToken(tokenData: deviceToken)
    }

    static func flushPendingLogs() {
        DispatchQueue.main.async {
            for line in logBuffer {
                channel?.invokeMethod(Constants.M_DEBUG_LOG, arguments: line)
            }
        }
    }

    static func flushAppGroupLogs() {
        let suiteNames = [
            exampleAppGroupId,
            Bundle.main.object(forInfoDictionaryKey: "RDPushAppGroup") as? String
        ].compactMap { $0 }
        for suite in Set(suiteNames) {
            guard let defaults = UserDefaults(suiteName: suite) else {
                continue
            }
            let logs = defaults.stringArray(forKey: nseLogKey) ?? []
            guard !logs.isEmpty else {
                continue
            }
            defaults.removeObject(forKey: nseLogKey)
            for line in logs {
                log("[NSE-buffered] \(line)")
            }
        }
    }

    @objc public static func persistExtensionLog(_ message: String, appGroup: String) {
        let line = "\(Date()) \(message)"
        print("[RDPush][NSE] \(message)")
        NSLog("[RDPush][NSE] %@", message)
        guard let defaults = UserDefaults(suiteName: appGroup) else {
            return
        }
        var logs = defaults.stringArray(forKey: nseLogKey) ?? []
        logs.append(line)
        if logs.count > 50 {
            logs = Array(logs.suffix(50))
        }
        defaults.set(logs, forKey: nseLogKey)
    }
}
