import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:relateddigital_flutter_example/constants.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('[FCM][background] variant=${_variant(message)} messageId=${message.messageId} '
      'title=${message.notification?.title} data=${message.data}');
}

String _variant(RemoteMessage message) {
  final data = message.data;
  if (data.containsKey('emPushSp') || data.containsKey('pushId')) {
    return 'RELATED_DIGITAL';
  }
  return 'FCM';
}

class FcmCoexistence {
  static String? token;
  static bool ready = false;
  static final ValueNotifier<String?> tokenNotifier = ValueNotifier<String?>(null);

  static void _setToken(String? value) {
    token = value;
    if (tokenNotifier.value != value) {
      tokenNotifier.value = value;
    }
  }

  static Future<void> init() async {
    if (!Constants.ENABLE_FCM) {
      print('[FCM] skipped – Constants.ENABLE_FCM=false');
      return;
    }

    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('[FCM] Firebase.initializeApp failed: $e');
      print('[FCM] Replace example/ios/Runner/GoogleService-Info.plist with the iOS file from Firebase Console.');
      print('[FCM] Bundle ID must be com.relateddigital.relateddigital-flutter-example');
      print('[FCM] Upload an APNs Auth Key in Firebase Console > Project settings > Cloud Messaging.');
      return;
    }

    if (Firebase.app().options.projectId == 'replace-me') {
      print('[FCM] GoogleService-Info.plist is still the placeholder. Replace it before sending an FCM test.');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('[FCM][onMessage] variant=${_variant(message)} messageId=${message.messageId} '
          'title=${message.notification?.title} body=${message.notification?.body} data=${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[FCM][onMessageOpenedApp] variant=${_variant(message)} messageId=${message.messageId} '
          'title=${message.notification?.title} data=${message.data}');
    });

    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      print('[FCM][getInitialMessage] variant=${_variant(initial)} messageId=${initial.messageId} '
          'title=${initial.notification?.title} data=${initial.data}');
    }

    messaging.onTokenRefresh.listen((String newToken) {
      print('[FCM][onTokenRefresh] $newToken');
      _setToken(newToken);
      ready = newToken.isNotEmpty;
    });

    await refreshToken(retries: 1);
  }

  static Future<String?> refreshToken({int retries = 10}) async {
    if (!Constants.ENABLE_FCM) {
      return null;
    }
    final messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      String? apns;
      for (var i = 0; i < retries; i++) {
        apns = await messaging.getAPNSToken();
        if (apns != null && apns.isNotEmpty) {
          print('[FCM][APNs token for Firebase] $apns');
          break;
        }
        await Future.delayed(const Duration(milliseconds: 400));
      }
      if (apns == null || apns.isEmpty) {
        print('[FCM] APNs token not ready yet – Request Permission first, then FCM token will fill');
        return token;
      }
    }

    for (var i = 0; i < retries; i++) {
      try {
        final value = await messaging.getToken();
        if (value != null && value.isNotEmpty) {
          print('[FCM][token] $value');
          _setToken(value);
          ready = true;
          return value;
        }
      } catch (e) {
        print('[FCM] getToken attempt ${i + 1}/$retries failed: $e');
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
    print('[FCM] getToken failed after $retries attempts');
    return token;
  }
}
