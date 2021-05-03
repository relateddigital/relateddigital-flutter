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
final RelatedDigitalPlugin relatedDigitalPlugin = RelatedDigitalPlugin();

@override
void initState() {
  super.initState();
  initLib();
}

Future<void> initLib() async {
  var initRequest = RDInitRequestModel(
    appAlias: Platform.isIOS ? 'ios-alias' : 'android-alias',
    huaweiAppAlias: 'huawei-alias', // Android only
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













//TODO: app/build.gradle defaultConfig altına  multiDexEnabled true gerekiyormuş?

//TODO: project/build.gradle lintOptions android { { disable 'InvalidPackage' } } gerekli mi?















## ANDROID

android app klasörüne google-services.json eklenecek
huawei kısmını da test et

AndroidManifest.xml'e EuroFirebaseMessagingService ve EuroHuaweiMessagingService eklenecek

<service
           android:name="euromsg.com.euromobileandroid.service.EuroFirebaseMessagingService"
           android:exported="false">
           <intent-filter>
               <action android:name="com.google.firebase.MESSAGING_EVENT" />
           </intent-filter>
       </service>

       <service
           android:name="euromsg.com.euromobileandroid.service.EuroHuaweiMessagingService"
           android:exported="false">
           <intent-filter>
               <action android:name="com.huawei.push.action.MESSAGING_EVENT" />
           </intent-filter>
       </service>



proje build gradle'ının en üst kısmı

buildscript {
    repositories {
        google()
        jcenter()
        maven {url 'http://developer.huawei.com/repo/'}
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:4.1.3'
        classpath 'com.google.gms:google-services:4.3.5'
        classpath 'com.huawei.agconnect:agcp:1.4.1.300'
    }
}

allprojects {
    repositories {
        google()
        jcenter()
        maven {url 'http://developer.huawei.com/repo/'}
    }
}








app build gradle'ına

apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.huawei.agconnect'

eklenmesi gerekiyor.

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











<!---

## relateddigital_flutter



## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

-->