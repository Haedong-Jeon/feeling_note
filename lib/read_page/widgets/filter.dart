import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/constants/filter_selection.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/datas/read_page_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Center(
        child: SizedBox(
          height: 220,
          width: 335,
          child: Card(
            elevation: 5,
            color: searchPopupColor,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    "필터",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Builder(builder: (context) {
                    List<Emotion> totalEmotions =
                        ref.read(emotionListChangeNotifierProvider).emotionList;
                    return Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (filterSelection
                                      .containsKey(totalEmotions[i].inKor)) {
                                    setState(() {
                                      filterSelection[totalEmotions[i].inKor] =
                                          !filterSelection[
                                              totalEmotions[i].inKor]!;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 25,
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        filterSelection[totalEmotions[i].inKor]!
                                            ? Colors.blue
                                            : Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      totalEmotions[i].inKor,
                                      style: TextStyle(
                                        color: filterSelection[
                                                totalEmotions[i].inKor]!
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 10),
                  Builder(builder: (context) {
                    List<Emotion> totalEmotions =
                        ref.read(emotionListChangeNotifierProvider).emotionList;

                    return Row(
                      children: [
                        for (int i = 5; i < 9; i++)
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (filterSelection
                                      .containsKey(totalEmotions[i].inKor)) {
                                    setState(() {
                                      filterSelection[totalEmotions[i].inKor] =
                                          !filterSelection[
                                              totalEmotions[i].inKor]!;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 25,
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        filterSelection[totalEmotions[i].inKor]!
                                            ? Colors.blue
                                            : Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      totalEmotions[i].inKor,
                                      style: TextStyle(
                                        color: filterSelection[
                                                totalEmotions[i].inKor]!
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref.watch(readPageStateProvider).setIsFiltering =
                              false;
                          ref.watch(appStateProvider).notifyListenerManually();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.indigo),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(145, 50),
                          ),
                        ),
                        child: Text(
                          "필터링",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.watch(readPageStateProvider).setIsFiltering =
                              false;
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                diaryCellColor),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(145, 50),
                            )),
                        child: Text(
                          "닫기",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
