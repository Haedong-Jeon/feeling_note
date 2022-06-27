import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("users/${uid}");
            await ref.set({
              "login_method": "apple_sign_in",
              "last_login_at": DateTime.now().toString(),
            });

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
