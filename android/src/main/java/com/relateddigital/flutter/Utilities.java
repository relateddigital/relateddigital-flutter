package com.relateddigital.flutter;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import euromsg.com.euromobileandroid.EuroMobileManager;
import euromsg.com.euromobileandroid.model.Message;

public class Utilities {
    public static Map<String, Object> convertBundleToMap(Intent intent) {
        Bundle bundle = getBundleFromIntent(intent);
        HashMap<String, Object> map = new HashMap<>();

        if(bundle != null) {
            bundle.putBoolean("foreground", false);
            intent.putExtra("notification", bundle);

            Set<String> keys = bundle.keySet();

            for (String key : keys) {
                if(key.equals("message")) {
                    Message message = (Message)bundle.getSerializable("message");

                    Gson gson = new Gson();
                    String messageJson = gson.toJson(message);

                    map = gson.fromJson(messageJson, HashMap.class);
                }
                else {
                    Object value = bundle.get(key);
                    map.put(key, value);
                }
            }
        }

        return map;
    }

    private static Bundle getBundleFromIntent(Intent intent) {
        Bundle bundle = null;
        if (intent.hasExtra("notification")) {
            bundle = intent.getBundleExtra("notification");
        }
        else if (intent.hasExtra("message")) {
            bundle = new Bundle();
            bundle.putSerializable("message", intent.getSerializableExtra("message"));
        }
        else {
            bundle = intent.getExtras();
        }
        return bundle;
    }
}