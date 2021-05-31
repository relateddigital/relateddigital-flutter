import UIKit
import UserNotifications
import UserNotificationsUI
import Euromsg

@available(iOS 10.0, *)
@objc(EMNotificationViewController)
class EMNotificationViewController: UIViewController, UNNotificationContentExtension {

		let appUrl = URL(string: "euromsgExample://")
		let carouselView = EMNotificationCarousel.initView()
		var completion: ((_ url: URL?, _ userInfo: [AnyHashable: Any]?) -> Void)?
		func didReceive(_ notification: UNNotification) {
				carouselView.didReceive(notification)
		}
		func didReceive(_ response: UNNotificationResponse,
										completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
				carouselView.didReceive(response, completionHandler: completion)
		}
		override func loadView() {
				completion = { [weak self] url, userInfo in
						if let url = url {
								self?.extensionContext?.open(url)
								if url.scheme != self?.appUrl?.scheme, let userInfo = userInfo {
										Euromsg.handlePush(pushDictionary: userInfo)
								}
						}
						else if let url = self?.appUrl {
								self?.extensionContext?.open(url)
						}
				}
				carouselView.completion = completion
				//Add if you want to track which element has been selected
				carouselView.delegate = self
				self.view = carouselView
		}
}

/**
 Add if you want to track which carousel element has been selected
 */
extension EMNotificationViewController: CarouselDelegate {
		
		func selectedItem(_ element: EMMessage.Element) {
				//Add your work...
				print("Selected element is => \(element)")
		}
		
}
