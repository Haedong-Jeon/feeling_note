import 'package:feeling_note/constants/emotion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DiaryDatabase {
  static Database? database;
  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "diary_database.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE diaries(id INTEGER PRIMARY KEY, content TEXT, lastFeelTime TEXT, lastFeelDate TEXT, imagePath TEXT, isPositiveEmotion INTEGER, isSelected INTEGER, inKor TEXT, emoji TEXT, imageOnlinePath TEXT, userUid TEXT, imageOnlineStorageDepth TEXT)",
        );
      },
      version: 1,
    );
  }

  static void insertDiary(Emotion emotion) async {
    if (database == null) return;
    await database!.insert(
      "diaries",
      emotion.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void clearDiary() async {
    if (database == null) return;
    await database!.delete("diaries");
  }

  static void updateDiary(Emotion emotion) async {
    if (database == null) return;
    await database!.update(
      "diaries",
      emotion.toJson(),
      where: "lastFeelDate = ${emotion.lastFeelDate}",
    );
  }

  static Future<List<Emotion>?> readDiaries() async {
    if (database == null) return null;
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "ERROR_USER";
    List<Emotion> emotionList = [];
    final List<Map<String, dynamic>> maps = await database!.query("diaries");
    for (Map<String, dynamic> map in maps) {
      Emotion emo = Emotion.fromJson(map);
      if (emo.userUid == uid) {
        emotionList.add(emo);
      }
    }
    return emotionList;
  }

  static void removeDiary(int id) async {
    await database!.delete("diaries", where: "id = ?", whereArgs: [id]);
  }

  static void removeDiaryByDate(String date, String userUid) async {
    database!.delete(
      "diaries",
      where: "lastFeelDate = ?userUid = ?",
      whereArgs: [date, userUid],
    );
  }

  static Future<bool> isTodayDiaryWritten() async {
    try {
      List<Emotion>? diariesInDB = await DiaryDatabase.readDiaries();
      if (diariesInDB == null) return false;
      String today = DateTime.now()
          .toLocal()
          .toString()
          .replaceAll("-", ".")
          .substring(0, 10);
      diariesInDB.firstWhere((element) => element.lastFeelDate == today);
      return true;
    } catch (_) {
      return false;
    }
  }
}
