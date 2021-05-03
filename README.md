<p align="center">
  <img src="https://www.relateddigital.com/i/assets/rd-2019/images/svg/related-digital-logo.svg" width="400px;"/>
</p>

[![pub package](https://img.shields.io/pub/v/relateddigital_flutter.svg)](https://pub.dartlang.org/packages/relateddigital_flutter)
<a href="https://github.com/relateddigital/relateddigital-flutter/releases">
    <img src="https://img.shields.io/github/release/CleverTap/clevertap-flutter.svg" />
</a>

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
    - [Data Collection](#Data-Collection)
    - [Targeting Actions](#Targeting-Actions)
        - [In-App Messaging](#In-App-Messaging)





# Introduction

This library is the official Flutter SDK of Related Digital.





## Requirements

- iOS 10.0 or later
- Android API level 21 or later





# Installation

- Edit your project's `pubspec.yaml` file:

```yaml
dependencies:
    relateddigital_flutter: ^0.1.0
```
- Run `flutter pub get`

- Import the package:

```dart
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
```





## Platform-Integration


### Android

- Add the following lines to the `repositories` section in `project/build.gradle`

```gradle
maven {url 'http://developer.huawei.com/repo/'} // skip if your app does not support HMS
```

- Add the following lines to the `dependencies` section in `project/build.gradle`

```gradle
classpath 'com.google.gms:google-services:4.3.5'
classpath 'com.huawei.agconnect:agcp:1.4.1.300' // skip if your app does not support HMS
```

- Add the following lines to the end of `app/build.gradle`

```gradle
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.huawei.agconnect' // skip if your app does not support HMS
```

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

```xml
<!-- skip if your app does not support HMS  -->
<service
   android:name="euromsg.com.euromobileandroid.service.EuroHuaweiMessagingService"
   android:exported="false">
   <intent-filter>
       <action android:name="com.huawei.push.action.MESSAGING_EVENT" />
   </intent-filter>
</service>
```

- Add `google-services.json` file to your application’s `app` directory.

- If your app supports `HMS` add `agconnect-services.json` file to your application’s `app` directory.


### iOS

- Change the ios platform version to 10.0 or higher in `Podfile`

```ruby
platform :ios, '10.0'
```

- In your project directory, open the file `ios/Runner.xcworkspace` with Xcode.

- Enable `Push Notifications` and `Background Modes->Remote Notifications` capabilities.

![Xcode Push Capability](/screenshots/xcode-push-capability.png)





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
    appAlias: Platform.isIOS ? 'ios-alias' : 'android-alias',
    huaweiAppAlias: 'huawei-alias', // pass empty String if your app does not support HMS
    androidPushIntent: 'com.test.MainActivity', // Android only
    organizationId: 'ORG_ID',
    siteId: 'SITE_ID',
    dataSource: 'DATA_SOURCE',
    maxGeofenceCount: 20,  // iOS only
    geofenceEnabled: true,
    inAppNotificationsEnabled: true, // iOS only
    logEnabled: true,
  );

  await relatedDigitalPlugin.init(initRequest);
}
```





## Push Notifications


### Requesting Permission & Retrieving Token

Add the lines below to request push notification permission and retrieve token.

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

void _readNotificationCallback(dynamic result) {
  print(result);
}

Future<void> requestPermission() async {
  await relatedDigitalPlugin.requestPermission(_getTokenCallback, _readNotificationCallback);
}
```





## Data Collection

Related Digital uses events to collect data from mobile applications. The developer needs to implement the methods provided by SDK. `customEvent`  is a generic method to track user events. `customEvent`  takes 2 parameters: pageName and properties.

* **pageName** : The current page of your application. If your event is not related to a page view, you should pass a value related to the event. If you pass an empty **String** the event would be considered invalid and discarded.
* **parameters** : A collection of key/value pairs related to the event. If your event does not have additional data apart from page name, passing an empty **Map** acceptable.

Some of the most common events:


### Sign Up

```dart
String pageName = 'SignUp';
Map<String, String> parameters = {
  'OM.exVisitorID':'userId',
  'OM.b_sgnp':'1'
};
relatedDigitalPlugin.customEvent(pageName, parameters);
```


### Login

```dart
String pageName = 'Login';
Map<String, String> parameters = {
  'OM.exVisitorID':'userId',
  'OM.b_login':'1'
};
relatedDigitalPlugin.customEvent(pageName, parameters);
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





## Targeting Actions


### In-App Messaging

**In-app messages** are notifications to your users when they are directly active in your mobile app. To enable **In-App Messaging** feature you need to set the value of `inAppNotificationsEnabled` parameter to `true` when calling `init` to initialize the SDK.

The existence of a relevant **in-app message** for an event controlled by after each `customEvent` call. You can create and customize your **in-app messages** on https://intelligence.relateddigital.com/#Target/TargetingAction/TAList page of RMC administration panel.

There are 9 types of **in-app messages**:

|               Pop-up - Image, Header, Text & Button              | Mini-icon&text                                                             | Full Screen-image                                                |
|:----------------------------------------------------------------:|----------------------------------------------------------------------------|------------------------------------------------------------------|
| ![full](/screenshots/inappnotification/full.png)                 | ![mini](/screenshots/inappnotification/mini.png)                           | ![full_image](/screenshots/inappnotification/full_image.png)     |
| Full Screen-image&button                                         | Pop-up - Image, Header, Text & Button                                      |                              Pop-up-Survey                       |
| ![image_button](/screenshots/inappnotification/image_button.png) | ![image_text_button](/screenshots/inappnotification/image_text_button.png) | ![smile_rating](/screenshots/inappnotification/smile_rating.png) |
| Pop-up - NPS with Text & Button                                  | Native Alert & Actionsheet                                                 |  NPS with numbers                                                   |
| ![nps](/screenshots/inappnotification/nps.png)                   | ![nps_with_numbers](/screenshots/inappnotification/alert.png)   | ![nps_with_numbers](/screenshots/inappnotification/nps_with_numbers.png) |















































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