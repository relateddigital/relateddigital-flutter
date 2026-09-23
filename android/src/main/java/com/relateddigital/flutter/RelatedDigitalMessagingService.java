package com.relateddigital.flutter;

import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;

import euromsg.com.euromobileandroid.service.EuroFirebaseMessagingService;

/**
 * Default FCM entry point for apps that use Related Digital as their only push provider.
 *
 * <p>Android invokes only one {@code FirebaseMessagingService}. Skipping a non-Related Digital
 * payload here does <strong>not</strong> deliver it to another library. If the app also uses
 * {@code firebase_messaging}, OneSignal, or any other FCM service, remove this service from the
 * merged manifest ({@code tools:node="remove"}) and route messages from your own service via
 * {@link RelatedDigitalFCMHelper}.
 */
public class RelatedDigitalMessagingService extends EuroFirebaseMessagingService {

    private static final String TAG = "RDMessagingService";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        if (RelatedDigitalFCMHelper.isRelatedDigitalMessage(remoteMessage)) {
            Log.d(TAG, "emPushSp found – delegating to EuroFirebaseMessagingService");
            super.onMessageReceived(remoteMessage);
        } else {
            Log.d(TAG, "emPushSp not found – skipping. If another push SDK is used, remove this service and route via RelatedDigitalFCMHelper");
        }
    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
    }
}
