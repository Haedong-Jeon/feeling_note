import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/aboute_me_page/widgets/bar_charts.dart';
import 'package:feeling_note/aboute_me_page/widgets/line_charts.dart';
import 'package:feeling_note/aboute_me_page/widgets/not_enough_data.dart';
import 'package:feeling_note/aboute_me_page/widgets/pie_charts.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:lottie/lottie.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({Key? key}) : super(key: key);

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  List<Emotion>? totalDiaries;
  Map<String, int> emotionCountMap = {};
  Map<String, int> emotionPositiveMap = {};
  List<String> diaryWroteTimes = [];
  late Future futureForFetchEmotion;
  @override
  void initState() {
    futureForFetchEmotion = fetchDiariesFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionProvider = ref.watch(emotionListChangeNotifierProvider);
      var stateProvider = ref.watch(appStateProvider);
      List<Emotion> emotionList = emotionProvider.emotionList;
      return FocusDetector(
        onFocusGained: () {
          stateProvider.setAboutMeAniGo(true);
        },
        child: Scaffold(
          backgroundColor: bottomNavBarColor,
          body: FutureBuilder(
            future: futureForFetchEmotion,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                totalDiaries = snapshot.data as List<Emotion>;
                emotionCountMap = setEmotionCount(
                    wroteEmotions: totalDiaries!, totalEmotions: emotionList);
                emotionPositiveMap =
                    setPositiveAndNegative(wroteEmotions: totalDiaries!);
                diaryWroteTimes = getWroteTimes(wroteEmotions: totalDiaries!);

                if (totalDiaries!.isEmpty) {
                  return Center(child: NotEnoughData());
                } else if (emotionCountMap == {} || emotionPositiveMap == {}) {
                  return Center(child: NotEnoughData());
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        (emotionPositiveMap["positive"] ?? 0) >=
                                (emotionPositiveMap["negative"] ?? 0)
                            ? Column(
                                children: [
                                  Text(
                                    "당신의 마음은 건강합니다..!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Lottie.asset(
                                      "assets/lotties/happy_lottie.json",
                                      repeat: false,
                                      height: 300),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    "당신의 마음은 상처가 있어 보여요..",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Lottie.asset("assets/lotties/help_me.json",
                                      repeat: false, height: 300),
                                ],
                              ),
                        SizedBox(height: 40),
                        Text(
                          "각 감정들을 이만큼 느꼈어요 :)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        EmotionBarChart(emotionCount: emotionCountMap),
                        SizedBox(height: 40),
                        Text(
                          "긍정적이었는지 한번 볼까요?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        EmotionPieChart(emotionPositiveMap: emotionPositiveMap),
                        SizedBox(height: 40),
                        Text(
                          "언제 일기를 썼을까요?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        EmotionLineCharts(wroteTimes: diaryWroteTimes),
                        SizedBox(height: 40),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child:
                          Lottie.asset("assets/lotties/loading_lottie.json")),
                );
              }
            },
          ),
        ),
      );
    });
  }

  Future<List<Emotion>?> fetchDiariesFromDB() async {
    await DiaryDatabase.init();
    return await DiaryDatabase.readDiaries();
  }

  Map<String, int> setEmotionCount(
      {List<Emotion>? wroteEmotions, List<Emotion>? totalEmotions}) {
    if (totalEmotions == null) {
      return {};
    }
    if (totalEmotions.isEmpty) {
      return {};
    }
    if (wroteEmotions == null) {
      return {};
    }
    if (wroteEmotions.isEmpty) {
      return {};
    }

    List<String> wroteKorList = wroteEmotions.map((e) => e.inKor).toList();
    List<String> totalKorList = totalEmotions.map((e) => e.inKor).toList();
    Map<String, int> _emotionCountMap = {};
    totalKorList.forEach((element) {
      _emotionCountMap.putIfAbsent(element, () => 0);
    });

    for (String emo in totalKorList) {
      for (String kor in wroteKorList) {
        if (emo == kor) {
          _emotionCountMap.update(kor, (value) => value + 1);
        }
      }
    }
    return _emotionCountMap;
  }

  Map<String, int> setPositiveAndNegative({List<Emotion>? wroteEmotions}) {
    if (wroteEmotions == null) {
      return {};
    }
    if (wroteEmotions.isEmpty) {
      return {};
    }

    Map<String, int> _emotionCountMap = {};
    List<bool> positives =
        wroteEmotions.map((e) => e.isPositiveEmotion).toList();
    _emotionCountMap.putIfAbsent("total", () => positives.length);
    _emotionCountMap.putIfAbsent("positive",
        () => positives.where((element) => element == true).toList().length);
    _emotionCountMap.putIfAbsent("negative",
        () => positives.where((element) => element == false).toList().length);
    return _emotionCountMap;
  }

  List<String> getWroteTimes({List<Emotion>? wroteEmotions}) {
    List<String> list = [];
    if (wroteEmotions == null) {
      return [];
    }
    if (wroteEmotions.isEmpty) {
      return [];
    }
    try {
      wroteEmotions.forEach((element) {
        String lastFeelTime = element.lastFeelTime;
        List<String> splitTime = lastFeelTime.split(":");
        if (int.parse(splitTime[1]) > 30) {
          splitTime.first = (int.parse(splitTime.first) + 1).toString();
        }
        lastFeelTime = splitTime.join(":");
        list.add(lastFeelTime);
      });
    } catch (e) {}
    return list;
  }
}
