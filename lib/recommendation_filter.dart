class RDRecommendationFilter {
  static String attribute = 'attribute';
  static String filterType = 'filterType';
  static String value = 'value';
}

class RDRecommendationFilterType {
  static int equals = 0;
  static int notEquals = 1;
  static int like = 2;
  static int notLike = 3;
  static int greaterThan = 4;
  static int lessThan = 5;
  static int greaterOrEquals = 6;
  static int lessOrEquals = 7;
  static int include = like;
  static int exclude = notLike;
}

class RDRecommendationFilterAttribute {
  static const String PRODUCTNAME = 'PRODUCTNAME';
  static const String COLOR = 'COLOR';
  static const String AGEGROUP = 'AGEGROUP';
  static const String BRAND = 'BRAND';
  static const String CATEGORY = 'CATEGORY';
  static const String GENDER = 'GENDER';
  static const String MATERIAL = 'MATERIAL';
  static const String ATTRIBUTE1 = 'ATTRIBUTE1';
  static const String ATTRIBUTE2 = 'ATTRIBUTE2';
  static const String ATTRIBUTE3 = 'ATTRIBUTE3';
  static const String ATTRIBUTE4 = 'ATTRIBUTE4';
  static const String ATTRIBUTE5 = 'ATTRIBUTE5';
  static const String SHIPPINGONSAMEDAY = 'SHIPPINGONSAMEDAY';
  static const String FREESHIPPING = 'FREESHIPPING';
  static const String ISDISCOUNTED = 'ISDISCOUNTED';
}
