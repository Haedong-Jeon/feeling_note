import 'dart:developer';

import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleLoginButton> createState() => _AppleLoginButtonState();
}

class _AppleLoginButtonState extends State<GoogleLoginButton>
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
            try {
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn().signIn();

              final GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
              );
              stateProvider.setIsLoading(true);
              await FirebaseAuth.instance.signInWithCredential(credential);
              String uid =
                  FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
              DatabaseReference ref =
                  FirebaseDatabase.instance.ref("users/${uid}");
              await ref.set({
                "login_method": "google_sign_in",
                "last_login_at": DateTime.now().toString(),
              });

              //백엔드 연결 됐을 땐, 백엔드로 googleAuth.accessToken을 전달 해야 한다.
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
            } catch (e) {
              print(e.toString());
            }
          },
          child: Text(
            "구글 로그인",
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
