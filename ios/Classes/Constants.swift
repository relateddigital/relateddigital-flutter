class Constants {
    static let CHANNEL_NAME = "relateddigital_flutter"
    
    static let M_INIT = "RD/init"
    static let M_PERMISSION = "RD/requestPermission"
    static let M_TOKEN_RETRIEVED = "RD/getToken"
    static let M_NOTIFICATION_OPENED = "RD/openNotification"
    static let M_EURO_USER_ID = "RD/setEuroUserId"
    static let M_EMAIL_WITH_PERMISSION = "RD/setEmailWithPermission"
    static let M_SET_EMAIL = "RD/setEmail";
    static let M_USER_PROPERTY = "RD/setUserProperty"
    static let M_REMOVE_USER_PROPERTY = "RD/removeUserProperty";
    static let M_APP_VERSION = "RD/setAppVersion"
    static let M_NOTIFICATION_PERMISSION = "RD/setPushNotificationPermission"
    static let M_EMAIL_PERMISSION = "RD/setEmailPermission"
    static let M_PHONE_PERMISSION = "RD/setPhoneNumberPermission"
    static let M_BADGE = "RD/setBadgeCount"
    static let M_ADVERTISING = "RD/setAdvertisingIdentifier"
    static let M_TWITTER = "RD/setTwitterId"
    static let M_FACEBOOK = "RD/setFacebookId"
    static let M_CUSTOM_EVENT = "VL/customEvent"
    static let M_REGISTER_EMAIL = "RD/registerEmail"
    static let M_RECOMMENDATIONS = "VL/getRecommendations"
    static let M_STORY_ITEM_CLICK = "VL/onStoryItemClick"
    static let M_FAV_ATTRIBUTE = "VL/getFavAttributes"
    static let M_LOGOUT = "VL/logout"
    static let M_LOGIN = "VL/login"
    static let M_SIGNUP = "VL/signUp"
    static let M_GET_EXVISITORID = "VL/getExVisitorID"
    static let M_GET_PUSH_MESSAGES = "RD/getPushMessages"
    static let M_REQUEST_IDFA = "VL/requestIDFA"
    static let M_SEND_LOCATION_PERMISSION = "VL/sendLocationPermission"
    
    static let VL_CHANNEL = "IOS"
    static let VL_REQUEST_TIMEOUT = 30
    static let STORY_VIEW_NAME = "StoryView"
}
