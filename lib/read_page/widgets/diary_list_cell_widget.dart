import 'dart:developer';
import 'dart:io';

import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/read_page/pages/read_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryListCellWidget extends StatefulWidget {
  List<Emotion> emotions;
  DiaryListCellWidget({required this.emotions});

  @override
  State<StatefulWidget> createState() => _DiaryListCellWidgetState();
}

class _DiaryListCellWidgetState extends State<DiaryListCellWidget>
    with TickerProviderStateMixin {
  late Animation<double> scaleAni;
  late AnimationController scaleAniController;

  @override
  void initState() {
    scaleAniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    scaleAni = Tween<double>(begin: 1.0, end: 1.1).animate(scaleAniController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String diaryDate = widget.emotions.first.lastFeelDate.substring(5);
    String diaryImagePath = "";
    diaryImagePath = widget.emotions.first.imageOnlinePath.split(",").first;

    return Consumer(builder: (context, ref, child) {
      var appState = ref.watch(appStateProvider);
      return ScaleTransition(
        scale: scaleAni,
        child: ListTile(
          onTap: () async {
            await scaleAniController.forward();
            await scaleAniController.reverse();
            appState.currentShowingDiary = widget.emotions;
            appState.showDetailPage(true);
          },
          leading: Hero(
            tag: widget.emotions
                .map((e) => e.id)
                .reduce((value, element) => value + element),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: Image.network(
                  widget.emotions.first.imageOnlinePath,
                  width: 100,
                  height: 100,
                  errorBuilder: (context, exception, stackTrace) {
                    return Center(
                      child: Image.asset("assets/images/gallery.png",
                          fit: BoxFit.cover),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          tileColor: diaryCellColor,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildEmotionBadges(),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      diaryDate,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          subtitle: Text(
            widget.emotions.first.content,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Row buildEmotionBadges() {
    List<Widget> list = [];
    list = widget.emotions.map((e) {
      return Row(
        children: [
          Container(
            height: 25,
            padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: e.isPositiveEmotion ? Colors.indigo : Colors.pink,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: e.isPositiveEmotion ? Colors.indigo : Colors.pink,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                e.inKor,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      );
    }).toList();
    if (list.length < 4) {
      return Row(
        children: [...list],
      );
    } else {
      return Row(
        children: [
          for (int i = 0; i < 3; i++) list[i],
          Text(
            "...",
            style: TextStyle(color: Colors.white),
          )
        ],
      );
    }
  }
}
