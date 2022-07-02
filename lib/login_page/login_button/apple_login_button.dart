import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/token.dart';
import 'package:feeling_note/constants/url.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginButton extends StatefulWidget {
  const AppleLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<AppleLoginButton> createState() => _AppleLoginButtonState();
}

class _AppleLoginButtonState extends State<AppleLoginButton>
    with TickerProviderStateMixin {
  late Animation<double> scaleAni;
  late AnimationController scaleAniController;

  @override
  void initState() {
    scaleAniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    scaleAni = Tween<double>(begin: 1.0, end: 1.1).animate(scaleAniController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var stateProvider = ref.watch(appStateProvider);
      return ScaleTransition(
        scale: scaleAni,
        child: ElevatedButton(
          onPressed: () async {
            await scaleAniController.forward();
            await scaleAniController.reverse();
            final credential = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
            );

            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: credential.identityToken,
              accessToken: credential.authorizationCode,
            );
            await FirebaseAuth.instance.signInWithCredential(oauthCredential);
            String uid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
            Dio dio = Dio();
            var response = await dio.post(
              UserUri.create,
              data: {
                "login_method": "by_apple_sign_in",
                "access_token_for_sns": credential.authorizationCode,
                "email": "",
                "auth_uid": uid,
              },
            );

            AccessToken().updateToken(response.data["access_token"].toString());
            AccessToken()
                .updateExpireDate(response.data["access_token_expire_at"].toString());

            RefreshToken().updateToken(response.data["refresh_token"].toString());
            RefreshToken()
                .updateExpireDate(response.data["refresh_token_expire_at"].toString());

            final prefs = await SharedPreferences.getInstance();

            await prefs.setString("access_token", AccessToken().token);
            await prefs.setString("access_token_expire_at", AccessToken().expireAt);

            await prefs.setString("refresh_token", RefreshToken().token);
            await prefs.setString("refresh_token_expire_at", RefreshToken().expireAt);

            await DiaryDatabase.init();

            bool todayDone = await DiaryDatabase.isTodayDiaryWritten();
            if (todayDone) {
              stateProvider.setTodaysDiaryDone();
            } else {
              stateProvider.setTodaysDiaryNotDone();
            }
            stateProvider.setIsLoading(false);
            stateProvider.showLoginPage(false);
            stateProvider.setIsLogined(true);
          },
          child: Text(
            "애플 로그인",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(335, 50),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      );
    });
  }
}
