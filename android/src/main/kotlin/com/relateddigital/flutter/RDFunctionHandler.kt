package com.relateddigital.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.google.gson.Gson

import io.flutter.plugin.common.MethodChannel


import com.relateddigital.relateddigital_android.RelatedDigital
import com.relateddigital.relateddigital_android.model.EmailPermit
import com.relateddigital.relateddigital_android.model.GsmPermit
import com.relateddigital.relateddigital_android.model.Message
import com.relateddigital.relateddigital_android.push.EuromessageCallback
import com.relateddigital.relateddigital_android.push.PushMessageInterface

class RDFunctionHandler(activity: Activity, channel: MethodChannel) {
    private val mContext: Context
    private val mChannel: MethodChannel
    private var mActivity: Activity
    private var mAppAlias: String? = null
    private var mHuaweiAppAlias: String? = null
    private var mInAppNotificationsEnabled = false

    init {
        mActivity = activity
        mContext = activity.applicationContext
        mChannel = channel
    }

    fun initRD(organizationId: String, profileId: String, datasource: String) {
        RelatedDigital.init(mContext, organizationId, profileId, datasource)
    }

    fun setIsInAppNotificationEnabled(isInAppNotificationEnabled: Boolean) {
        RelatedDigital.setIsInAppNotificationEnabled(mContext, isInAppNotificationEnabled)
    }

    fun setIsGeofenceEnabled(isGeofenceEnabled: Boolean) {
        RelatedDigital.setIsGeofenceEnabled(mContext, isGeofenceEnabled)
    }

    fun setAdvertisingIdentifier(advertisingIdentifier: String) {
        RelatedDigital.setAdvertisingIdentifier(mContext, advertisingIdentifier)
    }

    fun signUp(exVisitorId: String, properties: HashMap<String, String>) {
        RelatedDigital.signUp(mContext, exVisitorId, properties, mActivity)
    }

    fun login(exVisitorId: String, properties: HashMap<String, String>) {
        RelatedDigital.login(mContext, exVisitorId, properties, mActivity)
    }

    fun logout() {
        RelatedDigital.logout(mContext)
        RelatedDigital.removeUserProperties(mContext)
    }

    fun customEvent(pageName: String, parameters: HashMap<String, String>) {
        RelatedDigital.customEvent(mActivity, pageName, parameters)
    }

    /*
    fun setIsPushNotificationEnabled(
        isPushNotificationEnabled: Boolean, googleAppAlias: String,
        huaweiAppAlias: String
    ) {
        RelatedDigital.setIsPushNotificationEnabled(
            mContext, true, googleAppAlias,
            huaweiAppAlias
        )
    }
     */

    fun setEmail(email: String, permission: Boolean) {
        RelatedDigital.setEmail(mContext, email)
        val emailPermit = if (permission) EmailPermit.ACTIVE else EmailPermit.PASSIVE
        RelatedDigital.setEmailPermit(mContext, emailPermit)
    }

    fun sendCampaignParameters(parameters: HashMap<String, String>) {
        RelatedDigital.sendCampaignParameters(mContext, parameters)
    }

    fun setTwitterId(twitterId: String) {
        RelatedDigital.setTwitterId(mContext, twitterId)
        RelatedDigital.sync(mContext)
    }

    fun setFacebookId(facebookId: String) {
        RelatedDigital.setFacebookId(mContext, facebookId)
        RelatedDigital.sync(mContext)
    }

    fun setRelatedDigitalUserId(relatedDigitalUserId: String) {
        RelatedDigital.setRelatedDigitalUserId(mContext, relatedDigitalUserId)
        RelatedDigital.sync(mContext)
    }

    fun setNotificationLoginId(notificationLoginId: String) {
        RelatedDigital.setNotificationLoginID(notificationLoginId, mContext)
        RelatedDigital.sync(mContext)
    }

    fun setPhoneNumber(msisdn: String, permission: Boolean) {
        val gsmPermit = if (permission) GsmPermit.ACTIVE else GsmPermit.PASSIVE
        RelatedDigital.setPhoneNumber(mContext, msisdn)
        RelatedDigital.setGsmPermit(mContext, gsmPermit)
        RelatedDigital.sync(mContext)
    }

    fun setUserProperty(key: String, value: String) {
        RelatedDigital.setUserProperty(mContext, key, value)
        RelatedDigital.sync(mContext)
    }

    fun removeUserProperty(key: String) {
        RelatedDigital.removeUserProperty(mContext, key)
        RelatedDigital.sync(mContext)
    }

    fun registerEmail(
        email: String,
        permission: Boolean,
        isCommercial: Boolean,
        result: MethodChannel.Result
    ) {
        RelatedDigital.registerEmail(
            mContext,
            email,
            if (permission) EmailPermit.ACTIVE else EmailPermit.PASSIVE,
            isCommercial,
            object : EuromessageCallback {
                override fun success() {
                    result.success(true)
                }

                override fun fail(errorMessage: String?) {
                    result.success(false)
                    Log.e("ERROR", errorMessage ?: "")
                }
            })
    }

    fun getPushMessages(result: MethodChannel.Result) {
        RelatedDigital
            .getPushMessages(mActivity, object : PushMessageInterface {
                override fun success(pushMessages: List<Message>) {
                    val map: HashMap<String, List<Message>> = HashMap()
                    map["pushMessages"] = pushMessages
                    val gson = Gson()
                    result.success(gson.toJson(map))
                }

                override fun fail(errorMessage: String) {
                    result.error("ERROR", errorMessage, null)
                }
            })
    }

    fun getPushMessagesWithID(result: MethodChannel.Result) {
        RelatedDigital
            .getPushMessagesWithID(mActivity, object : PushMessageInterface {
                override fun success(pushMessages: List<Message>) {
                    val map: HashMap<String, List<Message>> = HashMap()
                    map["pushMessages"] = pushMessages
                    val gson = Gson()
                    result.success(gson.toJson(map))
                }

                override fun fail(errorMessage: String) {
                    result.error("ERROR", errorMessage, null)
                }
            })
    }

    fun sendLocationPermission() {
        try {
            RelatedDigital.sendLocationPermission(mContext)
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    fun getFavoriteAttributeActions(actionId: String?, result: MethodChannel.Result) {
        try {
            RelatedDigital.getFavorites(mContext, actionId)


            val visilabsActionRequest: VisilabsActionRequest
            visilabsActionRequest = if (actionId != null && !actionId.isEmpty()) {
                Visilabs.CallAPI().requestActionId(actionId)
            } else {
                Visilabs.CallAPI().requestActionId(VisilabsConstant.FavoriteAttributeAction)
            }
            visilabsActionRequest.executeAsyncAction(object : VisilabsCallback() {
                @Override
                fun success(response: VisilabsResponse) {
                    val gson = Gson()
                    val favsResponse: FavsResponse =
                        gson.fromJson(response.getRawResponse(), FavsResponse::class.java)
                    if (favsResponse.getFavoriteAttributeAction().size() > 0) {
                        val favs: Favorites =
                            favsResponse.getFavoriteAttributeAction().get(0).getActiondata()
                                .getFavorites()
                        result.success(gson.toJson(favs))
                    } else {
                        result.success(null)
                    }
                }

                @Override
                fun fail(response: VisilabsResponse?) {
                    result.success(null)
                }
            })
        } catch (e: Exception) {
            result.error("ERROR", e.getMessage(), null)
        }
    }
















    val token: Unit
        get() {
            if (!EuroMobileManager.checkPlayService(mContext)) {
                val huaweiOperations = HuaweiOperations(mContext, mChannel, mActivity)
                huaweiOperations.setHuaweiTokenToEuromessage()
            } else {
                val firebaseOperations = FirebaseOperations(mContext, mChannel)
                firebaseOperations.setExistingFirebaseTokenToEuroMessage()
            }
        }


    fun setAppVersion(appVersion: String?) {
        EuroMobileManager.getInstance().setAppVersion(appVersion, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setPushNotificationPermission(permission: Boolean) {
        EuroMobileManager.getInstance()
            .setPushPermit(if (permission) PushPermit.ACTIVE else PushPermit.PASSIVE, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }


    fun checkReportRead(intent: Intent): Boolean {
        if (RE.getInstance() == null) {
            return true
        }
        if (intent.extras != null && intent.extras.getSerializable("message") != null) {
            try {
                val message: Message = intent.extras.getSerializable("message") as Message
                EuroMobileManager.getInstance().sendOpenRequest(message)
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
            val readResult: Map<String, Object> = Utilities.convertBundleToMap(intent)
            mChannel.invokeMethod(Constants.M_NOTIFICATION_OPENED, readResult)
        }
        return true
    }


    fun getRecommendations(
        zoneId: String?,
        productCode: String?,
        filters: ArrayList<HashMap<String?, Object?>?>,
        result: MethodChannel.Result
    ) {
        try {
            val visilabsRecoFilters: List<VisilabsTargetFilter> = ArrayList<VisilabsTargetFilter>()
            val properties: HashMap<String, String> = HashMap<String, String>()
            for (filter in filters) {
                val attribute: String = filter.get("attribute").toString()
                val filterType: String = filter.get("filterType").toString()
                val value: String? =
                    if (filter.get("value") != null) filter.get("value").toString() else null
                val f = VisilabsTargetFilter(attribute, filterType, value)
                visilabsRecoFilters.add(f)
            }
            val targetRequest: VisilabsTargetRequest = Visilabs.CallAPI()
                .buildTargetRequest(zoneId, productCode, properties, visilabsRecoFilters)
            targetRequest.executeAsync(object : VisilabsCallback() {
                @Override
                fun success(response: VisilabsResponse) {
                    try {
                        val rawResponse: String = response.getRawResponse()
                        result.success(rawResponse)
                    } catch (ex: Exception) {
                        ex.printStackTrace()
                        val error: HashMap<String, String> = HashMap<String, String>()
                        error.put("error", ex.toString())
                        result.success(error)
                    }
                }

                @Override
                fun fail(response: VisilabsResponse) {
                    val error: HashMap<String, String> = HashMap<String, String>()
                    error.put("error", response.getErrorMessage())
                    result.success(error)
                }
            })
        } catch (ex: Exception) {
            val error: HashMap<String, String> = HashMap<String, String>()
            error.put("error", ex.toString())
            result.success(error)
        }
    }

    fun clearStoryCache() {
        PersistentTargetManager.with(mContext).clearStoryCache()
    }



    val exVisitorID: String
        get() = Visilabs.CallAPI().getExVisitorID()

    fun sendTheListOfAppsInstalled() {
        try {
            Visilabs.CallAPI().sendTheListOfAppsInstalled()
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }




}