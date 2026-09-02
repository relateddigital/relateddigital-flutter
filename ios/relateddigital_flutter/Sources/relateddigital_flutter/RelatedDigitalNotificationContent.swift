import UserNotifications
import Euromsg

public class RelatedDigitalNotificationContent {
	public static func initView() -> EMNotificationCarousel {
		return EMNotificationCarousel.initView()
	}
	
	public static func handlePush(userInfo: [AnyHashable: Any]) {
		Euromsg.handlePush(pushDictionary: userInfo)
	}
}