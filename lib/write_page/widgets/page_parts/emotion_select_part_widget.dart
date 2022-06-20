import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/write_page/widgets/chips/emotion_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionSelectPartWidget extends StatefulWidget {
  GlobalKey emotionSelectorKey;
  GlobalKey writeTitleKey;
  bool isEditing;
  List<Emotion> emotionsForEdit = [];
  EmotionSelectPartWidget(
      {this.isEditing = false,
      required this.emotionSelectorKey,
      required this.writeTitleKey});

  @override
  State<EmotionSelectPartWidget> createState() =>
      _EmotionSelectPartWidgetState();
}

class _EmotionSelectPartWidgetState extends State<EmotionSelectPartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      var emotionList = emotionListProvider.emotionList;
      var appState = ref.watch(appStateProvider);
      return Column(
        children: [
          Text(
            widget.isEditing
                ? "[수정 중]\n어떤 감정을 이야기 하고 싶나요?"
                : "오늘은 어떤 감정에대해 이야기 하고 싶나요?",
            key: widget.emotionSelectorKey,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20.0,
            children: [
              for (Emotion emotion in emotionList)
                EmotionChip(emotion: emotion, emoji: emotion.emoji)
                  ..emotionListForEdit = widget.emotionsForEdit,
            ],
          ),
          const SizedBox(height: 30),
          Visibility(
            visible: emotionListProvider.checkIfSelectedEmotionExist(),
            child: Row(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Builder(builder: (context) {
                    return Checkbox(
                      value: emotionListProvider.isEmotionSelectComplete,
                      onChanged: (val) => setState(() {
                        emotionListProvider.isEmotionSelectComplete = val!;

                        if (emotionListProvider.isEmotionSelectComplete) {
                          Future.delayed(const Duration(milliseconds: 300))
                              .then(
                            (value) => Scrollable.ensureVisible(
                              widget.writeTitleKey.currentContext!,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            ),
                          );
                        }
                      }),
                    );
                  }),
                ),
                const Text("일기에 쓸 감정을 다 선택 했어요",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      );
    });
  }
}
