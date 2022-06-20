import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/write_page/widgets/buttons/emotion_reselect_button.dart';
import 'package:feeling_note/write_page/widgets/chips/emotion_chip.dart';
import 'package:feeling_note/write_page/widgets/buttons/write_done_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionDiaryWritePart extends StatefulWidget {
  GlobalKey emotionSelectorKey;
  GlobalKey writeTitleKey;
  GlobalKey imageKey;
  bool isEditing;
  List<Emotion> emotionsForEdit = [];
  EmotionDiaryWritePart({
    required this.emotionSelectorKey,
    required this.writeTitleKey,
    required this.imageKey,
    this.isEditing = false,
  });
  @override
  State<EmotionDiaryWritePart> createState() => _EmotionDiaryWritePartState();
}

class _EmotionDiaryWritePartState extends State<EmotionDiaryWritePart>
    with TickerProviderStateMixin {
  List<TextEditingController> textControllers = [];
  List<FocusNode> textFocuses = [];
  int currentShowingWriteBoxIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      var emotionList = emotionListProvider.emotionList;
      return Column(
        crossAxisAlignment: widget.isEditing
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height),
          Text(
            widget.isEditing ? "[수정 중]\n일기 내용을 수정합니다." : "자, 이제 일기를 써볼까요?",
            key: widget.writeTitleKey,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 5),
          Builder(builder: (context) {
            List<Emotion> selectedEmotions =
                emotionListProvider.getSelectedEmotions();
            TabController tabController = TabController(
              length: widget.isEditing
                  ? widget.emotionsForEdit.length
                  : selectedEmotions.length,
              vsync: this,
              initialIndex: currentShowingWriteBoxIndex,
              animationDuration: const Duration(seconds: 1),
            );
            if (!widget.isEditing && widget.emotionsForEdit.isEmpty) {
              for (int i = 0; i < selectedEmotions.length; i++) {
                textControllers.add(
                  TextEditingController(
                    text: selectedEmotions[i].content,
                  ),
                );
              }
            } else {
              for (int i = 0; i < widget.emotionsForEdit.length; i++) {
                textControllers.add(
                  TextEditingController(
                    text: widget.emotionsForEdit[i].content,
                  ),
                );
              }
            }
            selectedEmotions.forEach(
              (_) => textFocuses.add(FocusNode()),
            );

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.345,
                          child: PageView(
                            onPageChanged: (newIndex) {
                              setState(() {
                                currentShowingWriteBoxIndex = newIndex;
                              });
                            },
                            physics: const PageScrollPhysics(),
                            children: [
                              if (!widget.isEditing &&
                                  widget.emotionsForEdit.isEmpty)
                                for (int index = 0;
                                    index < selectedEmotions.length;
                                    index++)
                                  renderWriteCard(
                                    context,
                                    index,
                                    selectedEmotions,
                                    textControllers,
                                  ),
                              if (widget.isEditing &&
                                  widget.emotionsForEdit.isNotEmpty)
                                for (int index = 0;
                                    index < widget.emotionsForEdit.length;
                                    index++)
                                  renderWriteCard(
                                    context,
                                    index,
                                    widget.emotionsForEdit,
                                    textControllers,
                                  ),
                            ],
                          ),
                        ),
                        TabPageSelector(controller: tabController),
                        WriteDoneButton(
                          imageKey: widget.imageKey,
                        ),
                        EmotionReselectButton(
                          emotionSelectorKey: widget.emotionSelectorKey,
                          focuses: textFocuses,
                          isEditing: widget.isEditing,
                          textControllers: textControllers,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }

  Container renderWriteCard(
      BuildContext context,
      int index,
      List<Emotion> selectedEmotions,
      List<TextEditingController> textControllers) {
    return Container(
      margin: const EdgeInsets.only(top: 30, right: 20),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                // height: MediaQuery.of(context).size.height * 0.25,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: TextField(
                        controller: textControllers[index],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          textFocuses[index].unfocus();
                        },
                        maxLines: null,
                        focusNode: textFocuses[index],
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(140),
                        ],
                        onChanged: (val) {
                          setState(() {});
                          selectedEmotions[index].content = val;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "최대 140자로, 간결하게 일기를 써주세요.",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -25,
                child: IgnorePointer(
                  ignoring: true,
                  child: EmotionChip(
                      emotion: selectedEmotions[index],
                      emoji: selectedEmotions[index].emoji),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
