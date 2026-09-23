import UserNotifications
import Euromsg
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            return
        }

        var userInfo = bestAttemptContent.userInfo
        let emPushSp = userInfo["emPushSp"]
        let pushId = userInfo["pushId"]
        let isRD = emPushSp != nil || pushId != nil
        let isFCM = userInfo["gcm.message_id"] != nil
            || userInfo["google.c.sender.id"] != nil
            || userInfo["google.c.a.e"] != nil
            || userInfo["fcm_options"] != nil
        let variant = isRD ? "RELATED_DIGITAL" : (isFCM ? "FCM" : "OTHER")
        let keys = userInfo.keys.map { String(describing: $0) }.sorted().joined(separator: ",")
        persistNSELog("variant=\(variant) emPushSp=\(String(describing: emPushSp)) pushId=\(String(describing: pushId)) keys=[\(keys)]")
        persistNSELog("userInfo=\(String(describing: userInfo))")

        if isRD {
            persistNSELog("entering RELATED DIGITAL variant – Euromsg.didReceive")
            userInfo.removeValue(forKey: "fcm_options")
            bestAttemptContent.userInfo = userInfo
            Euromsg.configure(appAlias: "relateddigital-flutter-example-ios", launchOptions: nil, enableLog: true)
            Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
        } else {
            persistNSELog("entering FCM variant – Messaging.serviceExtension")
            Messaging.serviceExtension().populateNotificationContent(bestAttemptContent, withContentHandler: contentHandler)
        }
    }

    private func persistNSELog(_ message: String) {
        let line = "[RDPush][NSE] \(message)"
        print(line)
        NSLog("%@", line)
        let defaults = UserDefaults(suiteName: "group.com.relateddigital.relateddigital-flutter-example.relateddigital")
        var logs = defaults?.stringArray(forKey: "RDPushNSELog") ?? []
        logs.append("\(Date()) \(message)")
        if logs.count > 50 {
            logs = Array(logs.suffix(50))
        }
        defaults?.set(logs, forKey: "RDPushNSELog")
    }

    override func serviceExtensionTimeWillExpire() {
        persistNSELog("serviceExtensionTimeWillExpire")
        guard let contentHandler = self.contentHandler else {
            return;
        }
        guard let bestAttemptContent = self.bestAttemptContent else {
            return;
        }
        contentHandler(bestAttemptContent)
    }
}
