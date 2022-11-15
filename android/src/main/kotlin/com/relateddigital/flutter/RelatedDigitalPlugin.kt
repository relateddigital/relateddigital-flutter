package com.relateddigital.flutter

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
//import com.visilabs.util.VisilabsConstant
import java.util.ArrayList
import java.util.HashMap
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.FlutterMain

/** RelatedDigitalPlugin  */
class RelatedDigitalPlugin : FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener,
  ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var channel: MethodChannel? = null
  private var functionHandler: RelatedDigitalFunctionHandler? = null
  private var mActivity: Activity? = null
  @Override
  fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getBinaryMessenger(), Constants.CHANNEL_NAME)
    channel.setMethodCallHandler(this)
    flutterPluginBinding
      .getPlatformViewRegistry()
      .registerViewFactory(
        Constants.STORY_VIEW_NAME,
        RelatedDigitalStoryViewFactory(flutterPluginBinding.getBinaryMessenger(), channel)
      )
  }

  @Override
  fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      if (call.method.equals(Constants.M_INIT)) {
        val appAlias: String = call.argument("appAlias")
        val huaweiAppAlias: String = call.argument("huaweiAppAlias")
        val pushIntent: String = call.argument("pushIntent")
        val enableLog: Boolean = call.argument("enableLog")
        val organizationId: String = call.argument("organizationId")
        val siteId: String = call.argument("siteId")
        val dataSource: String = call.argument("dataSource")
        val geofenceEnabled: Boolean = call.argument("geofenceEnabled")
        val inAppNotificationsEnabled: Boolean = call.argument("inAppNotificationsEnabled")
        functionHandler.initEuromsg(appAlias, huaweiAppAlias, pushIntent)
        functionHandler.initVisilabs(
          organizationId,
          siteId,
          dataSource,
          geofenceEnabled,
          inAppNotificationsEnabled
        )
        //VisilabsConstant.DEBUG = enableLog
        result.success(null)
        functionHandler.checkReportRead(mActivity.getIntent())
      } else if (call.method.equals(Constants.M_PERMISSION)) {
        functionHandler.getToken()
        result.success(null)
      } else if (call.method.equals(Constants.M_EURO_USER_ID)) {
        val userId: String = call.argument("userId")
        functionHandler.setEuroUserId(userId)
        result.success(null)
      } else if (call.method.equals(Constants.M_SET_EMAIL)) {
        val email: String = call.argument("email")
        functionHandler.setEmail(email)
        result.success(null)
      } else if (call.method.equals(Constants.M_EMAIL_WITH_PERMISSION)) {
        val email: String = call.argument("email")
        val permission: Boolean = call.argument("permission")
        functionHandler.setEmailWithPermission(email, permission)
        result.success(null)
      } else if (call.method.equals(Constants.M_USER_PROPERTY)) {
        val key: String = call.argument("key")
        val value: String = call.argument("value")
        functionHandler.setUserProperty(key, value)
        result.success(null)
      } else if (call.method.equals(Constants.M_REMOVE_USER_PROPERTY)) {
        val key: String = call.argument("key")
        functionHandler.removeUserProperty(key)
        result.success(null)
      } else if (call.method.equals(Constants.M_APP_VERSION)) {
        val appVersion: String = call.argument("appVersion")
        functionHandler.setAppVersion(appVersion)
        result.success(null)
      } else if (call.method.equals(Constants.M_NOTIFICATION_PERMISSION)) {
        val permission: Boolean = call.argument("permission")
        functionHandler.setPushNotificationPermission(permission)
        result.success(null)
      } else if (call.method.equals(Constants.M_EMAIL_PERMISSION)) {
        result.notImplemented()
      } else if (call.method.equals(Constants.M_PHONE_PERMISSION)) {
        val permission: Boolean = call.argument("permission")
        functionHandler.setPhonePermission(permission)
        result.success(null)
      } else if (call.method.equals(Constants.M_BADGE)) {
        result.notImplemented()
      } else if (call.method.equals(Constants.M_ADVERTISING)) {
        result.notImplemented()
      } else if (call.method.equals(Constants.M_TWITTER)) {
        val twitterId: String = call.argument("twitterId")
        functionHandler.setTwitterId(twitterId)
        result.success(null)
      } else if (call.method.equals(Constants.M_FACEBOOK)) {
        val facebookId: String = call.argument("facebookId")
        functionHandler.setFacebookId(facebookId)
        result.success(null)
      } else if (call.method.equals(Constants.M_CUSTOM_EVENT)) {
        val pageName: String = call.argument("pageName")
        val parameters: HashMap<String, String> = call.argument("parameters")
        functionHandler.customEvent(pageName, parameters)
        result.success(null)
      } else if (call.method.equals(Constants.M_REGISTER_EMAIL)) {
        val email: String = call.argument("email")
        val permission: Boolean = call.argument("permission")
        val isCommercial: Boolean = call.argument("isCommercial")
        functionHandler.registerEmail(email, permission, isCommercial, result)
      } else if (call.method.equals(Constants.M_RECOMMENDATIONS)) {
        val zoneId: String = call.argument("zoneId")
        val productCode: String = call.argument("productCode")
        val filters: ArrayList<HashMap<String, Object>> = call.argument("filters")
        functionHandler.getRecommendations(zoneId, productCode, filters, result)
      } else if (call.method.equals(Constants.M_STORY_CLEAR_CACHE)) {
        functionHandler.clearStoryCache()
      } else if (call.method.equals(Constants.M_FAV_ATTRIBUTE)) {
        val actionId: String = call.argument("actionId")
        functionHandler.getFavoriteAttributeActions(actionId, result)
      } else if (call.method.equals(Constants.M_LOGOUT)) {
        functionHandler.logout()
        result.success(null)
      } else if (call.method.equals(Constants.M_LOGIN)) {
        val exVisitorId: String = call.argument("exVisitorId")
        val properties: HashMap<String, String> = call.argument("properties")
        functionHandler.login(exVisitorId, properties)
      } else if (call.method.equals(Constants.M_SIGNUP)) {
        val exVisitorId: String = call.argument("exVisitorId")
        val properties: HashMap<String, String> = call.argument("properties")
        functionHandler.signUp(exVisitorId, properties)
      } else if (call.method.equals(Constants.M_GET_EXVISITORID)) {
        val exVisitorID: String = functionHandler.getExVisitorID()
        result.success(exVisitorID)
      } else if (call.method.equals(Constants.M_APP_TRACKER)) {
        functionHandler.sendTheListOfAppsInstalled()
        result.success(null)
      } else if (call.method.equals(Constants.M_GET_PUSH_MESSAGES)) {
        functionHandler.getPushMessages(result)
      } else if (call.method.equals(Constants.M_SEND_LOCATION_PERMISSION)) {
        functionHandler.sendLocationPermission()
        result.success(null)
      } else {
        result.notImplemented()
      }
    } catch (ex: Exception) {
      ex.printStackTrace()
    }
  }

  @Override
  fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding?) {
    channel.setMethodCallHandler(null)
  }

  @Override
  fun onNewIntent(intent: Intent?): Boolean {
    return functionHandler.checkReportRead(intent)
  }

  @Override
  fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    mActivity = binding.getActivity()
    functionHandler = RelatedDigitalFunctionHandler(mActivity, channel)
  }

  @Override
  fun onDetachedFromActivityForConfigChanges() {
    mActivity = null
  }

  @Override
  fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    mActivity = binding.getActivity()
    functionHandler = RelatedDigitalFunctionHandler(mActivity, channel)
  }

  @Override
  fun onDetachedFromActivity() {
    mActivity = null
  }
}