import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NaverLoginButton extends StatefulWidget {
  const NaverLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<NaverLoginButton> createState() => _NaverLoginButtonState();
}

class _NaverLoginButtonState extends State<NaverLoginButton>
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
    return Consumer(
      builder: (context, ref, child) {
        var stateProvider = ref.watch(appStateProvider);
        return ScaleTransition(
          scale: scaleAni,
          child: ElevatedButton(
            onPressed: () async {
              print("user login start");
              await scaleAniController.forward();
              await scaleAniController.reverse();
              try {
                NaverLoginResult res = await FlutterNaverLogin.logIn();
                stateProvider.showLoginPage(false);
              } catch (error) {
                print(error.toString());
              }
            },
            child: Text(
              "네이버 로그인",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
          ),
        );
      },
    );
  }
}
