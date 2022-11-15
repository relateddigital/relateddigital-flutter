package com.relateddigital.flutter

import android.app.Activity
import android.content.Context
import android.util.Log
//import com.huawei.agconnect.AGConnectOptionsBuilder
//import com.huawei.agconnect.config.AGConnectServicesConfig
//import com.huawei.hms.aaid.HmsInstanceId
import java.util.HashMap
import java.util.Map
import io.flutter.plugin.common.MethodChannel
import com.relateddigital.relateddigital_android.RelatedDigital



//TODO: gerek yok sanki
class HuaweiOperations(context: Context, channel: MethodChannel, activity: Activity) {
    /*
    private val mContext: Context
    private val mChannel: MethodChannel
    private val mActivity: Activity

    init {
        mContext = context
        mChannel = channel
        mActivity = activity
    }

    fun setHuaweiTokenToEuromessage() {
        object : Thread() {
            @Override
            fun run() {
                try {
                    val appId: String =
                        AGConnectOptionsBuilder().build(mContext).getString("client/app_id")
                    val token: String = HmsInstanceId.getInstance(mContext).getToken(appId, "HCM")
                    mActivity.runOnUiThread(object : Runnable() {
                        @Override
                        fun run() {
                            EuroMobileManager.getInstance().subscribe(token, mContext)
                            val result: Map<String, Object> = HashMap()
                            result.put("deviceToken", token)
                            result.put(
                                "playServiceEnabled",
                                EuroMobileManager.checkPlayService(mContext)
                            )
                            mChannel.invokeMethod(Constants.M_TOKEN_RETRIEVED, result)
                        }
                    })
                } catch (e: Exception) {
                    Log.e("Huawei Token", "get token failed, $e")
                }
            }
        }.start()
    }

     */
}