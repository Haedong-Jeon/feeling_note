import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';

class EmotionPieChart extends StatefulWidget {
  Map<String, int> emotionPositiveMap;
  EmotionPieChart({required this.emotionPositiveMap});

  @override
  State<StatefulWidget> createState() => EmotionPieChartState();
}

class EmotionPieChartState extends State<EmotionPieChart>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late Animation<double> scaleAnimation;
  late AnimationController scaleAnimationController;

  @override
  void initState() {
    scaleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    scaleAnimation =
        Tween<double>(begin: 0.4, end: 1).animate(scaleAnimationController)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  void scaleAnimationStart() async {
    await Future.delayed(Duration(milliseconds: 150));
    await scaleAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var stateProvider = ref.watch(appStateProvider);
      scaleAnimationStart();

      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Card(
          color: diaryCellColor,
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              children: [
                Expanded(
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "긍정적",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.pink[300],
                          ),
                          SizedBox(width: 10),
                          Text(
                            "부정적",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 65.0 : 40.0;

      switch (i) {
        case 0:
          double posValue =
              ((widget.emotionPositiveMap["positive"]?.toDouble() ?? 0) /
                  (widget.emotionPositiveMap["total"]?.toDouble() ?? 1));
          return PieChartSectionData(
            color: Colors.indigo,
            value: posValue,
            title: (posValue * 100).round().toString() + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/ophthalmology-svgrepo-com.svg',
              size: widgetSize,
              isPositive: true,
              borderColor: Colors.indigo,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          double negValue =
              ((widget.emotionPositiveMap["negative"]?.toDouble() ?? 0) /
                  (widget.emotionPositiveMap["total"]?.toDouble() ?? 1));
          return PieChartSectionData(
            color: Colors.pink[300],
            value: negValue,
            title: (negValue * 100).round().toString() + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/librarian-svgrepo-com.svg',
              size: widgetSize,
              isPositive: false,
              borderColor: Colors.pink[300]!,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  final bool isPositive;
  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.isPositive,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: size < 50
            ? Text(isPositive ? "🙂" : "😡")
            : Text(
                isPositive ? "🙂\n긍정적" : "😡\n부정적",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
      ),
    );
  }
}
