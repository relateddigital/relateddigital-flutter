import UIKit
import Flutter
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import relateddigital_flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let rdChannelName = "relateddigital_flutter"
  private let rdDebugLogMethod = "RD/debugLog"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self
    rdLog("notification delegate=\(String(describing: UNUserNotificationCenter.current().delegate))")

    if let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: plistPath),
       let projectId = plist["PROJECT_ID"] as? String {
      rdLog("GoogleService-Info.plist PROJECT_ID=\(projectId) BUNDLE_ID=\(plist["BUNDLE_ID"] ?? "nil")")
      if projectId == "replace-me" {
        rdLog("FCM BLOCKED – replace GoogleService-Info.plist with the file from Firebase Console for com.relateddigital.relateddigital-flutter-example")
      }
    } else {
      rdLog("FCM BLOCKED – GoogleService-Info.plist not in Runner bundle")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    flushNSELogs()
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
    rdLog("APNs token=\(tokenString)")
    Messaging.messaging().apnsToken = deviceToken
    rdLog("assigned Messaging.apnsToken for FCM mapping")
    RelatedDigitalPushHandler.registerToken(deviceToken)
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    rdLog("[didReceiveRemoteNotification] variant=\(payloadVariant(userInfo)) userInfo=\(String(describing: userInfo))")
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    rdLog("[willPresent] variant=\(payloadVariant(userInfo)) keys=\(userInfo.keys.map { String(describing: $0) }.sorted().joined(separator: ",")) userInfo=\(String(describing: userInfo))")
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .badge, .sound])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    rdLog("[didReceive] variant=\(payloadVariant(userInfo)) userInfo=\(String(describing: userInfo))")
    if RelatedDigitalPushHandler.isRelatedDigitalPayload(userInfo) {
      RelatedDigitalPushHandler.handlePush(userInfo)
    }
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  private func payloadVariant(_ userInfo: [AnyHashable: Any]) -> String {
    if RelatedDigitalPushHandler.isRelatedDigitalPayload(userInfo) {
      return "RELATED_DIGITAL"
    }
    if RelatedDigitalPushHandler.isFcmPayload(userInfo) {
      return "FCM"
    }
    return "OTHER"
  }

  private func rdLog(_ message: String) {
    let line = "[RDPush][AppDelegate] \(message)"
    print(line)
    NSLog("%@", line)
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    FlutterMethodChannel(name: rdChannelName, binaryMessenger: controller.binaryMessenger)
      .invokeMethod(rdDebugLogMethod, arguments: line)
  }

  private func flushNSELogs() {
    let defaults = UserDefaults(suiteName: "group.com.relateddigital.relateddigital-flutter-example.relateddigital")
    let logs = defaults?.stringArray(forKey: "RDPushNSELog") ?? []
    guard !logs.isEmpty else {
      return
    }
    defaults?.removeObject(forKey: "RDPushNSELog")
    for line in logs {
      rdLog("[NSE-buffered] \(line)")
    }
  }
}
