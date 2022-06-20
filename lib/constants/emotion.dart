import 'package:json_annotation/json_annotation.dart';

part 'emotion.g.dart';

@JsonSerializable()
class Emotion {
  bool isPositiveEmotion;
  String lastFeelDate;
  String imagePath = "";
  String imageOnlinePath = "";
  String imageOnlineStorageDepth = "";
  String lastFeelTime = "";
  bool isSelected = false;
  String inKor = "";
  String emoji = "";
  String content = "";
  String userUid = "";
  late int id;

  Emotion({required this.isPositiveEmotion, required this.lastFeelDate}) {
    lastFeelDate = lastFeelDate.replaceAll("-", ".").substring(0, 10);
    id = 0;
  }

  factory Emotion.fromJson(Map<String, dynamic> json) =>
      _$EmotionFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionToJson(this);
}

class HappyEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "행복";
  @override
  String emoji = "😊";
  HappyEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class AngryEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "분노";
  @override
  String emoji = "😡";

  AngryEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class SadEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "슬픔";
  @override
  String emoji = "😢";

  SadEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class EnjoyEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "즐거움";
  @override
  String emoji = "😁";

  EnjoyEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class DepressedEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "우울";
  @override
  String emoji = "😞";
  DepressedEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class SatisfiedEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "만족";
  @override
  String emoji = "😋";

  SatisfiedEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class CalmEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "평안";
  @override
  String emoji = "😙";

  CalmEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class HorrorEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "두려움";
  @override
  String emoji = "😰";

  HorrorEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class LoveEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "사랑";
  @override
  String emoji = "🥰";

  LoveEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}
