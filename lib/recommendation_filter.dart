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
  static String PRODUCTNAME = 'PRODUCTNAME';
  static String COLOR = 'COLOR';
  static String AGEGROUP = 'AGEGROUP';
  static String BRAND = 'BRAND';
  static String CATEGORY = 'CATEGORY';
  static String GENDER = 'GENDER';
  static String MATERIAL = 'MATERIAL';
  static String ATTRIBUTE1 = 'ATTRIBUTE1';
  static String ATTRIBUTE2 = 'ATTRIBUTE2';
  static String ATTRIBUTE3 = 'ATTRIBUTE3';
  static String ATTRIBUTE4 = 'ATTRIBUTE4';
  static String ATTRIBUTE5 = 'ATTRIBUTE5';
  static String SHIPPINGONSAMEDAY = 'SHIPPINGONSAMEDAY';
  static String FREESHIPPING = 'FREESHIPPING';
  static String ISDISCOUNTED = 'ISDISCOUNTED';
}
