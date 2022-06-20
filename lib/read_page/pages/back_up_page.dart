import 'dart:io';
import 'dart:ui';

import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/datas/read_page_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class BackUpPage extends StatefulWidget {
  static const ValueKey valueKey = ValueKey("backup_page");

  ReadPageStateChangeNotifier? readProvider;
  @override
  State<BackUpPage> createState() => _BackUpPageState();
}

class _BackUpPageState extends State<BackUpPage> {
  bool isUploadFinished = false;
  String fileName = "";
  double progress = 0.0;
  List<String> doneCount = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Emotion>?> fetchDiariesFromDB() async {
    return await DiaryDatabase.readDiaries();
  }

  @override
  void didChangeDependencies() {
    uploadToServer();
    super.didChangeDependencies();
  }

  Future<void> uploadToServer() async {
    List<Emotion>? diaries = await fetchDiariesFromDB();
    if (diaries == null) {
      return;
    }

    List<Emotion> setedDiaries = [];
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
    diaries.forEach((d) {
      if (setedDiaries
              .any((element) => element.lastFeelDate != d.lastFeelDate) ||
          setedDiaries.isEmpty) {
        setedDiaries.add(d);
      }
    });

    List<Map<int, File>> imageFiles = [];
    final storageRef = FirebaseStorage.instance.ref();

    //텍스트 우선 업로드
    await Future.forEach(diaries, (diary) async {
      diary as Emotion;
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("diaries/${userUid}/${diary.id}");
      await databaseReference.set({
        "user": userUid,
        "content": diary.content,
        "lastFeelTime": diary.lastFeelTime,
        "lastFeelDate": diary.lastFeelDate,
        "inKor": diary.inKor,
        "isPositiveEmotion": diary.isPositiveEmotion,
        "id": userUid + diary.id.toString(),
        "emoji": diary.emoji,
        "deviceImagePath": diary.imagePath,
      });
    });
    await Future.forEach(setedDiaries, (diary) async {
      diary as Emotion;
      if (diary.imagePath == "") {
        //첨부된 이미지가 없다면 패스
      } else {
        // imageFiles.addAll(diary.imagePath.split(",").map((path) {
        //   return File(path);
        // }).toList());
        diary.imagePath.split(",").forEach((element) {
          File file = File(element);
          int id = diary.id;
          Map<int, File> map = {id: file};
          imageFiles.add(map);
        });
      }
    });
    if (imageFiles.isEmpty) {
      setState(() {
        progress = 1;
      });
    }
    //이미지 파일이 없다면 업로드 종료
    if (imageFiles.isEmpty) {
      widget.readProvider?.setIsServerUpload = false;
      return;
    }

    return await Future.forEach(imageFiles, (element) {
      element as Map<int, File>;
      String name = element.values.first.path.split("/").last;

      final ref = storageRef.child(
          "${userUid}/${element.keys.first}/${element.values.first.path.split('/').last}");
      final task = ref.putFile(element.values.first);
      task.then((p) {
        doneCount.add("/${element.keys.first}/_DONE");
        if (doneCount.length >= imageFiles.length) {
          widget.readProvider?.setIsServerUpload = false;
          return;
        }
      });
      task.snapshotEvents.listen((event) {
        setState(() {
          progress = event.bytesTransferred / event.totalBytes;
          fileName = "첨부 파일: " + name;
          print("$name 전송: " +
              (progress * 100).toStringAsFixed(2) +
              "%" +
              "(transfered byte: ${event.bytesTransferred}, totalbytes: ${event.totalBytes})");
        });
      });
    });

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      // WidgetsBinding.instance!.addPostFrameCallback((_) {
      //   readProvider = ref.watch(readPageStateProvider);
      //   uploadToServer(readProvider);
      // });
      return Container(
        width: 200,
        child: Column(
          mainAxisAlignment: isUploadFinished
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (!isUploadFinished)
              Column(
                children: [
                  Lottie.asset("assets/lotties/server_upload_lottie.json"),
                  SizedBox(height: 10),
                  Builder(builder: (context) {
                    return SizedBox(
                      width: 330,
                      height: 10,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                        value: progress,
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                  Text(
                    fileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            if (isUploadFinished)
              Column(
                children: [
                  Lottie.asset("assets/lotties/success_lottie.json",
                      repeat: false),
                  SizedBox(height: 10),
                  Text(
                    "업로드 성공",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
          ],
        ),
      );
    });
  }
}
