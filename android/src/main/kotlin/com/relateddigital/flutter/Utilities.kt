package com.relateddigital.flutter

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import java.io.Serializable
import java.lang.reflect.Field
import java.util.HashMap
import java.util.Map
import java.util.Set

import com.relateddigital.relateddigital_android.model.Message

object Utilities {
    fun convertBundleToMap(intent: Intent): Map<String, Object> {
        val bundle: Bundle? = getBundleFromIntent(intent)
        var map: HashMap<String, Object> = HashMap()
        if (bundle != null) {
            bundle.putBoolean("foreground", false)
            intent.putExtra("notification", bundle)
            val keys: Set<String> = bundle.keySet()
            for (key in keys) {
                if (key.equals("message")) {
                    val message: Message = bundle.getSerializable("message") as Message
                    val gson = Gson()
                    val messageJson: String = gson.toJson(message)
                    map = gson.fromJson(messageJson, HashMap::class.java)
                } else {
                    val value: Object = bundle.get(key)
                    map.put(key, value)
                }
            }
        }
        return map
    }

    private fun getBundleFromIntent(intent: Intent): Bundle? {
        var bundle: Bundle? = null
        if (intent.hasExtra("notification")) {
            bundle = intent.getBundleExtra("notification")
        } else if (intent.hasExtra("message")) {
            bundle = Bundle()
            bundle.putSerializable("message", intent.getSerializableExtra("message"))
        } else {
            bundle = intent.getExtras()
        }
        return bundle
    }
}