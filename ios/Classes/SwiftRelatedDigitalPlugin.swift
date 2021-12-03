import Flutter
import UIKit

public class SwiftRelatedDigitalPlugin: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel = FlutterMethodChannel()
    var channelHandler: RelatedDigitalChannelHandler
    
    override public init() {
        self.channelHandler = RelatedDigitalChannelHandler.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let _channel = FlutterMethodChannel(name: Constants.CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftRelatedDigitalPlugin()
        let factory = RelatedDigitalStoryViewFactory(messenger: registrar.messenger(), channel: _channel)
        
        registrar.addMethodCallDelegate(instance, channel: _channel)
        registrar.addApplicationDelegate(instance)
        registrar.register(factory, withId: Constants.STORY_VIEW_NAME)
        
        instance.setChannel(fChannel: _channel)
    }
    
    func setChannel(fChannel: FlutterMethodChannel) {
        self.channel = fChannel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.channelHandler.handleResult(call, result: result)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        if let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.channelHandler.channel = self.channel
            self.channelHandler.handlePush(pushDictionary: userInfo)
            self.channelHandler.pushDictionary = userInfo
        }
        
        return true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.channelHandler.registerToken(deviceToken: deviceToken)
        
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.channel.invokeMethod(Constants.M_TOKEN_RETRIEVED, arguments: [
            "deviceToken": tokenString
        ])
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        self.channelHandler.handlePush(pushDictionary: userInfo)
        
        self.channel.invokeMethod(Constants.M_NOTIFICATION_OPENED, arguments: [
            "userInfo": userInfo
        ])
        
        return true
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.channelHandler.handlePush(pushDictionary: response.notification.request.content.userInfo)
        completionHandler()
        
        self.channel.invokeMethod(Constants.M_NOTIFICATION_OPENED, arguments: [
            "userInfo": response.notification.request.content.userInfo
        ])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
