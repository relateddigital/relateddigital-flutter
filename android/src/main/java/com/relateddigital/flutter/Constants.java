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

    public static String VL_CHANNEL = "Android";
    public static String VL_SEGMENT_URL = "http://lgr.visilabs.net";
    public static String VL_REALTIME_URL = "http://rt.visilabs.net";
    public static String VL_TARGET_URL = "http://s.visilabs.net/json";
    public static String VL_ACTION_URL = "http://s.visilabs.net/actjson";
    public static String VL_GEOFENCE_URL = "http://s.visilabs.net/geojson";
    public static int VL_REQUEST_TIMEOUT = 30;
}
