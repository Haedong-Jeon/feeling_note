import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class CompletePage extends StatefulWidget {
  static const valueKey = ValueKey("complete_page");
  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage>
    with SingleTickerProviderStateMixin {
  double opacityValue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      opacityValue = 1;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Consumer(
        builder: (context, ref, child) {
          var appState = ref.watch(appStateProvider);
          var emotionListProvider =
              ref.watch(emotionListChangeNotifierProvider);
          Future.delayed(const Duration(seconds: 3)).then((_) {
            appState.setTodaysDiaryDone();
            emotionListProvider.contentClear();
            if (opacityValue == 1) {
              appState.showCompletePage(false);
              appState.showPreviewPage(false);
            }
          });
          return Scaffold(
            backgroundColor: bottomNavBarColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/lotties/success_lottie.json",
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: opacityValue,
                    child: const Text(
                      "일기가 잘 저장 됐어요!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
