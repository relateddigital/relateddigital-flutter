<p align="center">
  <img src="https://raw.githubusercontent.com/relateddigital/relateddigital-flutter/master/screenshots/related-digital-logo.svg" width="400px;"/>
</p>

[![pub package](https://img.shields.io/pub/v/relateddigital_flutter.svg)](https://pub.dartlang.org/packages/relateddigital_flutter)

# Table of Contents

- [Introduction](#Introduction)
    - [Requirements](#Requirements)
- [Installation](#Installation)
    - [Platform Integration](#Platform-Integration)
        - [Android](#Android)
        - [iOS](#iOS)
- [Usage](#Usage)
    - [Initializing](#Initializing)
    - [Push Notifications](#Push-Notifications)
        - [Requesting Permission & Retrieving Token](#Requesting-Permission-&-Retrieving-Token])
        - [Carousel Push Notifications](#Carousel-Push-Notifications)
        - [Set Push Permit](#Set-Push-Permit)
        - [Get Payload List](#Get-Payload-List)
    - [Data Collection](#Data-Collection)
    - [Targeting Actions](#Targeting-Actions)
        - [In-App Messaging](#In-App-Messaging)
        - [Story](#Story)
        - [Geofencing](#Geofencing)
    - [Recommendation](#Recommendation)
    - [App Tracking (Android Only)](#App-Tracking)





# Introduction

This library is the official Flutter SDK of Related Digital.





## Requirements

- iOS 11.0 or later
- Android API level 21 or later





# Installation

- Edit your project's `pubspec.yaml` file:

```yaml
dependencies:
    relateddigital_flutter: ^0.5.5
```
- Run `flutter pub get`

- Import the package:

```dart
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
```





## Platform-Integration


### Android

- Add below line to your `android/build.gradle` file's both `repositories` sections.

```gradle
maven {url 'https://jitpack.io'}
```

- Add the following lines to the `dependencies` section in `project/build.gradle`

```gradle
classpath 'com.google.gms:google-services:4.3.10'
```

- Add the following lines to the end of `app/build.gradle`

```gradle
apply plugin: 'com.google.gms.google-services'
```

- Change your minSdkVersion to 21.

- Change your targetSdkVersion and compileSdkVersion to 32.


- Add the following services to your `AndroidManifest.xml`, within the `<application></application>` tags.

```xml
<service
   android:name="euromsg.com.euromobileandroid.service.EuroFirebaseMessagingService"
   android:exported="false">
   <intent-filter>
       <action android:name="com.google.firebase.MESSAGING_EVENT" />
   </intent-filter>
</service>
```

- Add below meta-data parameters in your **AndroidManifest.xml**
```xml

<meta-data android:name="GoogleAppAlias" android:value="google-app-alias" />
<meta-data android:name="HuaweiAppAlias" android:value="huawei-app-alias" />

<meta-data android:name="VisilabsOrganizationID" android:value="VisilabsOrganizationID" />
<meta-data android:name="VisilabsSiteID" android:value="VisilabsSiteID" />
<meta-data android:name="VisilabsSegmentURL" android:value="http://lgr.visilabs.net" />
<meta-data android:name="VisilabsDataSource" android:value="VisilabsDataSource" />
<meta-data android:name="VisilabsRealTimeURL" android:value="http://rt.visilabs.net" />
<meta-data android:name="VisilabsChannel" android:value="Android" />
<meta-data android:name="VisilabsGeofenceURL" android:value="http://s.visilabs.net/geojson" />
<meta-data android:name="VisilabsGeofenceEnabled" android:value="true" />

<!-- Parameters below are optional -->

<meta-data android:name="VisilabsRequestTimeoutInSeconds" android:value="30" />
<meta-data android:name="VisilabsRESTURL" android:value="VisilabsRESTURL" />
<meta-data android:name="VisilabsEncryptedDataSource" android:value="VisilabsEncryptedDataSource" />
<meta-data android:name="VisilabsTargetURL" android:value="http://s.visilabs.net/json" />
<meta-data android:name="VisilabsActionURL" android:value="http://s.visilabs.net/actjson" />
```

- Add `google-services.json` file to your application’s `app` directory.

- If your app supports `HMS` add `agconnect-services.json` file to your application’s `app` directory.


### iOS

- Change the ios platform version to 11.0 or higher in `Podfile`

```ruby
platform :ios, '11.0'
```

- In your project directory, open the file `ios/Runner.xcworkspace` with Xcode.

- Enable `Push Notifications` and `Background Modes->Remote Notifications` capabilities.

![Xcode Push Capability](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/xcode-push-capability.png)

- In Xcode, add a new **Notification Service Extension** target and name it **NotificationService**. NotificationServiceExtension allows your iOS application to receive rich notifications with images, videos, and badges. It's also required for Related Digital's analytics features and to store and access notification payloads of the last 30 days.

- In your podfile, add below section and then run `pod install`.
```ruby
target 'NotificationService' do
	use_frameworks!
	pod 'Euromsg'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
		config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
	end
  end
end
```
- Set **NotificationService** target's deployment target to iOS 11.
  
- Replace **NotificationService.swift** file content with the code below.

```swift
import UserNotifications
import Euromsg

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        Euromsg.configure(appAlias: "ios-app-alias", enableLog: true)
        Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
    }

    override func serviceExtensionTimeWillExpire() {
        guard let contentHandler = self.contentHandler else {
            return;
        }
        guard let bestAttemptContent = self.bestAttemptContent else {
            return;
        }
        contentHandler(bestAttemptContent)
    }
}
```

- Enable `App Groups` Capability for your targets. App Groups allow your app to execute code when a notification is recieved, even if your app is not active. This is required for Related Digital's analytics features and to store and access notification payloads of the last 30 days.

    - In your Main App Target go to `Signing & Capabilities > All`. 
    - Click `+ Capability` if you do not have App Groups in your app yet.
    - Select App Groups.
    - Under App Groups click the `+` button.
    - Set the `App Groups` container to be `group.BUNDLE_ID.relateddigital` where `BUNDLE_ID` is the same as set in `Bundle Identifier`.
    - Press OK.
    - In the NotificationServiceExtension Target
    - Go to `Signing & Capabilities > All`
    - Click `+ Capability` if you do not have App Groups in your app yet.
    - Select App Groups
    - In the NotificationContentExtension Target go to `Signing & Capabilities` > All`.
    - Click `+ Capability`.
    - Select App Groups
    - Under App Groups click the `+` button.
    - Set the `App Groups` container to be `group.BUNDLE_ID.relateddigital` where `BUNDLE_ID` is the same as your Main App Target `Bundle Identifier`. Do Not Include `NotificationServiceExtension` and `NotificationContentExtension`.
    - Press OK

![App Groups](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/appgroups.png)

![App Groups Name](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/appgroups-name.png)



- If you want to use **AdvertisingTrackingID** with **isIDFAEnabled** parameter (see [Usage](#Usage) below), you need to add this key to your **Info.plist** file for iOS 14 and above. 
```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use advertising identifier!</string>
```


# Usage





## Initializing

Import the library

```dart
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter/response_models.dart';
```

Initialize the library

```dart
final RelateddigitalFlutter relatedDigitalPlugin = RelateddigitalFlutter();

@override
void initState() {
  super.initState();
  initLib();
}

Future<void> initLib() async {
  var initRequest = RDInitRequestModel(
    appAlias: Platform.isIOS ? 'ios-app-alias' : 'android-app-alias',
    huaweiAppAlias: 'huawei-app-alias', // pass empty String if your app does not support HMS
    androidPushIntent: 'com.test.MainActivity', // Android only
    organizationId: 'ORG_ID',
    siteId: 'SITE_ID',
    dataSource: 'DATA_SOURCE',
    maxGeofenceCount: 20,  // iOS only
    geofenceEnabled: true,
    inAppNotificationsEnabled: true,
    logEnabled: true,
    isIDFAEnabled: true,  // iOS only
  );

  await relatedDigitalPlugin.init(initRequest, _readNotificationCallback);
}

void _readNotificationCallback(dynamic result) {
  print(result);
}
```





## Push Notifications


### Requesting Permission & Retrieving Token

Add the lines below to request push notification permission and retrieve token.

#### IOS
- Instead of having to prompt the user for permission to send them push notifications, your app can request provisional authorization. In order to enable provisional authorization, you should set `isProvisional` parameter of `requestPermission` method to `true`.

```dart
String token = '-';

void _getTokenCallback(RDTokenResponseModel result) {
  if(result != null && result.deviceToken != null && result.deviceToken.isNotEmpty) {
    setState(() {
      token = result.deviceToken;
    });
  }
  else {
    setState(() {
      token = 'Token not retrieved';
    });
  }
}

Future<void> requestPermission() async {
  await relatedDigitalPlugin.requestPermission(_getTokenCallback, isProvisional: true);
}
```



### Carousel Push Notifications
To be able to receive push notifications with carousel, follow the steps below.

#### IOS
- In Xcode, add a new **Notification Content Extension** target and name it **NotificationContent**.
- In your podfile, add below section and then run `pod install`.
```ruby
target 'NotificationContent' do
	use_frameworks!
	pod 'Euromsg'
end
```
- Set **NotificationContent** target's deployment target to iOS 11.
- Delete **MainInterface.storyboard** and **NotificationContent.swift** files. Then create a swift file named **EMNotificationViewController.swift** under the NotificationContent folder.
- Replace **EMNotificationViewController.swift** file content with the code below.
```swift
import UIKit
import UserNotifications
import UserNotificationsUI
import Euromsg

@objc(EMNotificationViewController)
class EMNotificationViewController: UIViewController, UNNotificationContentExtension {
    
    let carouselView = EMNotificationCarousel.initView()
    var completion: ((_ url: URL?, _ bestAttemptContent: UNMutableNotificationContent?) -> Void)?
    
    var notificationRequestIdentifier = ""
    
    func didReceive(_ notification: UNNotification) {
        notificationRequestIdentifier = notification.request.identifier
        Euromsg.configure(appAlias: "relateddigital-flutter-example-ios", launchOptions: nil, enableLog: true)
        carouselView.didReceive(notification)
    }
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        carouselView.didReceive(response, completionHandler: completion)

    }
    override func loadView() {
        completion = { [weak self] url, bestAttemptContent in
            if let identifier = self?.notificationRequestIdentifier {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
                UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { notifications in
                    bestAttemptContent?.badge =  NSNumber(value: notifications.count)
                })
            }
            if let url = url {
                if #available(iOSApplicationExtension 12.0, *) {
                    self?.extensionContext?.dismissNotificationContentExtension()
                }
                self?.extensionContext?.open(url)
            } else {
                if #available(iOSApplicationExtension 12.0, *) {
                    self?.extensionContext?.performNotificationDefaultAction()
                }
            }
        }
        carouselView.completion = completion
        carouselView.delegate = self
        self.view = carouselView
    }
}

/**
 Add if you want to track which carousel element has been selected
 */
extension EMNotificationViewController: CarouselDelegate {
    
    func selectedItem(_ element: EMMessage.Element) {
        // Add your work...
        print("Selected element is => \(element)")
    }
    
}
```

- In your **NotificationContent/Info.plist** add below section

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>UNNotificationExtensionCategory</key>
        <string>carousel</string>
        <key>UNNotificationExtensionDefaultContentHidden</key>
        <false />
        <key>UNNotificationExtensionInitialContentSizeRatio</key>
        <real>1</real>
        <key>UNNotificationExtensionUserInteractionEnabled</key>
        <true />
    </dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.usernotifications.content-extension</string>
    <key>NSExtensionPrincipalClass</key>
    <string>NotificationContent.EMNotificationViewController</string>
</dict>
```

### Set Push Permit
You can only call `setNotificationPermission` method to enable or disable push notifications for the application. 

```dart
relatedDigitalPlugin.setNotificationPermission(true);
```

### Get-Payload-List
You can access payload list of last 30 days if you have completed iOS `NotificationServiceExtension` and `App Groups` setup. Using `getPushMessages` method you can access these payloads

```dart
PayloadListResponse payloadListResponse = await relatedDigitalPlugin.getPushMessages();
```


## Data Collection

Related Digital uses events to collect data from mobile applications. The developer needs to implement the methods provided by SDK. `customEvent`  is a generic method to track user events. `customEvent`  takes 2 parameters: pageName and properties.

* **pageName** : The current page of your application. If your event is not related to a page view, you should pass a value related to the event. If you pass an empty **String** the event would be considered invalid and discarded.
* **parameters** : A collection of key/value pairs related to the event. If your event does not have additional data apart from page name, passing an empty **Map** acceptable.

Some of the most common events:


### Sign Up

```dart
String userId = 'userId';
// optional
Map<String, String> properties = {
  'OM.b_sgnp':'1'
};

await relatedDigitalPlugin.signUp(userId, properties: properties);
```


### Login

```dart
String userId = 'userId';
// optional
Map<String, String> properties = {
  'OM.b_login':'1'
};

await relatedDigitalPlugin.login(userId, properties: properties);
```


### Page View

Use the following implementation of `customEvent`  method to record the page name the visitor is currently viewing. You may add extra parameters to properties  **Map** or you may leave it empty.

```dart
String pageName = 'Page Name';
Map<String, String> parameters = {};
await relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Product View

Use the following implementation of `customEvent`  when the user displays a product in the mobile app.

```dart
String pageName = 'Product View';
Map<String, String> parameters = {
  'OM.pv' : productCode, 
  'OM.pn' : productName, 
  'OM.ppr' : productPrice, 
  'OM.pv.1' : productBrand, 
  'OM.inv': inventory // Number of items in stock
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Add to Cart

Use the following implementation of `customEvent`  when the user adds items to the cart or removes.

```dart
String pageName = 'Cart';
Map<String, String> parameters = {
  'OM.pbid' : basketID, 
  'OM.pb' : 'Product1 Code;Product2 Code', 
  'OM.pu' : 'Product1 Quantity;Product2 Quantity', 
  'OM.ppr' : 'Product1 Price*Product1 Quantity;Product2 Price*Product2 Quantity'
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Product Purchase

Use the following implementation of `customEvent` when the user buys one or more items.

```dart
String pageName = 'Purchase';
Map<String, String> parameters = {
  'OM.tid' : transactionID, 
  'OM.pp' : 'Product1 Code;Product2 Code', 
  'OM.pu' : 'Product1 Quantity;Product2 Quantity', 
  'OM.ppr' : 'Product1 Price*Product1 Quantity;Product2 Price*Product2 Quantity',
  'OM.exVisitorID' : userId
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Product Category Page View

When the user views a category list page, use the following implementation of `customEvent`.

```dart
String pageName = 'Category View';
Map<String, String> parameters = {
  'OM.clist': '12345',
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### In App Search

If the mobile app has a search functionality available, use the following implementation of `customEvent`.

```dart
String pageName = 'In App Search';
Map<String, String> parameters = {
  'OM.OSS': searchKeyword,
  'OM.OSSR': searchResult.length,
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Banner Click

You can monitor banner click data using the following implementation of `customEvent`.

```dart
String pageName = 'Banner Click';
Map<String, String> parameters = {
  'OM.OSB': 'Banner Name/Banner Code',
};
relatedDigitalPlugin.customEvent(pageName, parameters);;
```


### Add To Favorites

When the user adds a product to their favorites, use the following implementation of `customEvent`.

```dart
String pageName = 'Add To Favorites';
Map<String, String> parameters = {
  'OM.pf' : productCode, 
  'OM.pfu' : '1',
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Remove from Favorites

When the user removes a product from their favorites, use the following implementation of `customEvent`.

```dart
String pageName = 'Add To Favorites';
Map<String, String> parameters = {
  'OM.pf' : productCode, 
  'OM.pfu' : '-1',
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```

### Logout
To remove all the user related data from local storage, use the method below.

```dart
await relatedDigitalPlugin.logout();
```



## Targeting Actions


### In-App Messaging

**In-app messages** are notifications to your users when they are directly active in your mobile app. To enable **In-App Messaging** feature you need to set the value of `inAppNotificationsEnabled` parameter to `true` when calling `init` to initialize the SDK.

The existence of a relevant **in-app message** for an event controlled by after each `customEvent` call. You can create and customize your **in-app messages** on https://intelligence.relateddigital.com/#Target/TargetingAction/TAList page of RMC administration panel.

There are 9 types of **in-app messages**:

|               Pop-up - Image, Header, Text & Button              | Mini-icon&text                                                             | Full Screen-image                                                |
|:----------------------------------------------------------------:|----------------------------------------------------------------------------|------------------------------------------------------------------|
| ![full](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/full.png)                 | ![mini](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/mini.png)                           | ![full_image](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/full_image.png)     |
| Full Screen-image&button                                         | Pop-up - Image, Header, Text & Button                                      |                              Pop-up-Survey                       |
| ![image_button](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/image_button.png) | ![image_text_button](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/image_text_button.png) | ![smile_rating](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/smile_rating.png) |
| Pop-up - NPS with Text & Button                                  | Native Alert & Actionsheet                                                 |  NPS with numbers                                                   |
| ![nps](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/nps.png)                   | ![nps_with_numbers](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/alert.png)   | ![nps_with_numbers](https://github.com/relateddigital/relateddigital-flutter/blob/master/screenshots/inappnotification/nps_with_numbers.png) |

### Story
Follow the step below to add a countdown to your stories.

**iOS**

Add below lines to your project target's `Build Phases`->`Copy Bundle Resources` section. Select `Create folder references` when prompted.
  * `Pods/VisilabsIOS/Sources/TargetingAction/Story/Views/timerView/timerView.xib`

**Android**

No special installation required

**Usage**

To add story view to your app, import `RDStoryView` and use as below:
```dart
import 'package:relateddigital_flutter/rd_story_view.dart';
...
...
RDStoryView(
	actionId: '975', // Story actionid created from panel
	relatedDigitalPlugin: widget.relatedDigitalPlugin,
	onItemClick: (Map<String, String> result) {
		print(result);
	}
)
```

### Geofencing

#### IOS
- In Xcode, add **NSLocationAlwaysAndWhenInUseUsageDescription** and **NSLocationWhenInUseUsageDescription** keys to the **Info.plist** file.
- In Xcode, enable **Background fetch** and **Location updates** background modes.
- When initializing plugin, set **geofenceEnabled** to **true**. Also provide a number for **maxGeofenceCount** parameter (max. 20 supported).

#### Android
- Add below permissions in your **AndroidManifest.xml**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
````
- Add below service and receivers in your **AndroidManifest.xml**
```xml
<service android:name="com.visilabs.android.gps.geofence.GeofenceTransitionsIntentService"
    android:enabled="true"
    android:permission="android.permission.BIND_JOB_SERVICE" />

<receiver android:name="com.visilabs.android.gps.geofence.VisilabsAlarm" android:exported="false"/>

<receiver
    android:name="com.visilabs.android.gps.geofence.GeofenceBroadcastReceiver"
    android:enabled="true"
    android:exported="false"/>
```

### Recommendation
Use **getRecommendations** method as below to retrieve product recommendations. This method takes mandatory **zoneId** and **productCode** parameters with optional **filters** parameter.
```dart
import 'package:relateddigital_flutter/recommendation_filter.dart';

Future<void> getRecommendations() async {
  String zoneId = '6';
  String productCode = '';

  // optional
  Map<String, Object> filter = {
    RDRecommendationFilter.attribute: RDRecommendationFilterAttribute.PRODUCTNAME,
    RDRecommendationFilter.filterType: RDRecommendationFilterType.like,
    RDRecommendationFilter.value: null
  };

  List filters = [
    filter
  ];

  List result = await widget.relatedDigitalPlugin.getRecommendations(zoneId, productCode);
  // List result = await relatedDigitalPlugin.getRecommendations(zoneId, productCode, filters: filters);
  print(result.toString());
}
```

### App Tracking
*(Android Only)*
Use **sendTheListOfAppsInstalled** method to track installed apps on android.
```dart
await widget.relatedDigitalPlugin.sendTheListOfAppsInstalled();
```
Add one of the sections below to your **AndroidManifest.xml** in order to use this feature. 
   
*Option 1*
```xml
<manifest package="com.example.myApp">
    <queries>
        <package android:name="com.example.app1" />
        <package android:name="com.example.app2" />
    </queries>
</manifest>
```
*Option 2*
```xml
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" 
tools:ignore="QueryAllPackagesPermission" />
```






























<!---

TODO:
initVisilabs

RelatedDigitalPlugin.java ve RelatedDigitalChannelHandler.swift içerisinde 
euromsg parametreleri boş geliyor ise initEuroMsg çağırılmasın
visilabs parametreleri boş geliyor ise initVisilabs çağırılmasın

ya da init metoduna bunlarla ilgili bool parametre ekleyelim.

FirebaseOperations.java ve HuaweiOperations.java altında eğer visilabs de kullanılıyor ise 
token için customEvent metodu çağırılabilir düşün?

login and signUp metodları SDK'ya eklenmeli

inAppNotificationsEnabled android için de kullanılır hale getirilebilir.

RelatedDigitalChannelHandler enableLog Visilabs için de kullanılmalı.

BU KEYİ EKLEMEYİNCE EUROMSG REQUESTLERİ GİTMİYOR
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>



//TODO: app/build.gradle defaultConfig altına neden multiDexEnabled true gerekiyormuş?

//TODO: project/build.gradle lintOptions android { { disable 'InvalidPackage' } } gerekli mi?


## ANDROID

huawei kısmını da test et



minSdkVersion'ı 21 yapmak gerekiyor.


Geofence için de bir şeyler eklenmesi gerekiyor.







## IOS

Runner.xcworkspace aç
bütün targets için ios deployment target'ı 9.0'dan 10.0'a çıkar
bütün targets'lar için deployment info'yu 9.0'dan 10.0'a çıkar
Pods TARGETS Flutter Build Settings iOS Deployment Target'ları 8.0'dan 10.0'a çıkar

bütüb target'larda team olarak visilabs admin'i seç



example podfile # platform :ios, 9 u '10.0' a çektim.
2. satırdaki comment'i kaldır
example podfile son kısmı değiştirdim.




podfile ve podspec'leri düzelt.

<array>
    <string>fetch</string>
    <string>location</string>
    <string>remote-notification</string>
</array>







https://raw.githubusercontent.com/relateddigital/visilabs-ios/master/README.md ## Data Collection Vislabs yazıyor düzelt




-->
