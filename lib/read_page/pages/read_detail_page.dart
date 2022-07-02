import 'dart:developer';
import 'dart:io' as io;

import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/utils/api_connector.dart';
import 'package:feeling_note/write_page/pages/write_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ReadDetailPage extends StatefulWidget {
  static const valueKey = ValueKey("read_detail_page");
  static const String routeName = "/diary_detail/";
  List<Emotion> emotions;
  ReadDetailPage({required this.emotions});
  @override
  State<ReadDetailPage> createState() => _ReadDetailPageState();
}

class _ReadDetailPageState extends State<ReadDetailPage> {
  var appState;
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      if (widget.emotions.isEmpty) return Container();
      var appState = ref.watch(appStateProvider);
      return WillPopScope(
        onWillPop: () async {
          appState.showDetailPage(false);
          return true;
        },
        child: Scaffold(
          backgroundColor: bottomNavBarColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                stretch: true,
                pinned: true,
                backgroundColor: bottomNavBarColor,
                title: Text(
                  widget.emotions.first.lastFeelDate,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("삭제"),
                                content: Text("이 일기를 정말 지울까요?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await Future.forEach(widget.emotions,
                                          (element) async {
                                        element as Emotion;
                                        await APIConnector.deleteEmotion(
                                            emotionId: element.id);
                                        DiaryDatabase.removeDiary(element.id);
                                      });
                                      bool todayDone = await DiaryDatabase
                                          .isTodayDiaryWritten();
                                      if (todayDone) {
                                        ref
                                            .watch(appStateProvider)
                                            .todaysDiaryDone = true;
                                      } else {
                                        ref
                                            .watch(appStateProvider)
                                            .todaysDiaryDone = false;
                                      }
                                      Navigator.of(context).pop();
                                      ref
                                          .watch(appStateProvider)
                                          .showDetailPage(false);
                                    },
                                    child: Text("네"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("아니오"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            "삭제",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("삭제"),
                                content: Text("이 일기를 정말 수정 할까요?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => WritePage()
                                      //       ..isEditing = true
                                      //       ..emotionsForEdit = widget.emotions,
                                      //   ),
                                      // );
                                      Navigator.of(context).pop();
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 600,
                                              child: WritePage()
                                                ..isEditing = true
                                                ..emotionsForEdit =
                                                    widget.emotions,
                                            );
                                          });
                                    },
                                    child: Text("네"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("아니오"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            "수정",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                expandedHeight: size.height * 0.5,
                flexibleSpace: Hero(
                  tag: widget.emotions
                      .map((e) => e.id)
                      .reduce((value, element) => value + element),
                  child: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                      ],
                      background: SizedBox(
                        child: Builder(builder: (context) {
                          return PageView(
                            children: [
                              for (String url in widget
                                  .emotions.first.imageOnlinePath
                                  .split(","))
                                Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        child: FadeInImage(
                                          image: NetworkImage(
                                            url,
                                          ),
                                          fit: BoxFit.cover,
                                          placeholderFit: BoxFit.contain,
                                          placeholder: AssetImage(
                                            "assets/images/gallery.png",
                                          ),
                                          imageErrorBuilder:
                                              (context, exception, stackTrace) {
                                            return Center(
                                              child: Image.asset(
                                                  "assets/images/gallery.png",
                                                  fit: BoxFit.cover),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.3),
                                    )
                                  ],
                                )
                            ],
                          );
                        }),
                      )),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.emotions
                        .map((emo) => emo.emoji)
                        .reduce((value, element) => value + " " + element),
                  ),
                ),
              ),
              for (int i = 0; i < widget.emotions.length; i++)
                SliverToBoxAdapter(
                  child: Container(
                    color: bottomNavBarColor,
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "⟪" + widget.emotions[i].inKor + "⟫",
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SelectableText(
                          widget.emotions[i].content,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              )
            ],
          ),
        ),
      );
    });
  }
}
