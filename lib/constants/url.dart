const String baseUrl = "http://3.38.94.208";

class UserUri {
  static const String userBaseUri = "/user";
  static const String create = baseUrl + userBaseUri + "/signin";
  static const String me = baseUrl + userBaseUri + "/me";
}

class EmotionUri {
  static const String emotionBaseUri = "/emotion";
  static const String write = baseUrl + emotionBaseUri + "/write";
  static const String all = baseUrl + emotionBaseUri + "/all";

  static String edit(int emotionId) {
    return baseUrl + emotionBaseUri + "/edit/${emotionId}";
  }

  static String delete(int emotionId) {
    return baseUrl + emotionBaseUri + "/delete/${emotionId}";
  }

  static String detail(int emotionId) {
    return baseUrl + emotionBaseUri + "/${emotionId}";
  }
}

class ImageUri {
  static const String imageUri = "/image";
  static const String upload = baseUrl + imageUri + "/upload";
  static const String detail = baseUrl + imageUri + "/detail_by_path";

  static String delete(int imageId) {
    return baseUrl + imageUri + "/delete/${imageId}";
  }
}

class TokenUri {
  static const String tokenUri = "/token";
  static const String renew = baseUrl + tokenUri + "/renew";
}
