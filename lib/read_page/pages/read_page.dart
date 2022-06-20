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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feeling_note/DB/diary_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqlite_api.dart';

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
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref("diaries/${userUid}");
    DatabaseEvent datas = await databaseReference.once();
    return await Future.forEach(datas.snapshot.children, (element) async {
      element as DataSnapshot;
      if (element.key != "lastDiaryWroteAt") {
        dynamic value = element.value as dynamic;
        Emotion? emotion;

        switch (value["inKor"]) {
          case "행복":
            emotion = HappyEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "분노":
            emotion = AngryEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "슬픔":
            emotion = SadEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "즐거움":
            emotion = EnjoyEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "우울":
            emotion = DepressedEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "만족":
            emotion = SatisfiedEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "평안":
            emotion = CalmEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "두려움":
            emotion = HorrorEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
              ..isSelected = true;
            break;
          case "사랑":
            emotion = LoveEmotion(
              lastFeelDate: value["lastFeelDate"],
            )
              ..userUid = userUid
              ..emoji = value["emoji"]
              ..imageOnlinePath = value["imageOnlinePath"]
              ..lastFeelTime = value["lastFeelTime"]
              ..content = value["content"]
              ..inKor = value["inKor"]
              ..id = value["id"]
              ..imagePath = value["deviceImagePath"]
              ..isPositiveEmotion = value["isPositiveEmotion"]
              ..imageOnlineStorageDepth = value["imageOnlineStorageDepth"]
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
          DiaryDatabase.clearDiary();
          DiaryDatabase.insertDiary(emotion);
        }
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
                                        "검색어: " + textController.text,
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
                        filterSelection.updateAll((key, value) => false);
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
                                        "필터링 해제",
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
                                  helpText: "기한 범위 내 일기를 검색합니다.",
                                  saveText: "확인",
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
                //DB 연결 오휴
                return const DBConnectionErrorWidget();
              } else if (totalDiaries!.isEmpty) {
                //저장된 일기가 없음
                return EmptyDiariesWidget(
                  isRangeSearch: rangedDiaries != null,
                );
              } else {
                //일기 리스트
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
              //로딩 중
              if (totalDiaries != null) {
                if (!stateProvider.todaysDiaryDone && totalDiaries!.isEmpty) {
                  //저장된 일기가 없음
                  return EmptyDiariesWidget(
                    isRangeSearch: rangedDiaries != null,
                  );
                } else {
                  //일기 리스트
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
                                label: Text("검색어"),
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
                                    "검색",
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
                                    "닫기",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("* 일기 내용으로 검색",
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
                              title: Text("삭제"),
                              content: Text("이 일기를 정말 지울까요?"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    shouldDelete = true;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("네"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    shouldDelete = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("아니오"),
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
                        String userUid =
                            FirebaseAuth.instance.currentUser?.uid ??
                                "ERROR_USER";
                        diaries?[index].forEach((emotion) async {
                          DiaryDatabase.removeDiary(emotion.id);
                          DatabaseReference databaseReference =
                              FirebaseDatabase.instance.ref(
                            "diaries/${userUid}/${emotion.id.toString().replaceAll(userUid, "")}",
                          );
                          databaseReference.remove();

                          final storageRef = FirebaseStorage.instance.ref();
                          final itemList = await storageRef
                              .child(
                                  "${userUid}/${emotion.id.toString().replaceAll(userUid, "")}")
                              .listAll();
                          itemList.items.forEach((element) {
                            // element as Reference;
                            element.delete();
                          });
                        });
                        DatabaseReference databaseReference =
                            FirebaseDatabase.instance.ref("diaries/${userUid}");
                        DatabaseEvent event = await databaseReference.once();
                        List<DataSnapshot> children =
                            event.snapshot.children.toList();
                        List<DataSnapshot> diaryList = children
                            .where(
                                (element) => element.key != "lastDiaryWroteAt")
                            .toList();
                        DateTime date = DateTime(2314, 1, 1);
                        diaryList.forEach((element) {
                          if (element.key == "lastFeelDate") {
                            DateTime feelDate =
                                DateTime.parse(element.value.toString());
                            if (feelDate.isAfter(date)) {
                              date = feelDate;
                            }
                          }
                        });
                        await databaseReference
                            .set({"lastDiaryWroteAt": date.toString()});
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
                                '일기가 삭제 됐어요',
                              ),
                            ),
                          );
                      },
                      key: Key(diaries?[index].first.id.toString() ?? 'NO_KEY'),
                      child: DiaryListCellWidget(
                        emotions: diaries![index],
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
    //하나의 날짜에도 감정별로 데이터가 나눠져 있는데, 그 흩어진 데이터를 날짜 기준으로 그룹화 하는 함수
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
    //날짜별 정렬
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
