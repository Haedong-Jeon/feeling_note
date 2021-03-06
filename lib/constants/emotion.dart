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
  String inKor = "νλ³΅";
  @override
  String emoji = "π";
  HappyEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class AngryEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "λΆλΈ";
  @override
  String emoji = "π‘";

  AngryEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class SadEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "μ¬ν";
  @override
  String emoji = "π’";

  SadEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class EnjoyEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "μ¦κ±°μ";
  @override
  String emoji = "π";

  EnjoyEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class DepressedEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "μ°μΈ";
  @override
  String emoji = "π";
  DepressedEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class SatisfiedEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "λ§μ‘±";
  @override
  String emoji = "π";

  SatisfiedEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class CalmEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "νμ";
  @override
  String emoji = "π";

  CalmEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}

class HorrorEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "λλ €μ";
  @override
  String emoji = "π°";

  HorrorEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: false, lastFeelDate: lastFeelDate);
}

class LoveEmotion extends Emotion {
  double howMuch = 0.0;
  @override
  String inKor = "μ¬λ";
  @override
  String emoji = "π₯°";

  LoveEmotion({required String lastFeelDate})
      : super(isPositiveEmotion: true, lastFeelDate: lastFeelDate);
}
