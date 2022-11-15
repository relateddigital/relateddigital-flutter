package com.relateddigital.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.gson.Gson
import com.visilabs.Visilabs
import com.visilabs.VisilabsResponse
import com.visilabs.api.VisilabsCallback
import com.visilabs.api.VisilabsTargetFilter
import com.visilabs.api.VisilabsTargetRequest
import com.visilabs.favs.Favorites
import com.visilabs.favs.FavsResponse
import com.visilabs.inApp.VisilabsActionRequest
import com.visilabs.json.JSONArray
import com.visilabs.util.PersistentTargetManager
import com.visilabs.util.VisilabsConstant
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import euromsg.com.euromobileandroid.EuroMobileManager
import euromsg.com.euromobileandroid.callback.PushMessageInterface
import euromsg.com.euromobileandroid.enums.EmailPermit
import euromsg.com.euromobileandroid.enums.GsmPermit
import euromsg.com.euromobileandroid.enums.PushPermit
import euromsg.com.euromobileandroid.model.EuromessageCallback
import euromsg.com.euromobileandroid.model.Message
import euromsg.com.euromobileandroid.utils.AppUtils
import io.flutter.plugin.common.MethodChannel


import com.relateddigital.relateddigital_android.RelatedDigital

class RelatedDigitalFunctionHandler(activity: Activity, channel: MethodChannel) {
    private val mContext: Context
    private val mChannel: MethodChannel
    private val mActivity: Activity?
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

    fun initEuromsg(appAlias: String?, huaweiAppAlias: String?, pushIntent: String?) {
        mAppAlias = appAlias
        mHuaweiAppAlias = huaweiAppAlias
        val euroMobileManager: EuroMobileManager =
            EuroMobileManager.init(appAlias, huaweiAppAlias, mContext)
        euroMobileManager.registerToFCM(mContext)
        euroMobileManager.setPushIntent(pushIntent, mContext)
        euroMobileManager.setChannelName("CHANNEL", mContext) // TODO: burada niye CHANNEL var?
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun initVisilabs(
        organizationId: String?,
        siteId: String?,
        datasource: String?,
        geofenceEnabled: Boolean,
        inAppNotificationsEnabled: Boolean
    ) {
        RelatedDigital.init(mContext, organizationId, siteId, datasource)

        Visilabs.CreateAPI(
            organizationId,
            siteId,
            Constants.VL_SEGMENT_URL,
            datasource,
            Constants.VL_REALTIME_URL,
            Constants.VL_CHANNEL,
            mContext,
            Constants.VL_TARGET_URL,
            Constants.VL_ACTION_URL,
            Constants.VL_REQUEST_TIMEOUT,
            Constants.VL_GEOFENCE_URL,
            geofenceEnabled
        )
        mInAppNotificationsEnabled = inAppNotificationsEnabled
        //Visilabs.CreateAPI(mContext);
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

    fun setEuroUserId(userId: String?) {
        EuroMobileManager.getInstance().setEuroUserId(userId, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setEmail(email: String?) {
        EuroMobileManager.getInstance().setEmail(email, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setEmailWithPermission(email: String?, permission: Boolean) {
        setEmail(email)
        EuroMobileManager.getInstance()
            .setEmailPermit(if (permission) EmailPermit.ACTIVE else EmailPermit.PASSIVE, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setUserProperty(key: String?, value: String?) {
        EuroMobileManager.getInstance().setUserProperty(key, value, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun removeUserProperty(key: String?) {
        EuroMobileManager.getInstance().removeUserProperty(mContext, key)
        EuroMobileManager.getInstance().sync(mContext)
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

    fun setPhonePermission(permission: Boolean) {
        EuroMobileManager.getInstance()
            .setGsmPermit(if (permission) GsmPermit.ACTIVE else GsmPermit.PASSIVE, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setTwitterId(twitterId: String?) {
        EuroMobileManager.getInstance().setTwitterId(twitterId, mContext)
        EuroMobileManager.getInstance().sync(mContext)
    }

    fun setFacebookId(facebookId: String?) {
        EuroMobileManager.getInstance().setFacebook(facebookId, mContext)
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

    fun customEvent(pageName: String?, parameters: HashMap<String?, String?>?) {
        if (mInAppNotificationsEnabled && mActivity != null && !Constants.REGISTER_TOKEN.equals(
                pageName
            )
        ) {
            //TODO: burada mActivity'i sürekli değiştirmek gerekebilir.
            Visilabs.CallAPI().customEvent(pageName, parameters, mActivity)
        } else {
            Visilabs.CallAPI().customEvent(pageName, parameters)
        }
    }

    fun registerEmail(
        email: String?,
        permission: Boolean,
        isCommercial: Boolean,
        result: MethodChannel.Result
    ) {
        EuroMobileManager.getInstance().registerEmail(
            email,
            if (permission) EmailPermit.ACTIVE else EmailPermit.PASSIVE,
            isCommercial,
            mContext,
            object : EuromessageCallback() {
                @Override
                fun success() {
                    result.success(true)
                }

                @Override
                fun fail(errorMessage: String?) {
                    result.success(false)
                    Log.e("ERROR", errorMessage)
                }
            })
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

    fun getFavoriteAttributeActions(actionId: String?, result: MethodChannel.Result) {
        try {
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

    fun logout() {
        EuroMobileManager.getInstance().removeUserProperties(mContext)
        Visilabs.CallAPI().logout()
    }

    fun login(exVisitorId: String?, properties: HashMap<String?, String?>?) {
        if (properties == null || properties.isEmpty()) {
            Visilabs.CallAPI().login(exVisitorId)
        } else {
            Visilabs.CallAPI().login(exVisitorId, properties)
        }
    }

    fun signUp(exVisitorId: String?, properties: HashMap<String?, String?>?) {
        if (properties == null || properties.isEmpty()) {
            Visilabs.CallAPI().signUp(exVisitorId)
        } else {
            Visilabs.CallAPI().signUp(exVisitorId, properties)
        }
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

    fun sendLocationPermission() {
        try {
            Visilabs.CallAPI().sendLocationPermission()
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    fun getPushMessages(result: MethodChannel.Result) {
        if (mActivity != null) {
            EuroMobileManager.getInstance()
                .getPushMessages(mActivity, object : PushMessageInterface() {
                    @Override
                    fun success(pushMessages: List<Message?>?) {
                        if (pushMessages == null) {
                            result.error("ERROR", "pushMessages list is null", null)
                        } else {
                            val map: Map<String, List<Message>> = HashMap()
                            map.put("pushMessages", pushMessages)
                            val gson = Gson()
                            result.success(gson.toJson(map))
                        }
                    }

                    @Override
                    fun fail(errorMessage: String?) {
                        result.error("ERROR", errorMessage, null)
                    }
                })
        }
    }
}