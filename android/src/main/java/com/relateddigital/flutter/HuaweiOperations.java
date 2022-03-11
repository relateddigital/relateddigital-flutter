package com.relateddigital.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.huawei.agconnect.AGConnectOptionsBuilder;
import com.huawei.agconnect.config.AGConnectServicesConfig;
import com.huawei.hms.aaid.HmsInstanceId;

import java.util.HashMap;
import java.util.Map;

import euromsg.com.euromobileandroid.EuroMobileManager;
import io.flutter.plugin.common.MethodChannel;

public class HuaweiOperations {
    private final Context mContext;
    private final MethodChannel mChannel;
    private final Activity mActivity;

    public HuaweiOperations(Context context, MethodChannel channel, Activity activity) {
        mContext = context;
        mChannel = channel;
        mActivity = activity;
    }

    public void setHuaweiTokenToEuromessage() {
        new Thread() {
            @Override
            public void run() {
                try {
                    String appId = new AGConnectOptionsBuilder().build(mContext).getString("client/app_id");
                    final String token = HmsInstanceId.getInstance(mContext).getToken(appId, "HCM");

                    mActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            EuroMobileManager.getInstance().subscribe(token, mContext);
                            Map<String, Object> result = new HashMap<>();
                            result.put("deviceToken", token);
                            result.put("playServiceEnabled", EuroMobileManager.checkPlayService(mContext));
                            mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result);
                        }
                    });
                } catch (Exception e) {
                    Log.e("Huawei Token", "get token failed, " + e);
                }
            }
        }.start();
    }
}