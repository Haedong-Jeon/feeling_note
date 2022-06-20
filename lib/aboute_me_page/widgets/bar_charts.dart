import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';

class _BarChart extends StatefulWidget {
  Map<String, int> emotionCount;
  _BarChart({required this.emotionCount});

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> with TickerProviderStateMixin {
  List<Animation<double>> countAnis = [];
  List<AnimationController> countAniControllers = [];
  Map<String, int> getMostPopularEmotion() {
    int count = 0;
    String name = "";
    widget.emotionCount.forEach((key, value) {
      if (count < value) {
        count = value;
        name = key;
      }
    });
    if (count < 5) {
      count = 5;
    }
    return {name: count};
  }

  @override
  void initState() {
    for (int i = 0; i < widget.emotionCount.entries.length; i++) {
      double val = widget.emotionCount[widget.emotionCount.keys.toList()[i]]
              ?.toDouble() ??
          0.0;
      countAniControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 150)));
      countAnis.add(
          Tween<double>(begin: 0.0, end: val).animate(countAniControllers[i]));
    }
    super.initState();
  }

  void barChartAnimationStart() async {
    countAniControllers.forEach((element) async {
      await element.forward();
    });
  }

  void barChartAnimationReverse() async {
    countAniControllers.forEach((element) async {
      await element.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var stateProvider = ref.watch(appStateProvider);
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        await Future.delayed(Duration(milliseconds: 100));
        if (stateProvider.aboutMeAniGo) {
          barChartAnimationStart();
        }
      });
      return AnimatedBuilder(
          animation: countAnis.first,
          builder: (contet, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: barGroups,
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: getMostPopularEmotion().values.first.toDouble(),
                ),
              ),
            );
          });
    });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    text = widget.emotionCount.keys.toList()[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 79, 144, 248),
      Color.fromARGB(255, 69, 112, 232),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    return [
      for (int i = 0; i < widget.emotionCount.entries.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: countAnis[i].value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: countAnis[i].value == 0 ? null : [0],
        ),
    ];
  }
}

class EmotionBarChart extends StatefulWidget {
  Map<String, int> emotionCount;
  EmotionBarChart({required this.emotionCount});

  @override
  State<StatefulWidget> createState() => EmotionBarChartState();
}

class EmotionBarChartState extends State<EmotionBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: diaryCellColor,
          child: _BarChart(emotionCount: widget.emotionCount),
        ),
      ),
    );
  }
}
