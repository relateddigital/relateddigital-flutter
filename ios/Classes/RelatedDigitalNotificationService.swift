import UserNotifications
import Euromsg

public class RelatedDigitalNotificationService {
	public static func didReceive(bestAttemptContent: UNMutableNotificationContent?, contentHandler: @escaping (UNNotificationContent) -> Void) {
		didReceive(bestAttemptContent: bestAttemptContent, contentHandler: contentHandler, fallback: nil)
	}

	public static func didReceive(bestAttemptContent: UNMutableNotificationContent?,
								  contentHandler: @escaping (UNNotificationContent) -> Void,
								  fallback: ((UNMutableNotificationContent, @escaping (UNNotificationContent) -> Void) -> Void)?) {
		guard let content = bestAttemptContent else {
			return
		}
		if isRelatedDigitalPayload(content.userInfo) {
			var userInfo = content.userInfo
			userInfo.removeValue(forKey: "fcm_options")
			content.userInfo = userInfo
			Euromsg.didReceive(content, withContentHandler: contentHandler)
		} else if let fallback = fallback {
			fallback(content, contentHandler)
		} else {
			contentHandler(content)
		}
	}
	
	public static func serviceExtensionTimeWillExpire(bestAttemptContent: UNMutableNotificationContent, contentHandler: @escaping (UNNotificationContent) -> Void) {
		contentHandler(bestAttemptContent)
	}

	private static func isRelatedDigitalPayload(_ userInfo: [AnyHashable: Any]) -> Bool {
		return userInfo["emPushSp"] != nil || userInfo["pushId"] != nil
	}
}
