import 'dart:developer';
import 'dart:io';

import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:feeling_note/write_page/pages/already_written_page.dart';
import 'package:feeling_note/write_page/widgets/chips/emotion_chip.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class WritePage extends StatefulWidget {
  bool isEditing = false;
  List<Emotion> emotionsForEdit = [];
  TabController? tabController;
  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> with TickerProviderStateMixin {
  List<String> selectedImagesPaths = [];
  List<String> selectedImagesDepths = [];
  List<int> editTargetIds = [];
  bool? alreadyWrote;
  List<TextEditingController> textControllersForEdit = [];
  GlobalKey _formKey = GlobalKey<FormState>();
  late AnimationController failLottieController;
  bool onPressedWhenNoEmotion = false;
  bool isLoading = false;
  bool isError = false;

  OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
  );
  OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );
  void getLastWroteDate() async {
    if (widget.isEditing) {
      setState(() {
        alreadyWrote = false;
      });
      return;
    }
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
    DatabaseReference databaseReference = await FirebaseDatabase.instance
        .ref("diaries/${userUid}/lastDiaryWroteAt");
    DatabaseEvent data = await databaseReference.once();
    if (data.snapshot.value == null) {
      setState(() {
        alreadyWrote = false;
      });
      return;
    }
    String date = data.snapshot.value as String;
    DateTime lastAtDB = DateTime.parse(date);
    lastAtDB = DateTime(lastAtDB.year, lastAtDB.month, lastAtDB.day);
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (today.isAfter(lastAtDB) || today.isAtSameMomentAs(lastAtDB)) {
      setState(() {
        alreadyWrote = true;
      });
    } else {
      setState(() {
        alreadyWrote = false;
      });
    }
  }

  @override
  void initState() {
    getLastWroteDate();
    if (widget.emotionsForEdit.isNotEmpty) {
      for (Emotion emo in widget.emotionsForEdit) {
        textControllersForEdit.add(TextEditingController(text: emo.content));
        editTargetIds.add(emo.id);
      }
      widget.emotionsForEdit.first.imageOnlinePath
          .split(",")
          .forEach((element) {
        if (element != "") {
          selectedImagesPaths.add(element);
        }
      });
      widget.emotionsForEdit.first.imageOnlineStorageDepth
          .split(",")
          .forEach((element) {
        if (element != "") {
          selectedImagesDepths.add(element);
        }
      });
    }
    failLottieController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addListener(() {
            if (failLottieController.isCompleted) {
              setState(() {
                isError = false;
              });
              failLottieController.reset();
            }
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return alreadyWrote == null
        ? Container(
            color: bottomNavBarColor,
          )
        : alreadyWrote!
            ? AlreadyWrittenPage()
            : Consumer(builder: (context, ref, child) {
                var emotionListProvider =
                    ref.watch(emotionListChangeNotifierProvider);
                var stateProvider = ref.watch(appStateProvider);
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Stack(
                    children: [
                      IgnorePointer(
                        ignoring: isLoading || isError,
                        child: Scaffold(
                          persistentFooterButtons: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        diaryCellColor),
                                fixedSize: MaterialStateProperty.all<Size>(
                                  Size(size.width, 50),
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                List<Emotion> selectedEmotion =
                                    emotionListProvider.emotionList
                                        .where((element) => element.isSelected)
                                        .toList();
                                if (selectedEmotion.isEmpty) {
                                  setState(() {
                                    onPressedWhenNoEmotion = true;
                                  });
                                  return;
                                }
                                FormState? currentFormState =
                                    (_formKey as GlobalKey<FormState>)
                                        .currentState;
                                if (currentFormState == null) {
                                  return;
                                }
                                if (!currentFormState.validate()) {
                                  HapticFeedback.vibrate();
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                String userUid =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        "ERROR_USER";
                                await DiaryDatabase.init();

                                if (widget.isEditing) {
                                  editTargetIds.forEach((element) {
                                    DiaryDatabase.removeDiary(element);
                                  });
                                }
                                String joinedImagePath = "";
                                String joinedImageDepth = "";
                                if (selectedImagesPaths.isNotEmpty) {
                                  joinedImagePath = selectedImagesPaths
                                      .map((e) => e)
                                      .toList()
                                      .reduce((value, element) =>
                                          value + "," + element);
                                }
                                if (selectedImagesDepths.isNotEmpty) {
                                  joinedImageDepth = selectedImagesDepths
                                      .map((e) => e)
                                      .toList()
                                      .reduce((value, element) =>
                                          value + "," + element);
                                }

                                DatabaseReference databaseReference =
                                    FirebaseDatabase.instance
                                        .ref("diaries/${userUid}");
                                await databaseReference.set({
                                  "lastDiaryWroteAt": DateTime.now().toString()
                                });
                                for (Emotion emo in selectedEmotion) {
                                  emo.imageOnlinePath = joinedImagePath;
                                  if (emo.lastFeelTime == "") {
                                    emo.lastFeelTime = DateTime.now()
                                        .toLocal()
                                        .toString()
                                        .substring(11, 19);
                                  }
                                  if (emo.id == 0) {
                                    emo.id = DateTime.now()
                                            .toLocal()
                                            .microsecond *
                                        DateTime.now().toLocal().day *
                                        DateTime.now().toLocal().millisecond;
                                  }

                                  emo.imageOnlineStorageDepth =
                                      joinedImageDepth;
                                  emo.userUid = userUid;
                                  DiaryDatabase.insertDiary(emo);
                                }
                                // }
                                await uploadToServer(
                                    imageOnlinePaths: selectedImagesPaths);
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                    alreadyWrote = true;
                                  });
                                }
                                if (widget.isEditing) {
                                  Navigator.of(context).pop();
                                  stateProvider.showDetailPage(false);
                                  selectedImagesPaths.clear();
                                  selectedImagesDepths.clear();
                                } else {
                                  stateProvider.notifyListenerManually();
                                  stateProvider.showCompletePage(true);
                                  selectedImagesPaths.clear();
                                  selectedImagesDepths.clear();
                                }
                              },
                              child: Text("완료"),
                            ),
                          ],
                          body: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.isEditing)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 50),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                  IgnorePointer(
                                    ignoring: widget.isEditing,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "감정 선택",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        if (widget.isEditing)
                                          Text("*수정 모드에선 감정을 바꿀 수 없습니다.",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            for (int i = 0; i < 3; i++)
                                              Row(
                                                children: [
                                                  EmotionChip(
                                                      emotion:
                                                          emotionListProvider
                                                              .emotionList[i],
                                                      emoji: emotionListProvider
                                                          .emotionList[i].emoji)
                                                    ..emotionListForEdit =
                                                        widget.emotionsForEdit,
                                                  SizedBox(width: 10),
                                                ],
                                              )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            for (int i = 3; i < 6; i++)
                                              Row(
                                                children: [
                                                  EmotionChip(
                                                      emotion:
                                                          emotionListProvider
                                                              .emotionList[i],
                                                      emoji: emotionListProvider
                                                          .emotionList[i].emoji)
                                                    ..emotionListForEdit =
                                                        widget.emotionsForEdit,
                                                  SizedBox(width: 10),
                                                ],
                                              )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            for (int i = 6; i < 9; i++)
                                              Row(
                                                children: [
                                                  EmotionChip(
                                                      emotion:
                                                          emotionListProvider
                                                              .emotionList[i],
                                                      emoji: emotionListProvider
                                                          .emotionList[i].emoji)
                                                    ..emotionListForEdit =
                                                        widget.emotionsForEdit,
                                                  SizedBox(width: 10),
                                                ],
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    "이미지 선택",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.image,
                                          );

                                          if (result != null) {
                                            List<File> files = result.paths
                                                .map((path) => File(path!))
                                                .toList();

                                            setState(() {
                                              isLoading = true;
                                            });
                                            List<Map<int, File>> imageFiles =
                                                [];
                                            files.forEach((f) {
                                              imageFiles.add({
                                                emotionListProvider
                                                    .emotionList.first.id: f
                                              });
                                            });
                                            String userUid = FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.uid ??
                                                "ERROR_USER";
                                            final storageRef =
                                                FirebaseStorage.instance.ref();
                                            return await Future.forEach(
                                                imageFiles, (element) async {
                                              element as Map<int, File>;

                                              if (File(
                                                      element.values.first.path)
                                                  .existsSync()) {
                                                final ref = storageRef.child(
                                                    "${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");

                                                final task = ref.putFile(
                                                    element.values.first);
                                                task.onError(
                                                    (error, stackTrace) {
                                                  setState(() {
                                                    isLoading = false;
                                                    failLottieController
                                                        .forward();
                                                    isError = true;
                                                  });
                                                  return task;
                                                });
                                                task.then((p) async {
                                                  String url = await ref
                                                      .getDownloadURL();

                                                  selectedImagesPaths.add(url);
                                                  selectedImagesDepths.add(
                                                      "${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");
                                                  log("photo: ${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                              } else {
                                                log("not exist file ${element.values.first.path}");
                                              }
                                            });
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                        child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child:
                                                Icon(Icons.photo_camera_back)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? image =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.camera);

                                          List<Map<int, File>> imageFiles = [];

                                          imageFiles.add({
                                            emotionListProvider.emotionList
                                                .first.id: File(image!.path)
                                          });
                                          setState(() {
                                            isLoading = true;
                                          });
                                          String userUid = FirebaseAuth
                                                  .instance.currentUser?.uid ??
                                              "ERROR_USER";
                                          final storageRef =
                                              FirebaseStorage.instance.ref();
                                          return await Future.forEach(
                                              imageFiles, (element) async {
                                            element as Map<int, File>;

                                            if (File(element.values.first.path)
                                                .existsSync()) {
                                              final ref = storageRef.child(
                                                  "${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");

                                              final task = ref.putFile(
                                                  element.values.first);
                                              task.onError((error, stackTrace) {
                                                setState(() {
                                                  isLoading = false;
                                                  failLottieController
                                                      .forward();
                                                  isError = true;
                                                });
                                                return task;
                                              });
                                              task.then((p) async {
                                                String url =
                                                    await ref.getDownloadURL();

                                                selectedImagesPaths.add(url);
                                                selectedImagesDepths.add(
                                                    "${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");
                                                log("photo: ${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            } else {
                                              log("not exist file ${element.values.first.path}");
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.photo_camera),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height:
                                        selectedImagesPaths.isEmpty ? 0 : 120,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (int i = 0;
                                            i < selectedImagesPaths.length;
                                            i++)
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      color: Colors.grey,
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Image.network(
                                                      selectedImagesPaths[i],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    top: -10,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        String userUid =
                                                            FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid ??
                                                                "ERROR_USER";
                                                        final storageRef =
                                                            FirebaseStorage
                                                                .instance
                                                                .ref();
                                                        log("delete : ${selectedImagesDepths[i]}");
                                                        storageRef
                                                            .child(
                                                                selectedImagesDepths[
                                                                    i])
                                                            .delete();
                                                        selectedImagesPaths
                                                            .removeAt(i);
                                                        selectedImagesDepths
                                                            .removeAt(i);
                                                        setState(() {});
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    "일기 쓰기",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  if (emotionListProvider.emotionList
                                          .where(
                                              (element) => element.isSelected)
                                          .toList()
                                          .isEmpty &&
                                      widget.emotionsForEdit.isEmpty)
                                    Text(
                                      "감정을 선택 해주세요",
                                      style: TextStyle(
                                          color: onPressedWhenNoEmotion
                                              ? Colors.red
                                              : Colors.grey),
                                    ),
                                  Builder(builder: (context) {
                                    List<Emotion> selectedEmotion =
                                        emotionListProvider.emotionList
                                            .where(
                                                (element) => element.isSelected)
                                            .toList();

                                    return Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < selectedEmotion.length;
                                              i++)
                                            Column(
                                              children: [
                                                TextFormField(
                                                  validator: (text) {
                                                    if (text == null ||
                                                        text.isEmpty) {
                                                      return "일기가 입력되지 않았습니다.";
                                                    }
                                                    if (text.length < 5) {
                                                      return "일기가 너무 짧습니다. 5글자 이상 입력해주세요.";
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (text) {
                                                    selectedEmotion[i].content =
                                                        text;
                                                  },
                                                  controller: widget
                                                          .emotionsForEdit
                                                          .isEmpty
                                                      ? null
                                                      : textControllersForEdit
                                                                      .length -
                                                                  1 <
                                                              i
                                                          ? TextEditingController(
                                                              text:
                                                                  selectedEmotion[
                                                                          i]
                                                                      .content)
                                                          : textControllersForEdit[
                                                              i],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        selectedEmotion[i]
                                                            .inKor,
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    border: _border,
                                                    focusedBorder: _border,
                                                    enabledBorder: _border,
                                                    errorBorder: _errorBorder,
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: bottomNavBarColor,
                        ),
                      ),
                      if (isLoading)
                        Center(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Lottie.asset(
                                  "assets/lotties/loading_lottie.json")),
                        ),
                      if (isError)
                        Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            color: Colors.black.withOpacity(0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Lottie.asset(
                                    "assets/lotties/fail.json",
                                    controller: failLottieController,
                                    repeat: false,
                                  ),
                                ),
                                Text(
                                  "업로드 실패",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                );
              });
  }

  Future<List<Emotion>?> fetchDiariesFromDB() async {
    return await DiaryDatabase.readDiaries();
  }

  Future<void> uploadToServer({required List<String> imageOnlinePaths}) async {
    List<Emotion>? diaries = await fetchDiariesFromDB();
    if (diaries == null) {
      return;
    }

    String userUid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
    //텍스트 우선 업로드
    await Future.forEach(diaries, (diary) async {
      diary as Emotion;
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("diaries/${userUid}/${diary.id}");

      if (widget.isEditing) {
        await Future.forEach(editTargetIds, (element) async {
          element as int;
          log("remove at ${element}");
          await FirebaseDatabase.instance
              .ref("diaries/${userUid}/${element}")
              .remove();
        });
      }
      await databaseReference.set({
        "user": userUid,
        "content": diary.content,
        "lastFeelTime": diary.lastFeelTime,
        "lastFeelDate": diary.lastFeelDate,
        "inKor": diary.inKor,
        "isPositiveEmotion": diary.isPositiveEmotion,
        "id": diary.id,
        "emoji": diary.emoji,
        "imageOnlinePath": diary.imageOnlinePath,
        "imageOnlineStorageDepth": diary.imageOnlineStorageDepth,
        "deviceImagePath": diary.imagePath,
      });
    });
  }
}
