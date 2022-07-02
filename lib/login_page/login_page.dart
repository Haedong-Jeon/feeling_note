import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/token.dart';
import 'package:feeling_note/constants/url.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/login_page/login_button/apple_login_button.dart';
import 'package:feeling_note/login_page/login_button/email_login_button.dart';
import 'package:feeling_note/login_page/login_button/google_login_button.dart';
import 'package:feeling_note/login_page/login_button/kakao_login_button.dart';
import 'package:feeling_note/login_page/login_button/naver_login_button.dart';
import 'package:feeling_note/utils/api_connector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const valueKey = ValueKey("login_page");

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late Animation<double> opacityAni1;
  late Animation<double> opacityAni2;
  late Animation<double> opacityAni3;
  late Animation<Offset> slideAni;

  late AnimationController opacityAniController1;
  late AnimationController opacityAniController2;
  late AnimationController opacityAniController3;
  late AnimationController slideAniController;

  @override
  void initState() {
    opacityAniController1 =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    opacityAniController2 =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    opacityAniController3 =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    slideAniController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    opacityAni1 =
        Tween<double>(begin: 0.0, end: 1.0).animate(opacityAniController1)
          ..addListener(() {
            setState(() {});
          });
    opacityAni2 =
        Tween<double>(begin: 0.0, end: 1.0).animate(opacityAniController2)
          ..addListener(() {
            setState(() {});
          });
    opacityAni3 =
        Tween<double>(begin: 0.0, end: 1.0).animate(opacityAniController3)
          ..addListener(() {
            setState(() {});
          });

    slideAni = Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0))
        .animate(slideAniController)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await opacityAnimationStart();
      slideAniController.forward();
    });
    super.initState();
  }

  Future<void> opacityAnimationStart() async {
    await opacityAniController1.forward();
    await opacityAniController2.forward();
    await opacityAniController3.forward();
  }

  @override
  void dispose() {
    opacityAniController1.dispose();
    opacityAniController2.dispose();
    opacityAniController3.dispose();
    slideAniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var stateProvider = ref.watch(appStateProvider);
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        bool tokenValid = await APIConnector.isTokenValid();
        if(tokenValid) {
          stateProvider.showLoginPage(false);
          stateProvider.setIsLogined(true);
          return;
        } else {
          stateProvider.showLoginPage(true);
          stateProvider.setIsLogined(false);
          return;
        }


      });
      return Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: bottomNavBarColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: opacityAni1.value,
                      child: Text(
                        "당신의 ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: opacityAni2.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (opacityAniController3.isCompleted)
                            AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  "감정을",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                  ),
                                  speed: Duration(milliseconds: 150),
                                  cursor: "|",
                                ),
                                TypewriterAnimatedText(
                                  "마음을",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                  ),
                                  speed: Duration(milliseconds: 150),
                                  cursor: "|",
                                ),
                                TypewriterAnimatedText(
                                  "하루를",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                  ),
                                  speed: Duration(milliseconds: 150),
                                  cursor: "|",
                                ),
                                TypewriterAnimatedText(
                                  "일상을",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                  ),
                                  speed: Duration(milliseconds: 150),
                                  cursor: "|",
                                ),
                              ],
                              stopPauseOnTap: false,
                            ),
                          if (!opacityAniController3.isCompleted)
                            Text(
                              "마음을 ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                              ),
                            ),
                          Text(
                            "정리 할",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: opacityAni3.value,
                      child: Text(
                        "일기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                        ),
                      ),
                    ),
                    Lottie.asset("assets/lotties/diary_lottie.json"),
                    SlideTransition(
                      position: slideAni,
                      child: Column(
                        children: [
                          Platform.isIOS
                              ? AppleLoginButton()
                              : GoogleLoginButton(),
                          SizedBox(height: 10),
                          EmailLoginButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (stateProvider.isLoading)
            Center(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Lottie.asset("assets/lotties/loading_lottie.json")),
            ),
        ],
      );
    });
  }
}
