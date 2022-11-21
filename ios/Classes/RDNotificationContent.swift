import UserNotifications
import RelatedDigitalIOS

public class RDNotificationContent {
    public static func initView() -> PushNotificationCarousel {
        return PushNotificationCarousel.initView()
    }
    
    public static func handlePush(userInfo: [AnyHashable: Any]) {
        RDPush.handlePush(pushDictionary: userInfo)
    }
}

