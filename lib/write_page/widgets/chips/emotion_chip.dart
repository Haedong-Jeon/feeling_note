import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionChip extends StatefulWidget {
  Emotion emotion;
  String emoji;
  List<Emotion> emotionListForEdit = [];
  EmotionChip({required this.emotion, required this.emoji});
  @override
  State<EmotionChip> createState() => _EmotionChipState();
}

class _EmotionChipState extends State<EmotionChip> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.emotionListForEdit.isNotEmpty) {
      //감정 선택이 누적 되는 걸 막기 위해서, 수정을 하려고 왔다면 우선 선택 된 감정들을 리셋 한다.
      widget.emotion.isSelected = false;
      if (widget.emotionListForEdit
          .any((element) => element.emoji == widget.emotion.emoji)) {
        //선택 된 감정들을 리셋한 다음, 수정한 일기에서 선택했던 감정들을 다시 선택한다.
        widget.emotion.isSelected = true;
        widget.emotion.lastFeelDate =
            widget.emotionListForEdit.first.lastFeelDate;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      return GestureDetector(
        onTap: () async => setState(() {
          bool isMaximumSelectionExceeded =
              emotionListProvider.checkIfMaximumSelectionExceeded();
          if (isMaximumSelectionExceeded && !widget.emotion.isSelected) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("너무 많아요!"),
                content: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: "오늘 가장 강하게 느꼈던 감정",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: " 3개까지",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " 골라주세요. 하루 동안 느꼈던 수많은 감정 중",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: " 어떤 감정을 돌아보고 기록하고 싶은지 ",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "신중히 골라주세요!",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(200, 30),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(bottomNavBarColor),
                      alignment: Alignment.center,
                    ),
                    onPressed: () {
                      // emotionListProvider.isEmotionSelectComplete = false;
                      Navigator.of(context).pop();
                    },
                    child: const Text("네! 이해 했습니다."),
                  ),
                ],
              ),
            );
            emotionListProvider.notifyListenerManually();
            return;
          }
          widget.emotion.isSelected = !widget.emotion.isSelected;
          if (widget.emotionListForEdit.isNotEmpty) {
            widget.emotion.lastFeelDate =
                widget.emotionListForEdit.first.lastFeelDate;

            if (widget.emotion.isSelected) {
              widget.emotion.content = "";
              widget.emotionListForEdit.add(widget.emotion);
            } else {
              widget.emotionListForEdit.removeWhere((element) =>
                  element.lastFeelDate == widget.emotion.lastFeelDate &&
                  element.emoji == widget.emotion.emoji);
            }
          } else {
            if (!widget.emotion.isSelected) {
              widget.emotion.content = "";
            }
          }
          emotionListProvider.notifyListenerManually();
        }),
        child: Chip(
          backgroundColor: widget.emotion.isSelected
              ? widget.emotion.isPositiveEmotion
                  ? Colors.blueAccent
                  : Colors.redAccent
              : Colors.white,
          label: Text(
            widget.emoji + " " + widget.emotion.inKor,
            style: TextStyle(
              fontSize: 20,
              color: widget.emotion.isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
