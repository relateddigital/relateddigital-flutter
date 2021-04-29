import UserNotifications
import Euromsg

public class RelatedDigitalNotificationService {
	public static func didReceive(bestAttemptContent: UNMutableNotificationContent?, contentHandler: @escaping (UNNotificationContent) -> Void) {
		Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
	}
	
	public static func serviceExtensionTimeWillExpire(bestAttemptContent: UNMutableNotificationContent, contentHandler: @escaping (UNNotificationContent) -> Void) {
		Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
	}
}
