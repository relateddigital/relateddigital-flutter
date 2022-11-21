import Flutter
import UIKit

typealias FMChannel = FlutterMethodChannel
public typealias UIA = UIApplication

public class SwiftRelatedDigitalPlugin: NSObject, FlutterPlugin {
    
    var channel: FMChannel = FMChannel()
    var channelHandler: RDChannelHandler
    
    override public init() {
        self.channelHandler = RDChannelHandler()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let _channel = FMChannel(name: Constants.channelName, binaryMessenger: registrar.messenger())
        let instance = SwiftRelatedDigitalPlugin()
        let factory = RDStoryViewFactory(messenger: registrar.messenger(), channel: _channel)
        registrar.addMethodCallDelegate(instance, channel: _channel)
        registrar.addApplicationDelegate(instance)
        registrar.register(factory, withId: Constants.storyView)
        instance.setChannel(fChannel: _channel)
    }
    
    func setChannel(fChannel: FMChannel) {
        self.channel = fChannel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.channelHandler.handleResult(call, result: result)
    }
    
    public func application(_ application: UIA, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        if let userInfo = launchOptions[UIA.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.channelHandler.channel = self.channel
            self.channelHandler.handlePush(pushDictionary: userInfo)
            self.channelHandler.pushDictionary = userInfo
        }
        
        return true
    }
    
    public func application(_ application: UIA, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.channelHandler.registerToken(deviceToken: deviceToken)
        
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.channel.invokeMethod(Constants.M_TOKEN_RETRIEVED, arguments: [
            "deviceToken": tokenString
        ])
    }
    
    public func application(_ application: UIA, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        self.channelHandler.handlePush(pushDictionary: userInfo)
        
        self.channel.invokeMethod(Constants.notificationOpened, arguments: [
            Constants.userInfo: userInfo
        ])
        
        return true
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.channelHandler.handlePush(pushDictionary: response.notification.request.content.userInfo)
        completionHandler()
        
        self.channel.invokeMethod(Constants.notificationOpened, arguments: [
            Constants.userInfo: response.notification.request.content.userInfo
        ])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
