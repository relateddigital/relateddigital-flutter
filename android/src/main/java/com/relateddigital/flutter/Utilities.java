package com.relateddigital.flutter;

import android.content.Intent;
import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Utilities {
    public static Map<String, String> convertBundleToMap(Intent intent) {
        Bundle bundle = getBundleFromIntent(intent);
        HashMap<String, String> map = new HashMap<>();

        if(bundle != null) {
            bundle.putBoolean("foreground", false);
            intent.putExtra("notification", bundle);

            Set<String> keys = bundle.keySet();

            for (String key : keys) {
                String value = bundle.getString(key);
                map.put(key, value);
            }
        }

        return map;
    }

    private static Bundle getBundleFromIntent(Intent intent) {
        Bundle bundle = null;
        if (intent.hasExtra("notification")) {
            bundle = intent.getBundleExtra("notification");
        }
        else if (intent.hasExtra("google.message_id")) {
            bundle = intent.getExtras();
        }
        return bundle;
    }
}
