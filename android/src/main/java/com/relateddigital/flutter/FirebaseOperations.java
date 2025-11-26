package com.relateddigital.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.os.Build;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import java.util.HashMap;
import java.util.Map;

import euromsg.com.euromobileandroid.EuroMobileManager;
import euromsg.com.euromobileandroid.callback.PushNotificationPermissionInterface;
import io.flutter.plugin.common.MethodChannel;


public class FirebaseOperations {
    private final Context mContext;
    private final MethodChannel mChannel;
    private final Activity mActivity;

    public FirebaseOperations(Context context, MethodChannel channel, Activity activity) {
        mContext = context;
        mChannel = channel;
        mActivity = activity;
    }

    public void sendTokenToRmc(@NonNull Task<String> task, boolean granted){
        String token = task.getResult();
        EuroMobileManager.getInstance().subscribe(token, mContext);

        Map <String, Object> result = new HashMap<>();
        result.put("deviceToken", token);
        result.put("playServiceEnabled", EuroMobileManager.checkPlayService(mContext));
        result.put("permit", granted);
        Log.i("Permit Result",String.valueOf(result));
        mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result);
    }

    public void setExistingFirebaseTokenToEuroMessage() {
        FirebaseMessaging.getInstance().getToken()
                .addOnCompleteListener(new OnCompleteListener<String>() {
                    @Override
                    public void onComplete(@NonNull Task<String> task) {
                        if (!task.isSuccessful()) {
                            Log.e("RelatedDigital", "exception", task.getException());
                            return;
                        }


                        if (Build.VERSION.SDK_INT >= 33) {
                            try {
                                PushNotificationPermissionInterface notificationPermissionInterface = new PushNotificationPermissionInterface() {
                                    @Override
                                    public void success(boolean granted) {
                                        sendTokenToRmc(task,granted);
                                    }

                                    @Override
                                    public void fail(String errorMessage) {
                                        Map <String, Object> result = new HashMap<>();
                                        result.put("errorMessage", errorMessage);
                                        mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result);
                                    }
                                };
                                EuroMobileManager.getInstance().requestNotificationPermission(mActivity, notificationPermissionInterface);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        } else {
                            sendTokenToRmc(task,true);
                        }
                    }
                });
    }
}