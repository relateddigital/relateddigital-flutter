package com.relateddigital.flutter;

public class Constants {
    public static String CHANNEL_NAME = "relateddigital_flutter";

    public static String M_PERMISSION = "RD/requestPermission";
    public static String M_INIT = "RD/init";
    public static String M_TOKEN_RETRIEVED = "RD/getToken";
    public static String M_NOTIFICATION_OPENED = "RD/openNotification";
    public static String M_EURO_USER_ID = "RD/setEuroUserId";
    public static String M_EMAIL_WITH_PERMISSION = "RD/setEmail";
    public static String M_USER_PROPERTY = "RD/setUserProperty";
    public static String M_APP_VERSION = "RD/setAppVersion";
    public static String M_NOTIFICATION_PERMISSION = "RD/setPushNotificationPermission";
    public static String M_EMAIL_PERMISSION = "RD/setEmailPermission";
    public static String M_PHONE_PERMISSION = "RD/setPhoneNumberPermission";
    public static String M_BADGE = "RD/setBadgeCount";
    public static String M_ADVERTISING = "RD/setAdvertisingIdentifier";
    public static String M_TWITTER = "RD/setTwitterId";
    public static String M_FACEBOOK = "RD/setFacebookId";
    public static String M_CUSTOM_EVENT = "VL/customEvent";
    public static String M_REGISTER_EMAIL = "RD/registerEmail";
    public static String M_RECOMMENDATIONS = "VL/getRecommendations";
    public static String M_STORY_ITEM_CLICK = "VL/onStoryItemClick";
    public static String M_STORY_CLEAR_CACHE = "VL/clearStoryCache";
    public static String M_FAV_ATTRIBUTE = "VL/getFavAttributes";
    public static String M_LOGOUT = "VL/logout";
    public static String M_LOGIN = "VL/login";
    public static String M_SIGNUP = "VL/signUp";
    public static String M_GET_EXVISITORID = "VL/getExVisitorID";
    public static String M_APP_TRACKER = "VL/appTracker";
    public static String M_GET_PUSH_MESSAGES = "RD/getPushMessages";
    public static String M_SEND_LOCATION_PERMISSION = "VL/sendLocationPermission";

    public static String VL_CHANNEL = "Android";
    public static String VL_SEGMENT_URL = "https://lgr.visilabs.net";
    public static String VL_REALTIME_URL = "https://rt.visilabs.net";
    public static String VL_TARGET_URL = "https://s.visilabs.net/json";
    public static String VL_ACTION_URL = "https://s.visilabs.net/actjson";
    public static String VL_GEOFENCE_URL = "https://s.visilabs.net/geojson";
    public static int VL_REQUEST_TIMEOUT = 30;
    public static String STORY_VIEW_NAME = "StoryView";

    public static String REGISTER_TOKEN = "RegisterToken";
}