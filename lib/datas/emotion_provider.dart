import 'package:feeling_note/constants/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _EmotionListChangeNotifier extends ChangeNotifier {
  List<Emotion> emotionList = [
    HappyEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    SadEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    SatisfiedEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    AngryEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    HorrorEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    CalmEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    EnjoyEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    DepressedEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
    LoveEmotion(
      lastFeelDate: DateTime.now().toLocal().toString(),
    )..lastFeelTime = DateTime.now().toLocal().toString().substring(11, 19),
  ];
  bool isEmotionSelectComplete = false;

  bool checkIfSelectedEmotionExist() {
    bool isExist = false;
    for (Emotion e in emotionList) {
      if (e.isSelected) isExist = true;
    }
    if (!isExist) {
      isEmotionSelectComplete = false;
    }
    return isExist;
  }

  bool checkIfMaximumSelectionExceeded() {
    int count = 0;

    for (Emotion e in emotionList) {
      if (e.isSelected) count++;
    }
    if (count >= 3) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfNoSelectedEmotion() {
    int count = 0;

    for (Emotion e in emotionList) {
      if (e.isSelected) count++;
    }
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  void selectionClear() {
    for (var e in emotionList) {
      e.isSelected = false;
    }
    notifyListeners();
  }

  void notifyListenerManually() {
    notifyListeners();
  }

  void toggleSelectCompleteButton() {
    isEmotionSelectComplete = !isEmotionSelectComplete;
    notifyListeners();
  }

  void makeSelectCompleteButtonOff() {
    isEmotionSelectComplete = false;
    notifyListeners();
  }

  String getSelectedEmotionKorName() {
    if (checkIfNoSelectedEmotion()) return "";
    return emotionList
        .where((element) => element.isSelected)
        .map((element) => element.inKor)
        .toList()
        .reduce((value, element) => value + ", " + element);
  }

  List<Emotion> getSelectedEmotions() {
    if (checkIfNoSelectedEmotion()) return [];
    return emotionList.where((element) => element.isSelected).toList();
  }

  void contentClear() {
    for (Emotion emo in emotionList) {
      emo.isSelected = false;
      emo.content = "";
      emo.imagePath = "";
    }
    notifyListeners();
  }
}

final emotionListChangeNotifierProvider =
    ChangeNotifierProvider<_EmotionListChangeNotifier>(
  (ref) => _EmotionListChangeNotifier(),
);
