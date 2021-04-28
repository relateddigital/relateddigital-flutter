package com.relateddigital.flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.NonNull;

import com.visilabs.util.VisilabsConstant;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterMain;

/** RelatedDigitalPlugin */
public class RelatedDigitalPlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private RelatedDigitalFunctionHandler functionHandler;
  private Activity mActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), Constants.CHANNEL_NAME);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals(Constants.M_INIT)) {
      String appAlias = call.argument("appAlias");
      String huaweiAppAlias = call.argument("huaweiAppAlias");
      String pushIntent = call.argument("pushIntent");
      boolean enableLog = call.argument("enableLog");

      String organizationId = call.argument("organizationId");
      String siteId = call.argument("siteId");
      String dataSource = call.argument("dataSource");
      boolean geofenceEnabled = call.argument("geofenceEnabled");

      functionHandler.initEuromsg(appAlias, huaweiAppAlias, pushIntent);
      functionHandler.initVisilabs(organizationId, siteId, dataSource, geofenceEnabled);
      VisilabsConstant.DEBUG = enableLog;

      result.success(null);
    }
    else if (call.method.equals(Constants.M_PERMISSION)) {
      functionHandler.getToken();
      result.success(null);
    }
    else if (call.method.equals(Constants.M_EURO_USER_ID)) {
      String userId = call.argument("userId");

      functionHandler.setEuroUserId(userId);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_EMAIL_WITH_PERMISSION)) {
      String email = call.argument("email");
      boolean permission = call.argument("permission");

      functionHandler.setEmail(email, permission);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_USER_PROPERTY)) {
      String key = call.argument("key");
      String value = call.argument("value");

      functionHandler.setUserProperty(key, value);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_APP_VERSION)) {
      String appVersion = call.argument("appVersion");

      functionHandler.setAppVersion(appVersion);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_NOTIFICATION_PERMISSION)) {
      boolean permission = call.argument("permission");

      functionHandler.setPushNotificationPermission(permission);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_EMAIL_PERMISSION)) {
      result.notImplemented();
    }
    else if (call.method.equals(Constants.M_PHONE_PERMISSION)) {
      boolean permission = call.argument("permission");

      functionHandler.setPhonePermission(permission);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_BADGE)) {
      result.notImplemented();
    }
    else if (call.method.equals(Constants.M_ADVERTISING)) {
      result.notImplemented();
    }
    else if (call.method.equals(Constants.M_TWITTER)) {
      String twitterId = call.argument("twitterId");

      functionHandler.setTwitterId(twitterId);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_FACEBOOK)) {
      String facebookId = call.argument("facebookId");

      functionHandler.setFacebookId(facebookId);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_CUSTOM_EVENT)) {
      String pageName = call.argument("pageName");
      HashMap<String, String> parameters = call.argument("parameters");

      functionHandler.customEvent(pageName, parameters);
      result.success(null);
    }
    else if (call.method.equals(Constants.M_REGISTER_EMAIL)) {
      String email = call.argument("email");
      boolean permission = call.argument("permission");
      boolean isCommercial = call.argument("isCommercial");

      functionHandler.registerEmail(email, permission, isCommercial);
      result.success(null);
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    return functionHandler.reportRead(intent);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    binding.addOnNewIntentListener(this);
    mActivity = binding.getActivity();
    functionHandler = new RelatedDigitalFunctionHandler(mActivity, channel);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    mActivity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    binding.addOnNewIntentListener(this);
    mActivity = binding.getActivity();
    functionHandler = new RelatedDigitalFunctionHandler(mActivity, channel);
  }

  @Override
  public void onDetachedFromActivity() {
    mActivity = null;
  }
}