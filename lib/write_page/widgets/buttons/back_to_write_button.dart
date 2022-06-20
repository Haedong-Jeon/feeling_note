import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackToWriteButton extends StatefulWidget {
  GlobalKey writeKey;
  BackToWriteButton({
    required this.writeKey,
  });
  @override
  State<BackToWriteButton> createState() => _BackToWriteButtonState();
}

class _BackToWriteButtonState extends State<BackToWriteButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      return ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(200, 20),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(bottomNavBarColor),
        ),
        onPressed: () {
          emotionListProvider.toggleSelectCompleteButton();
          // emotionListProvider.contentClear();
          Scrollable.ensureVisible(
            widget.writeKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
        child: const Text(
          "돌아가기",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
