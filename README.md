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
    - [Android](#Android)
    - [iOS](#iOS)
- [Usage](#Usage)
    - [Initializing](#Initializing)
    - [Push Notifications](#Push-Notifications)
        - [Requesting Permission & Retrieving Token](#Requesting-Permission-&-Retrieving-Token])
    - [Data Collection](#Data-Collection)




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


## Android

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


## iOS

- Change the ios platform version to 10.0 or higher in `Podfile`

```ruby
platform :ios, '10.0'
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

Related Digital uses events to collect data from mobile applications. The developer needs to implement the methods provided by SDK. `customEvent`  
is a generic method to track user events. `customEvent`  takes 2 parameters: pageName and properties.

* **pageName** : The current page of your application. If your event is not related to a page view
, you should pass a value related to the event. If you pass an empty **String** the event would be considered invalid and discarded.
* **parameters** : A collection of key/value pairs related to the event. If your event does not have additional data apart from page name
, passing an empty **Map** acceptable.

In SDK, apart from `customEvent`, there are 2 other methods to collect data: `login` and `signUp`.  
As in the `customEvent` method, the `login` and `signUp` methods also take a mandatory and an optional parameter. 
The first parameter is `exVisitorId`  which uniquely identifies the user and can not be empty. The second parameter `properties` is optional 
and passsing an empty dictionary also valid.

Some of the most common events:





















































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









https://raw.githubusercontent.com/relateddigital/visilabs-ios/master/README.md ## Data Collection Vislabs yazıyor düzelt




-->