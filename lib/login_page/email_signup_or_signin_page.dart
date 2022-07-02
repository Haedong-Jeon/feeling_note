import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/token.dart';
import 'package:feeling_note/constants/url.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSigninOrSignupPage extends StatefulWidget {
  static const ValueKey valueKey = ValueKey("email_signup_or_signin");

  @override
  State<EmailSigninOrSignupPage> createState() =>
      _EmailSigninOrSignupPageState();
}

class _EmailSigninOrSignupPageState extends State<EmailSigninOrSignupPage>
    with TickerProviderStateMixin {
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _showLoading = false;
  bool _showEmailVerifySendOk = false;
  bool _showEmailVerifySendFail = false;
  bool _showLoginFail = false;
  late Animation<double> _opacityAni;
  late AnimationController _opacityAniController;

  @override
  void initState() {
    _opacityAniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4500));
    _opacityAni =
        Tween<double>(begin: 0, end: 1).animate(_opacityAniController);
    super.initState();
  }

  OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  );
  OutlineInputBorder _errorborder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _password2TextController = TextEditingController();
  FocusNode _emailTextFocusNode = FocusNode();
  FocusNode _passwordTextFocusNode = FocusNode();
  FocusNode _password2TextFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Lottie.asset(
                "assets/lotties/night_sky_lottie.json",
                fit: BoxFit.cover,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 200),
                    TextFormField(
                      focusNode: _emailTextFocusNode,
                      controller: _emailTextController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "입력란이 비었습니다.";
                        }
                        bool isEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!isEmail) {
                          return "이메일 형식에 맞지 않습니다.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _passwordTextFocusNode.requestFocus();
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.black.withOpacity(0.3),
                        filled: true,
                        border: _border,
                        errorBorder: _errorborder,
                        enabledBorder: _border,
                        label: Text("email"),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      focusNode: _passwordTextFocusNode,
                      controller: _passwordTextController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "암호를 입력해주세요.";
                        }
                        if (text.length < 8) {
                          return "8글자 이상 입력해주세요";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (_isSignUp) {
                          _password2TextFocusNode.requestFocus();
                        } else {
                          FormState? formState =
                              (_formKey as GlobalKey<FormState>).currentState;

                          if (formState == null) {
                            return;
                          }
                          formState.validate();
                        }
                      },
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.black.withOpacity(0.3),
                        filled: true,
                        border: _border,
                        errorBorder: _errorborder,
                        enabledBorder: _border,
                        label: Text("암호"),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    AnimatedContainer(
                      height: _isSignUp ? 120 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return constraints.biggest.height < 110
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                    focusNode: _password2TextFocusNode,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    validator: (text) {
                                      if (_passwordTextController.text !=
                                          _password2TextController.text) {
                                        return "암호가 다릅니다.";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) {
                                      if (_isSignUp) {
                                        FormState? formState =
                                            (_formKey as GlobalKey<FormState>)
                                                .currentState;

                                        if (formState == null) {
                                          return;
                                        }
                                        formState.validate();
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    controller: _password2TextController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.black.withOpacity(0.3),
                                      filled: true,
                                      border: _border,
                                      errorBorder: _errorborder,
                                      enabledBorder: _border,
                                      label: Text("암호 확인"),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                            });
                          },
                          child: Text(
                            _isSignUp ? "로그인" : "회원가입",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Opacity(
                      opacity: (_showEmailVerifySendOk ||
                              _showLoading ||
                              _showEmailVerifySendFail ||
                              _showLoginFail)
                          ? 0
                          : 1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(size.width * 0.75, 50),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            diaryCellColor,
                          ),
                        ),
                        onPressed: () async {
                          if (_showEmailVerifySendOk ||
                              _showEmailVerifySendFail ||
                              _showLoading ||
                              _showLoginFail) {
                            return;
                          }
                          FormState? _formState =
                              (_formKey as GlobalKey<FormState>).currentState;
                          if (_formState == null) {
                            return;
                          }
                          bool validate = _formState.validate();
                          if (!validate) {
                            return;
                          }

                          setState(() {
                            _showLoading = true;
                          });
                          if (_isSignUp) {
                            //회원 가입 로직
                            print(_emailTextController.text);
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailTextController.text.trim(),
                                      password: _passwordTextController.text);
                              FirebaseAuth.instance.currentUser
                                  ?.sendEmailVerification();
                              setState(() {
                                _showLoading = false;
                              });
                              setState(() {
                                _showEmailVerifySendOk = true;
                              });
                              _opacityAniController.forward().then((value) {
                                setState(() {
                                  _showEmailVerifySendOk = false;
                                });
                                _opacityAniController.reset();
                              });
                            } catch (e) {
                              setState(() {
                                _showLoading = false;
                              });
                              setState(() {
                                _showEmailVerifySendFail = true;
                              });
                              _opacityAniController.forward().then((value) {
                                setState(() {
                                  _showEmailVerifySendFail = false;
                                });
                                _opacityAniController.reset();
                              });
                            }
                          } else {
                            //로그인 로직
                            try {
                              UserCredential credential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: _emailTextController.text.trim(),
                                      password: _passwordTextController.text);

                              String uid =
                                  FirebaseAuth.instance.currentUser?.uid ??
                                      "ERROR_USER";
                              Dio dio = Dio();
                              var response = await dio.post(
                                UserUri.create,
                                data: {
                                  "login_method": "by_email_sign_in",
                                  "access_token_for_sns": "",
                                  "email": _emailTextController.text.trim(),
                                  "auth_uid": uid,
                                },
                              );

                              AccessToken().updateToken(
                                  response.data["access_token"].toString());
                              AccessToken().updateExpireDate(response
                                  .data["access_token_expire_at"]
                                  .toString());

                              RefreshToken().updateToken(
                                  response.data["refresh_token"].toString());
                              RefreshToken().updateExpireDate(response
                                  .data["refresh_token_expire_at"]
                                  .toString());

                              final prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString(
                                  "access_token", AccessToken().token);
                              await prefs.setString("access_token_expire_at",
                                  AccessToken().expireAt);

                              await prefs.setString(
                                  "refresh_token", RefreshToken().token);
                              await prefs.setString("refresh_token_expire_at",
                                  RefreshToken().expireAt);

                              setState(() {
                                _showLoading = false;
                              });
                              ref
                                  .watch(appStateProvider)
                                  .showEmailSignInPage(false);
                              ref.watch(appStateProvider).setIsLoading(true);
                              await DiaryDatabase.init();
                              bool todayDone =
                                  await DiaryDatabase.isTodayDiaryWritten();
                              if (todayDone) {
                                ref
                                    .watch(appStateProvider)
                                    .setTodaysDiaryDone();
                              } else {
                                ref
                                    .watch(appStateProvider)
                                    .setTodaysDiaryNotDone();
                              }

                              ref.watch(appStateProvider).setIsLoading(false);
                              ref.watch(appStateProvider).showLoginPage(false);
                              ref.watch(appStateProvider).setIsLogined(true);
                            } catch (error) {
                              setState(() {
                                _showLoading = false;
                              });
                              setState(() {
                                _showLoginFail = true;
                              });
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                _showLoginFail = false;
                              });
                            }
                          }
                        },
                        child: Text("확인"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              child: IconButton(
                onPressed: () {
                  ref.watch(appStateProvider).showEmailSignInPage(false);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            if (_showLoading)
              Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Lottie.asset(
                    "assets/lotties/loading_lottie.json",
                  ),
                ),
              ),
            if (_showEmailVerifySendOk)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Lottie.asset(
                          "assets/lotties/email_verify_send_ok.json",
                          repeat: _opacityAniController.isCompleted,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _opacityAni,
                        builder: (context, child) => Opacity(
                          opacity: _opacityAni.value,
                          child: Text(
                            "인증 메일을 전송 했습니다",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (_showEmailVerifySendFail)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Lottie.asset(
                          "assets/lotties/fail.json",
                          repeat: _opacityAniController.isCompleted,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _opacityAni,
                        builder: (context, child) => Opacity(
                          opacity: _opacityAni.value,
                          child: Text(
                            "인증 메일 전송 실패",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (_showLoginFail)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Lottie.asset(
                          "assets/lotties/fail.json",
                          repeat: _opacityAniController.isCompleted,
                        ),
                      ),
                      Text("로그인 실패", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
