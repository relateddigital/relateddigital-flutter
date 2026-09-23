package com.relateddigital.relateddigital_flutter_example;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.RemoteMessage;
import com.relateddigital.flutter.RelatedDigitalFCMHelper;

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService;

public class RouterFCMService extends FlutterFirebaseMessagingService {
    private static final String TAG = "RDPush";
    static final String FCM_CHANNEL_ID = "rd_example_fcm";

    @Override
    public void onCreate() {
        super.onCreate();
        ensureFcmChannel();
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        String title = remoteMessage.getNotification() != null
                ? remoteMessage.getNotification().getTitle()
                : null;
        String body = remoteMessage.getNotification() != null
                ? remoteMessage.getNotification().getBody()
                : null;
        String imageUrl = null;
        if (remoteMessage.getNotification() != null && remoteMessage.getNotification().getImageUrl() != null) {
            imageUrl = remoteMessage.getNotification().getImageUrl().toString();
        }
        if (imageUrl == null || imageUrl.isEmpty()) {
            if (remoteMessage.getData().containsKey("image")) {
                imageUrl = remoteMessage.getData().get("image");
            } else if (remoteMessage.getData().containsKey("imageUrl")) {
                imageUrl = remoteMessage.getData().get("imageUrl");
            }
        }
        if (RelatedDigitalFCMHelper.isRelatedDigitalMessage(remoteMessage)) {
            Log.d(TAG, "variant=RELATED_DIGITAL – forwarding to RelatedDigitalFCMHelper"
                    + " title=" + title + " body=" + body + " data=" + remoteMessage.getData());
            RelatedDigitalFCMHelper.onMessageReceived(this, remoteMessage);
            return;
        }
        Log.d(TAG, "variant=FCM – forwarding to FlutterFirebaseMessagingService"
                + " messageId=" + remoteMessage.getMessageId()
                + " title=" + title + " body=" + body
                + " imageUrl=" + imageUrl
                + " data=" + remoteMessage.getData());
        showFcmNotification(title, body, imageUrl);
        super.onMessageReceived(remoteMessage);
    }

    @Override
    public void onNewToken(@NonNull String token) {
        Log.d(TAG, "FCM onNewToken=" + token);
        RelatedDigitalFCMHelper.onNewToken(this, token);
        super.onNewToken(token);
    }

    private void ensureFcmChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return;
        }
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (manager == null) {
            return;
        }
        NotificationChannel channel = new NotificationChannel(
                FCM_CHANNEL_ID,
                "FCM",
                NotificationManager.IMPORTANCE_HIGH);
        channel.setDescription("Firebase Cloud Messaging");
        manager.createNotificationChannel(channel);
    }

    private void showFcmNotification(String title, String body, String imageUrl) {
        if ((title == null || title.isEmpty()) && (body == null || body.isEmpty())) {
            Log.d(TAG, "FCM has no notification title/body – nothing to display");
            return;
        }
        ensureFcmChannel();
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        int flags = PendingIntent.FLAG_UPDATE_CURRENT;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            flags |= PendingIntent.FLAG_IMMUTABLE;
        }
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, flags);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, FCM_CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle(title != null ? title : "FCM")
                .setContentText(body != null ? body : "")
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent);
        Bitmap image = downloadBitmap(imageUrl);
        if (image != null) {
            builder.setLargeIcon(image);
            builder.setStyle(new NotificationCompat.BigPictureStyle()
                    .bigPicture(image)
                    .bigLargeIcon((Bitmap) null)
                    .setSummaryText(body != null ? body : ""));
            Log.d(TAG, "FCM image attached to notification imageUrl=" + imageUrl);
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            Log.d(TAG, "FCM image download failed imageUrl=" + imageUrl);
        } else {
            Log.d(TAG, "FCM payload has no image URL");
        }
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (manager == null) {
            return;
        }
        int notificationId = (int) System.currentTimeMillis();
        manager.notify(notificationId, builder.build());
        Log.d(TAG, "displayed FCM notification on device title=" + title + " body=" + body);
    }

    private Bitmap downloadBitmap(String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            return null;
        }
        java.net.HttpURLConnection connection = null;
        try {
            java.net.URL url = new java.net.URL(imageUrl);
            connection = (java.net.HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(8000);
            connection.setReadTimeout(8000);
            connection.setDoInput(true);
            connection.connect();
            if (connection.getResponseCode() != java.net.HttpURLConnection.HTTP_OK) {
                Log.d(TAG, "FCM image HTTP " + connection.getResponseCode() + " for " + imageUrl);
                return null;
            }
            return BitmapFactory.decodeStream(connection.getInputStream());
        } catch (Exception e) {
            Log.d(TAG, "FCM image download error: " + e.getMessage());
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
}
