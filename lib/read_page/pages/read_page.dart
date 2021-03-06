import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/constants/filter_selection.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/datas/read_page_state_provider.dart';
import 'package:feeling_note/main.dart';
import 'package:feeling_note/read_page/pages/back_up_page.dart';
import 'package:feeling_note/read_page/widgets/action_button.dart';
import 'package:feeling_note/read_page/widgets/db_connection_error_widget.dart';
import 'package:feeling_note/read_page/widgets/diary_list_cell_widget.dart';
import 'package:feeling_note/read_page/widgets/empty_diaries_widget.dart';
import 'package:feeling_note/read_page/widgets/expandable_fab.dart';
import 'package:feeling_note/read_page/widgets/filter.dart';
import 'package:feeling_note/utils/api_connector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feeling_note/DB/diary_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ReadPage extends StatefulWidget {
  AppStateChangeNotifier? appStateProvider;

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage>
    with AutomaticKeepAliveClientMixin<ReadPage> {
  TextEditingController textController = TextEditingController();
  DateTimeRange? dateRange;
  Future? futureForFetchDiaries;
  Future? futureForFetchFromServer;
  List<Emotion>? totalDiaries;
  List<List<Emotion>>? rangedDiaries;
  List<List<Emotion>>? filteredDiaries;
  List<List<Emotion>>? diaries;
  List<List<Emotion>>? searchedDiaries;
  OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  );

  @override
  void initState() {
    futureForFetchFromServer = fetchFromServer();
    futureForFetchDiaries = fetchDiariesFromDB();
    super.initState();
  }

  Future<List<Emotion>?> fetchDiariesFromDB() async {
    return await DiaryDatabase.readDiaries();
  }

  Future fetchFromServer() async {
    final allDiaries = await APIConnector.getAllEmotions();
    final me = await APIConnector.getMe();
    DiaryDatabase.clearDiary();
    await DiaryDatabase.init();
    return await Future.forEach(allDiaries, (element) async {
      Emotion? emotion;
      element as dynamic;

      switch (element["in_kor"]) {
        case "??????":
          emotion = HappyEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "??????":
          emotion = AngryEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;

          break;
        case "??????":
          emotion = SadEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "?????????":
          emotion = EnjoyEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "??????":
          emotion = DepressedEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "??????":
          emotion = SatisfiedEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "??????":
          emotion = CalmEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "?????????":
          emotion = HorrorEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        case "??????":
          emotion = LoveEmotion(
            lastFeelDate: element["last_feel_at"],
          )
            ..userUid = me["auth_uid"]
            ..emoji = element["emoji"]
            ..imageOnlinePath = element["image_online_path"]
            ..lastFeelTime = element["last_feel_at"].toString().substring(11)
            ..content = element["content"]
            ..inKor = element["in_kor"]
            ..id = element["id"]
            ..imagePath = element["image_path"]
            ..isPositiveEmotion = element["is_positive_emotion"]
            ..imageOnlineStorageDepth = ""
            ..isSelected = true;
          break;
        default:
          emotion = null;
          break;
      }
      bool todayDone = await DiaryDatabase.isTodayDiaryWritten();
      if (todayDone) {
        widget.appStateProvider?.setTodaysDiaryDone();
      } else {
        widget.appStateProvider?.setTodaysDiaryNotDone();
      }
      if (emotion != null) {
        DiaryDatabase.insertDiary(emotion);
        setState(() {});
      }
    });
  }

  void searchInDateRange(DateTimeRange? range) {
    if (range == null) {
      return;
    }
    if (diaries == null) {
      return;
    }
    //2022-06-07 00:00:00.000 - 2022-06-14 00:00:00.000
    DateTime start = range.start;
    DateTime end = range.end;

    if (searchedDiaries == null) {
      rangedDiaries = diaries?.where((e) {
        DateTime emotionFeelDate =
            DateTime.parse(e.first.lastFeelDate.replaceAll(".", "-"));

        return (emotionFeelDate.isAfter(start) ||
                emotionFeelDate.isAtSameMomentAs(start)) &&
            (emotionFeelDate.isBefore(end) ||
                emotionFeelDate.isAtSameMomentAs(end));
      }).toList();
      setState(() {});
    } else {
      rangedDiaries = searchedDiaries?.where((e) {
        DateTime emotionFeelDate =
            DateTime.parse(e.first.lastFeelDate.replaceAll(".", "-"));

        return (emotionFeelDate.isAfter(start) ||
                emotionFeelDate.isAtSameMomentAs(start)) &&
            (emotionFeelDate.isBefore(end) ||
                emotionFeelDate.isAtSameMomentAs(end));
      }).toList();
      setState(() {});
    }
  }

  void searchInText() {
    if (textController.text.isEmpty) {
      return;
    }
    if (rangedDiaries == null) {
      searchedDiaries = diaries?.where((element) {
        List list = [];
        list.addAll(element.where((diary) {
          return diary.content.contains(textController.text);
        }).toList());
        return list.isNotEmpty;
      }).toList();
    } else {
      searchedDiaries = rangedDiaries?.where((element) {
        List list = [];
        list.addAll(element.where((diary) {
          return diary.content.contains(textController.text);
        }).toList());
        return list.isNotEmpty;
      }).toList();
    }
    setState(() {});
  }

  void applyFilter() {
    filteredDiaries = diaries?.where((element) {
      List list = [];
      list.addAll(element.where((d) {
        return filterSelection[d.inKor] == true;
      }).toList());
      return list.isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var stateProvider = ref.watch(appStateProvider);
      ref
          .read(emotionListChangeNotifierProvider)
          .emotionList
          .forEach((e) => filterSelection.putIfAbsent(e.inKor, () => false));
      if (filterSelection.containsValue(true)) {
        applyFilter();
      }
      return Stack(
        children: [
          Scaffold(
            backgroundColor: bottomNavBarColor,
            floatingActionButton: rangedDiaries == null &&
                    searchedDiaries == null &&
                    filteredDiaries == null
                ? ExpandableFab(
                    distance: 150,
                    children: [
                      ActionButton(
                        onPressed: () {
                          ref.read(readPageStateProvider).setIsFiltering =
                              !ref.read(readPageStateProvider).isFiltering;
                        },
                        icon: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            "assets/images/filter.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ActionButton(
                        onPressed: () async {
                          ref.read(readPageStateProvider).setIsSearch =
                              !ref.read(readPageStateProvider).isSearching;
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Container(),
            appBar: AppBar(
              backgroundColor: bottomNavBarColor,
              elevation: 0,
              actions: [
                if (searchedDiaries != null && filteredDiaries == null)
                  InkWell(
                    onTap: () {
                      setState(() {
                        searchedDiaries = null;
                      });
                    },
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(width: 10),
                                      Text(
                                        "?????????: " + textController.text,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.close),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                if (filteredDiaries != null && searchedDiaries == null)
                  InkWell(
                    onTap: () {
                      setState(() {
                        filteredDiaries = null;
                        filterSelection.updateAll((key, element) => false);
                      });
                    },
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(width: 10),
                                      Text(
                                        "????????? ??????",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                if (searchedDiaries == null && filteredDiaries == null)
                  rangedDiaries == null
                      ? IconButton(
                          onPressed: () async {
                            dateRange = await showDialog(
                              context: context,
                              builder: (context) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        bottomNavBarColor, // header background color
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary:
                                          Colors.black, // button text color
                                    ),
                                  ),
                                ),
                                child: DateRangePickerDialog(
                                  helpText: "?????? ?????? ??? ????????? ???????????????.",
                                  saveText: "??????",
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  currentDate: DateTime.now().toLocal(),
                                  firstDate: DateTime(2022, 1, 1),
                                  lastDate: DateTime.now(),
                                ),
                              ),
                            );
                            searchInDateRange(dateRange);
                          },
                          icon: Icon(Icons.calendar_month),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              rangedDiaries = null;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        ),
              ],
            ),
            body: FutureBuilder(
                future: futureForFetchFromServer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return renderList(stateProvider);
                  } else {
                    return renderList(stateProvider);
                  }
                }),
          ),
          if (ref.read(readPageStateProvider).isServerUpload)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  BackUpPage()..readProvider = ref.watch(readPageStateProvider),
                ],
              ),
            ),
        ],
      );
    });
  }

  Stack renderList(AppStateChangeNotifier stateProvider) {
    return Stack(
      children: [
        FutureBuilder(
          future: fetchDiariesFromDB(),
          // future: futureForFetchDiaries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              totalDiaries = snapshot.data as List<Emotion>;
              if (totalDiaries == null) {
                //DB ?????? ??????
                return const DBConnectionErrorWidget();
              } else if (totalDiaries!.isEmpty) {
                //????????? ????????? ??????
                return EmptyDiariesWidget(
                  isRangeSearch: rangedDiaries != null,
                );
              } else {
                //?????? ?????????
                if (filteredDiaries != null) {
                  diaries = filteredDiaries;
                }
                if (searchedDiaries != null) {
                  diaries = searchedDiaries;
                }
                if (rangedDiaries != null) {
                  diaries = rangedDiaries;
                }
                if (searchedDiaries == null &&
                    rangedDiaries == null &&
                    filteredDiaries == null) {
                  diaries = groupedByDateDiaries(totalDiaries!);
                }

                if (diaries == null) {
                  return EmptyDiariesWidget(
                      isRangeSearch: rangedDiaries != null);
                }
                if (diaries!.isEmpty) {
                  return EmptyDiariesWidget(
                      isRangeSearch: rangedDiaries != null);
                }

                return renderDiaryList();
              }
            } else {
              //?????? ???
              if (totalDiaries != null) {
                if (!stateProvider.todaysDiaryDone && totalDiaries!.isEmpty) {
                  //????????? ????????? ??????
                  return EmptyDiariesWidget(
                    isRangeSearch: rangedDiaries != null,
                  );
                } else {
                  //?????? ?????????
                  if (filteredDiaries != null) {
                    diaries = filteredDiaries;
                  }
                  if (searchedDiaries != null) {
                    diaries = searchedDiaries;
                  }
                  if (rangedDiaries != null) {
                    diaries = rangedDiaries;
                  }
                  if (searchedDiaries == null &&
                      rangedDiaries == null &&
                      filteredDiaries == null) {
                    diaries = groupedByDateDiaries(totalDiaries!);
                  }

                  // if (diaries == null) {
                  //   return EmptyDiariesWidget(
                  //       isRangeSearch: rangedDiaries != null);
                  // }
                  // if (diaries!.isEmpty) {
                  //   return EmptyDiariesWidget(
                  //       isRangeSearch: rangedDiaries != null);
                  // }
                  return renderDiaryList();
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
            }
          },
        ),
        Consumer(builder: (context, ref, child) {
          return ref.watch(readPageStateProvider).isSearching
              ? Center(
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
                            TextField(
                              autofocus: true,
                              maxLines: 1,
                              controller: textController,
                              maxLength: 10,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.black.withOpacity(0.3),
                                filled: true,
                                border: _border,
                                enabledBorder: _border,
                                label: Text("?????????"),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    searchInText();
                                    ref
                                        .watch(readPageStateProvider)
                                        .setSearchText = textController.text;
                                    ref
                                        .watch(readPageStateProvider)
                                        .setIsSearch = false;
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.indigo),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      Size(145, 50),
                                    ),
                                  ),
                                  child: Text(
                                    "??????",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .watch(readPageStateProvider)
                                        .setSearchText = textController.text;
                                    ref
                                        .watch(readPageStateProvider)
                                        .setIsSearch = false;
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              diaryCellColor),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                        Size(145, 50),
                                      )),
                                  child: Text(
                                    "??????",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("* ?????? ???????????? ??????",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        }),
        Consumer(builder: (context, ref, child) {
          return ref.watch(readPageStateProvider).isFiltering
              ? Filter()
              : Container();
        }),
      ],
    );
  }

  Widget renderDiaryList() {
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) => Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Dismissible(
                      confirmDismiss: (_) async {
                        bool shouldDelete = false;
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("??????"),
                              content: Text("??? ????????? ?????? ?????????????"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    shouldDelete = true;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("???"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    shouldDelete = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("?????????"),
                                ),
                              ],
                            );
                          },
                        );
                        return shouldDelete;
                      },
                      direction: DismissDirection.startToEnd,
                      // secondaryBackground: Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 20, right: 20, top: 10, bottom: 10),
                      //   child: Container(
                      //     padding: const EdgeInsets.only(
                      //         left: 20, right: 20, top: 10, bottom: 10),
                      //     color: diaryCellColor,
                      //   ),
                      // ),
                      background: Container(
                        color: Colors.red,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ]),
                      ),
                      onDismissed: (_) async {
                        await Future.forEach((diaries![index]),
                            (emotion) async {
                          emotion as Emotion;
                          DiaryDatabase.removeDiary(emotion.id);
                          await APIConnector.deleteEmotion(
                              emotionId: emotion.id);
                          await Future.forEach(
                              emotion.imageOnlinePath.split(","),
                              (element) async {
                            element as String;
                            final response = await APIConnector.getImageDetail(
                                path: element);
                            await APIConnector.deleteImage(
                                targetImageId: response["id"]);
                          });
                        });

                        bool todayDone =
                            await DiaryDatabase.isTodayDiaryWritten();
                        if (todayDone) {
                          ref.watch(appStateProvider).setTodaysDiaryDone();
                        } else {
                          ref.watch(appStateProvider).setTodaysDiaryNotDone();
                        }

                        setState(() {
                          diaries?.removeAt(index);
                        });
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.pink,
                              content: Text(
                                '????????? ?????? ?????????',
                              ),
                            ),
                          );
                      },
                      key: Key(diaries?[index].first.id.toString() ?? 'NO_KEY'),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: DiaryListCellWidget(
                          emotions: diaries![index],
                        ),
                      ),
                    ),
                    itemCount: diaries?.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<List<Emotion>> groupedByDateDiaries(List<Emotion> totalDiaries) {
    //????????? ???????????? ???????????? ???????????? ????????? ?????????, ??? ????????? ???????????? ?????? ???????????? ????????? ?????? ??????
    if (totalDiaries.isEmpty) return [];
    String date = totalDiaries.first.lastFeelDate;
    List<List<Emotion>> list = [];

    for (int i = 0; i < totalDiaries.length; i++) {
      bool alreadyExist = false;
      List<Emotion> temp = [];
      list.forEach((element) {
        element.forEach((e) {
          if (e.lastFeelDate == date) {
            alreadyExist = true;
          }
        });
      });
      if (!alreadyExist) {
        temp = totalDiaries.where((d) => d.lastFeelDate == date).toList();
        list.add(temp);
      }
      if (i < totalDiaries.length - 1) {
        date = totalDiaries[i + 1].lastFeelDate;
      }
    }
    // while (totalDiaries.isNotEmpty) {
    //   list.add(totalDiaries.where((d) => d.lastFeelDate == date).toList());
    //   totalDiaries.removeWhere((element) => element.lastFeelDate == date);
    //   if (totalDiaries.isNotEmpty) {
    //     date = totalDiaries.first.lastFeelDate;
    //   }
    // }
    //????????? ??????
    list.sort((a, b) {
      DateTime aDate =
          DateTime.tryParse(a.first.lastFeelDate.replaceAll(".", "-")) ??
              DateTime.now();
      DateTime bDate =
          DateTime.tryParse(b.first.lastFeelDate.replaceAll(".", "-")) ??
              DateTime.now();
      if (aDate.isBefore(bDate)) {
        return 1;
      } else if (aDate.isAtSameMomentAs(bDate)) {
        return 0;
      } else {
        return -1;
      }
    });
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
