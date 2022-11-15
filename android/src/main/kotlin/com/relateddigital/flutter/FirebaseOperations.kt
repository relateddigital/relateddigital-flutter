package com.relateddigital.flutter

import android.content.Context
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.messaging.FirebaseMessaging
import java.util.HashMap
import java.util.Map
import io.flutter.plugin.common.MethodChannel
import com.relateddigital.relateddigital_android.RelatedDigital


//TODO: gerek yok sanki
class FirebaseOperations(context: Context, channel: MethodChannel) {
    /*
    private val mContext: Context
    private val mChannel: MethodChannel

    init {
        mContext = context
        mChannel = channel
    }

    fun setExistingFirebaseTokenToEuroMessage() {
        FirebaseMessaging.getInstance().getToken()
            .addOnCompleteListener(object : OnCompleteListener<String?>() {
                @Override
                fun onComplete(@NonNull task: Task<String?>) {
                    if (!task.isSuccessful()) {
                        return
                    }
                    val token: String = task.getResult()
                    EuroMobileManager.getInstance().subscribe(token, mContext)
                    val result: Map<String, Object> = HashMap()
                    result.put("deviceToken", token)
                    result.put("playServiceEnabled", EuroMobileManager.checkPlayService(mContext))
                    mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result)
                }
            })
    }

     */
}