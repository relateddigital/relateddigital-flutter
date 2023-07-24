package com.relateddigital.flutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.google.gson.Gson;
import com.visilabs.Visilabs;
import com.visilabs.VisilabsResponse;
import com.visilabs.api.VisilabsCallback;
import com.visilabs.api.VisilabsTargetFilter;
import com.visilabs.api.VisilabsTargetRequest;
import com.visilabs.favs.Favorites;
import com.visilabs.favs.FavsResponse;
import com.visilabs.inApp.VisilabsActionRequest;
import com.visilabs.json.JSONArray;
import com.visilabs.util.PersistentTargetManager;
import com.visilabs.util.VisilabsConstant;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import euromsg.com.euromobileandroid.EuroMobileManager;
import euromsg.com.euromobileandroid.callback.PushMessageInterface;
import euromsg.com.euromobileandroid.enums.EmailPermit;
import euromsg.com.euromobileandroid.enums.GsmPermit;
import euromsg.com.euromobileandroid.enums.PushPermit;
import euromsg.com.euromobileandroid.model.EuromessageCallback;
import euromsg.com.euromobileandroid.model.Message;
import euromsg.com.euromobileandroid.utils.AppUtils;
import io.flutter.plugin.common.MethodChannel;

public class RelatedDigitalFunctionHandler {
    private final Context mContext;
    private final MethodChannel mChannel;
    private final Activity mActivity;
    private String mAppAlias;
    private String mHuaweiAppAlias;
    private boolean mInAppNotificationsEnabled;

    public RelatedDigitalFunctionHandler(Activity activity, MethodChannel channel) {
        mActivity = activity;
        mContext = activity.getApplicationContext();
        mChannel = channel;
    }

    public void initEuromsg(String appAlias, String huaweiAppAlias, String pushIntent) {
        mAppAlias = appAlias;
        mHuaweiAppAlias = huaweiAppAlias;
        EuroMobileManager euroMobileManager = EuroMobileManager.init(appAlias, huaweiAppAlias, mContext);
        euroMobileManager.registerToFCM(mContext);
        euroMobileManager.setPushIntent(pushIntent, mContext);
        euroMobileManager.setChannelName("CHANNEL", mContext); // TODO: burada niye CHANNEL var?
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void initVisilabs(String organizationId, String siteId, String datasource, boolean geofenceEnabled, boolean inAppNotificationsEnabled) {
        Visilabs.CreateAPI(organizationId, siteId, Constants.VL_SEGMENT_URL, datasource, Constants.VL_REALTIME_URL, Constants.VL_CHANNEL, mContext, Constants.VL_TARGET_URL, Constants.VL_ACTION_URL, Constants.VL_REQUEST_TIMEOUT, Constants.VL_GEOFENCE_URL, geofenceEnabled);
        mInAppNotificationsEnabled = inAppNotificationsEnabled;
        //Visilabs.CreateAPI(mContext);
    }

    public void getToken() {
        if (!EuroMobileManager.checkPlayService(mContext)) {
            
        } else {
            FirebaseOperations firebaseOperations = new FirebaseOperations(mContext, mChannel);
            firebaseOperations.setExistingFirebaseTokenToEuroMessage();
        }
    }

    public void setEuroUserId(String userId) {
        EuroMobileManager.getInstance().setEuroUserId(userId, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setEmail(String email) {
        EuroMobileManager.getInstance().setEmail(email, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setEmailWithPermission(String email, boolean permission) {
        setEmail(email);
        EuroMobileManager.getInstance().setEmailPermit(permission ? EmailPermit.ACTIVE : EmailPermit.PASSIVE, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setUserProperty(String key, String value) {
        EuroMobileManager.getInstance().setUserProperty(key, value, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void removeUserProperty(String key) {
        EuroMobileManager.getInstance().removeUserProperty(mContext, key);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setAppVersion(String appVersion) {
        EuroMobileManager.getInstance().setAppVersion(appVersion, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setPushNotificationPermission(boolean permission) {
        EuroMobileManager.getInstance().setPushPermit(permission ? PushPermit.ACTIVE : PushPermit.PASSIVE, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setPhonePermission(boolean permission) {
        EuroMobileManager.getInstance().setGsmPermit(permission ? GsmPermit.ACTIVE : GsmPermit.PASSIVE, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setTwitterId(String twitterId) {
        EuroMobileManager.getInstance().setTwitterId(twitterId, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public void setFacebookId(String facebookId) {
        EuroMobileManager.getInstance().setFacebook(facebookId, mContext);
        EuroMobileManager.getInstance().sync(mContext);
    }

    public boolean checkReportRead(Intent intent) {

        if (EuroMobileManager.getInstance() == null) {
            return true;
        }

        if (intent.getExtras() != null && intent.getExtras().getSerializable("message") != null) {
            try {
                Message message = (Message) intent.getExtras().getSerializable("message");
                EuroMobileManager.getInstance().sendOpenRequest(message);
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }
            Map<String, Object> readResult = Utilities.convertBundleToMap(intent);
            mChannel.invokeMethod(Constants.M_NOTIFICATION_OPENED, readResult);
        }

        return true;
    }

    public void customEvent(String pageName, HashMap<String, String> parameters) {
        if(mInAppNotificationsEnabled && mActivity != null && !Constants.REGISTER_TOKEN.equals(pageName)) {
            //TODO: burada mActivity'i sürekli değiştirmek gerekebilir.
            Visilabs.CallAPI().customEvent(pageName, parameters, mActivity);
        } else {
            Visilabs.CallAPI().customEvent(pageName, parameters);
        }
    }

    public void registerEmail(String email, boolean permission, boolean isCommercial, final MethodChannel.Result result) {
        EuroMobileManager.getInstance().registerEmail(email, permission ? EmailPermit.ACTIVE : EmailPermit.PASSIVE, isCommercial, mContext, new EuromessageCallback() {
            @Override
            public void success() {
                result.success(true);
            }

            @Override
            public void fail(String errorMessage) {
                result.success(false);
                Log.e("ERROR", errorMessage);
            }
        });
    }

    public void getRecommendations(String zoneId, String productCode, ArrayList<HashMap<String, Object>> filters, final MethodChannel.Result result) {
        try {
            List<VisilabsTargetFilter> visilabsRecoFilters = new ArrayList<VisilabsTargetFilter>();
            HashMap<String,String> properties = new HashMap<String, String>();

            for (HashMap<String, Object> filter : filters) {
                String attribute = filter.get("attribute").toString();
                String filterType = filter.get("filterType").toString();
                String value = filter.get("value") != null ? filter.get("value").toString() : null;

                VisilabsTargetFilter f = new VisilabsTargetFilter(attribute, filterType, value);
                visilabsRecoFilters.add(f);
            }

            VisilabsTargetRequest targetRequest = Visilabs.CallAPI().buildTargetRequest(zoneId, productCode, properties, visilabsRecoFilters);
            targetRequest.executeAsync(new VisilabsCallback() {
                @Override
                public void success(VisilabsResponse response) {
                    try{
                        String rawResponse = response.getRawResponse();
                        result.success(rawResponse);
                    }
                    catch (Exception ex){
                        ex.printStackTrace();

                        HashMap<String, String> error = new HashMap<String, String>();
                        error.put("error", ex.toString());
                        result.success(error);
                    }
                }
                @Override
                public void fail(VisilabsResponse response) {
                    HashMap<String, String> error = new HashMap<String, String>();
                    error.put("error", response.getErrorMessage());
                    result.success(error);
                }
            });
        }
        catch (Exception ex) {
            HashMap<String, String> error = new HashMap<String, String>();
            error.put("error", ex.toString());
            result.success(error);
        }
    }

    public void clearStoryCache() {
        PersistentTargetManager.with(mContext).clearStoryCache();
    }

    public void getFavoriteAttributeActions(String actionId, final MethodChannel.Result result) {
        try {
            VisilabsActionRequest visilabsActionRequest;

            if(actionId != null && !actionId.isEmpty()) {
                visilabsActionRequest = Visilabs.CallAPI().requestActionId(actionId);
            }
            else {
                visilabsActionRequest = Visilabs.CallAPI().requestActionId(VisilabsConstant.FavoriteAttributeAction);
            }

            visilabsActionRequest.executeAsyncAction(new VisilabsCallback() {

                @Override
                public void success(VisilabsResponse response) {

                    Gson gson = new Gson();
                    FavsResponse favsResponse = gson.fromJson(response.getRawResponse(), FavsResponse.class);

                    if(favsResponse.getFavoriteAttributeAction().size() > 0) {
                        Favorites favs = favsResponse.getFavoriteAttributeAction().get(0).getActiondata().getFavorites();
                        result.success(gson.toJson(favs));
                    }
                    else {
                        result.success("");
                    }
                }

                @Override
                public void fail(VisilabsResponse response) {
                    result.success("");
                }
            });
        }
        catch (Exception e) {
            result.error("ERROR", e.getMessage(), "");
        }
    }

    public void logout() {
        EuroMobileManager.getInstance().removeUserProperties(mContext);
        Visilabs.CallAPI().logout();
    }

    public void login(String exVisitorId, HashMap<String, String> properties) {
        if(properties == null || properties.isEmpty()) {
            Visilabs.CallAPI().login(exVisitorId);
        }
        else {
            Visilabs.CallAPI().login(exVisitorId, properties);
        }
    }

    public void signUp(String exVisitorId, HashMap<String, String> properties) {
        if(properties == null || properties.isEmpty()) {
            Visilabs.CallAPI().signUp(exVisitorId);
        }
        else {
            Visilabs.CallAPI().signUp(exVisitorId, properties);
        }
    }

    public String getExVisitorID() {
        return Visilabs.CallAPI().getExVisitorID();
    }

    public void sendTheListOfAppsInstalled() {
        try {
            Visilabs.CallAPI().sendTheListOfAppsInstalled();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void sendLocationPermission() {
        try {
            Visilabs.CallAPI().sendLocationPermission();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void getPushMessages(final MethodChannel.Result result) {
        if(mActivity != null) {
            EuroMobileManager.getInstance().getPushMessages(mActivity, new PushMessageInterface() {
                @Override
                public void success(List<Message> pushMessages) {
                    if(pushMessages == null) {
                        result.error("ERROR", "pushMessages list is null", "");
                    } else {
                        Map<String, List<Message>> map = new HashMap<>();
                        map.put("pushMessages", pushMessages);
                        Gson gson = new Gson();
                        result.success(gson.toJson(map));
                    }
                }
                @Override
                public void fail(String errorMessage) {
                    result.error("ERROR", errorMessage, "");
                }
            });
        }
    }
}
