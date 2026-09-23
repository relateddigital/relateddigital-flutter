package com.relateddigital.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.google.firebase.messaging.RemoteMessage;

import euromsg.com.euromobileandroid.service.EuroMsgFCMHelper;

/**
 * Public helpers for apps that already own a {@link com.google.firebase.messaging.FirebaseMessagingService}
 * (for example {@code firebase_messaging} or OneSignal) and need to forward Related Digital payloads
 * into the Euro SDK.
 *
 * <p>Android delivers {@code com.google.firebase.MESSAGING_EVENT} to a single service. When another
 * push library is present, remove {@link RelatedDigitalMessagingService} from the merged manifest
 * and call these methods from your own service. See the README section
 * "Using with other push providers".
 */
public final class RelatedDigitalFCMHelper {

    private static final String EM_PUSH_SP_KEY = "emPushSp";

    private RelatedDigitalFCMHelper() {
    }

    public static boolean isRelatedDigitalMessage(RemoteMessage remoteMessage) {
        return remoteMessage != null
                && remoteMessage.getData() != null
                && remoteMessage.getData().containsKey(EM_PUSH_SP_KEY)
                && remoteMessage.getData().get(EM_PUSH_SP_KEY) != null;
    }

    public static void onMessageReceived(@NonNull Context context, @NonNull RemoteMessage remoteMessage) {
        EuroMsgFCMHelper.onMessageReceived(context, remoteMessage);
    }

    public static void onNewToken(@NonNull Context context, @NonNull String token) {
        EuroMsgFCMHelper.onNewToken(context, token);
    }
}
