import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionReselectButton extends StatefulWidget {
  GlobalKey emotionSelectorKey;
  List<FocusNode> focuses;
  List<TextEditingController> textControllers;
  bool isEditing;
  EmotionReselectButton(
      {required this.emotionSelectorKey,
      required this.focuses,
      this.isEditing = false,
      required this.textControllers});
  @override
  State<EmotionReselectButton> createState() => _EmotionReselectButtonState();
}

class _EmotionReselectButtonState extends State<EmotionReselectButton> {
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
          emotionListProvider.makeSelectCompleteButtonOff();
          // emotionListProvider.contentClear();
          for (FocusNode focus in widget.focuses) {
            focus.unfocus();
          }
          for (TextEditingController controller in widget.textControllers) {
            controller.text = "";
          }

          Scrollable.ensureVisible(
            widget.emotionSelectorKey.currentContext!,
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
