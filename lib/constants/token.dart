class AccessToken {
  String token = "";
  String expireAt = "";

  static final AccessToken _instance = AccessToken._internal();

  factory AccessToken() => _instance;

  AccessToken._internal() {}
  void updateToken(String token) {
    this.token = token;
  }

  void updateExpireDate(String expireAt) {
    this.expireAt = expireAt;
  }
}
class RefreshToken {
  String token = "";
  String expireAt = "";

  static final RefreshToken _instance = RefreshToken._internal();

  factory RefreshToken() => _instance;

  RefreshToken._internal() {}
  void updateToken(String token) {
    this.token = token;
  }

  void updateExpireDate(String expireAt) {
    this.expireAt = expireAt;
  }
}
