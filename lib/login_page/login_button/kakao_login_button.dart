import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginButton extends StatefulWidget {
  const KakaoLoginButton({
    Key? key,
  }) : super(key: key);

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton>
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
              if (await isKakaoTalkInstalled()) {
                await UserApi.instance.loginWithKakaoTalk();
                stateProvider.showLoginPage(false);
                stateProvider.setIsLogined(true);
              } else {
                await UserApi.instance.loginWithKakaoAccount();
                stateProvider.showLoginPage(false);
                stateProvider.setIsLogined(true);
              }
            } catch (error) {
              if (error is PlatformException && error.code == 'CANCELED') {
                return;
              }
            }
          },
          child: Text(
            "카카오 로그인",
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
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          ),
        ),
      );
    });
  }
}
