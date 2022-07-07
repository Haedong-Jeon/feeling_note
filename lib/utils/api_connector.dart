import 'package:dio/dio.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/constants/token.dart';
import 'package:feeling_note/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIConnector {
  static Future<void> renewAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String refreshToken = await prefs.getString("refresh_token") ?? "";

    Dio dio = Dio();
    final response =
        await dio.post(TokenUri.renew, data: {"refresh_token": refreshToken});

    AccessToken().updateToken(response.data["access_token"].toString());
    AccessToken()
        .updateExpireDate(response.data["access_token_expire_at"].toString());

    RefreshToken().updateToken(response.data["refresh_token"].toString());
    RefreshToken()
        .updateExpireDate(response.data["refresh_token_expire_at"].toString());

    await prefs.setString("access_token", AccessToken().token);
    await prefs.setString("access_token_expire_at", AccessToken().expireAt);

    await prefs.setString("refresh_token", RefreshToken().token);
    await prefs.setString("refresh_token_expire_at", RefreshToken().expireAt);
  }

  static Future<dynamic> login(
      {required String authUid, required String loginFrom}) async {
    Dio dio = Dio();
    return await dio.post(
      UserUri.create,
      data: {
        "login_method": loginFrom,
        "access_token_for_sns": "",
        "email": "",
        "auth_uid": authUid,
      },
    );
  }

  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = await prefs.getString("access_token") ?? "";
    String accessTokenExpireAt =
        await prefs.getString("access_token_expire_at") ?? "";

    String refreshToken = await prefs.getString("refresh_token") ?? "";
    String refreshTokenExpireAt =
        await prefs.getString("refresh_token_expire_at") ?? "";
    if (accessToken == "") {
      return false;
    }
    if (accessTokenExpireAt == "") {
      return false;
    }
    DateTime? accessExpireDate = DateTime.tryParse(accessTokenExpireAt);
    if (accessExpireDate == null) {
      return false;
    }
    if (DateTime.now().isAfter(accessExpireDate)) {
      if (refreshToken == "") {
        return false;
      }
      if (refreshTokenExpireAt == "") {
        return false;
      }
      DateTime? refreshExpireDate = DateTime.tryParse(refreshTokenExpireAt);
      if (refreshExpireDate == null) {
        return false;
      }
      if (DateTime.now().isAfter(refreshExpireDate)) {
        return false;
      } else {
        await renewAccessToken();
        AccessToken().updateToken(accessToken);
        AccessToken().updateExpireDate(accessTokenExpireAt);

        RefreshToken().updateToken(refreshToken);
        RefreshToken().updateExpireDate(refreshTokenExpireAt);
        return true;
      }
    } else {
      AccessToken().updateToken(accessToken);
      AccessToken().updateExpireDate(accessTokenExpireAt);

      RefreshToken().updateToken(refreshToken);
      RefreshToken().updateExpireDate(refreshTokenExpireAt);
      return true;
    }
  }

  static Future<dynamic> imageUpload({required FormData data}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();

    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers["token"] = AccessToken().token;

    final response = await dio.post(ImageUri.upload, data: data);
    return response.data;
  }

  static Future<dynamic> emotionUpload({required Emotion diary}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response = await dio.post(
      EmotionUri.write,
      data: {
        "content": diary.content,
        "is_positive_emotion": diary.isPositiveEmotion,
        "last_feel_at": DateTime.now().toString(),
        "image_path": diary.imagePath,
        "image_online_path": diary.imageOnlinePath,
        "in_kor": diary.inKor,
        "emoji": diary.emoji,
      },
    );
    return response.data;
  }

  static Future<dynamic> emotionEdit(
      {required Emotion diary, required int emotionId}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    String date =
        DateTime.parse(diary.lastFeelDate.replaceAll(".", "-")).toString();

    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response = await dio.put(
      EmotionUri.edit(emotionId),
      data: {
        "content": diary.content,
        "is_positive_emotion": diary.isPositiveEmotion,
        "last_feel_at": date,
        "image_path": diary.imagePath,
        "image_online_path": diary.imageOnlinePath,
        "in_kor": diary.inKor,
        "emoji": diary.emoji,
      },
    );
    return response.data;
  }

  static Future<dynamic> getAllEmotions() async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;

    final response = await dio.get(EmotionUri.all);
    return response.data;
  }

  static Future<dynamic> getEmotionDetail({required emotionId}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;

    final response = await dio.get(EmotionUri.detail(emotionId));
    return response.data;
  }

  static Future<dynamic> getMe() async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response = await dio.get(UserUri.me);
    return response.data;
  }

  static Future<dynamic> deleteEmotion({required int emotionId}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response = await dio.delete(EmotionUri.delete(emotionId));
    return response.data;
  }

  static Future<dynamic> deleteImage({required int targetImageId}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response = await dio.delete(ImageUri.delete(targetImageId));
    return response.data;
  }

  static Future<dynamic> getImageDetail({required String path}) async {
    bool tokenValid = await isTokenValid();
    if (!tokenValid) {
      return {"error": "token_expired!"};
    }
    Dio dio = Dio();
    dio.options.headers["token"] = AccessToken().token;
    final response =
        await dio.post(ImageUri.detail, data: {"image_online_path": path});
    return response.data;
  }
}
