package com.relateddigital.flutter;

import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;

import euromsg.com.euromobileandroid.service.EuroFirebaseMessagingService;

/**
 * Filters incoming FCM messages by the {@code emPushSp} key so that only
 * RelatedDigital push payloads are handled by the Euro SDK. Messages without
 * this key are silently ignored, allowing other notification libraries
 * registered in the app to process them through their own service.
 */
public class RelatedDigitalMessagingService extends EuroFirebaseMessagingService {

    private static final String TAG = "RDMessagingService";
    private static final String EM_PUSH_SP_KEY = "emPushSp";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        if (remoteMessage.getData().containsKey(EM_PUSH_SP_KEY)) {
            Log.d(TAG, "emPushSp found – delegating to EuroFirebaseMessagingService");
            super.onMessageReceived(remoteMessage);
        } else {
            Log.d(TAG, "emPushSp not found – skipping, another library should handle this");
        }
    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
    }
}
