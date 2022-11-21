import UserNotifications
import RelatedDigitalIOS

public typealias UNMNContent = UNMutableNotificationContent
public typealias UNNC = UNNotificationContent

public class RDNotificationService {
    public static func didReceive(bestAttemptContent: UNMNContent?, contentHandler: @escaping (UNNC) -> Void) {
        RDPush.didReceive(bestAttemptContent, withContentHandler: contentHandler)
    }
    
    public static func serviceExtensionTimeWillExpire(bestAttemptContent: UNMNContent, contentHandler: @escaping (UNNC) -> Void) {
        RDPush.didReceive(bestAttemptContent, withContentHandler: contentHandler)
    }
}
