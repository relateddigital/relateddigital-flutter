<p align="center">
  <img src="https://www.relateddigital.com/i/assets/rd-2019/images/svg/related-digital-logo.svg" width="400px;"/>
</p>

# Related Digital Flutter SDK



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







IOS

example podfile # platform :ios, 9 u '10.0' a çektim.


podfile ve podspec'leri düzelt.




## relateddigital_flutter



## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

