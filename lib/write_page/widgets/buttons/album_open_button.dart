import 'dart:io';

import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AlbumOpenButton extends StatefulWidget {
  bool isEditing = false;
  List<Emotion> emotionListForEdit = [];
  @override
  State<AlbumOpenButton> createState() => _AlbumOpenButtonState();
}

class _AlbumOpenButtonState extends State<AlbumOpenButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      List selectedEmotions = emotionListProvider.getSelectedEmotions();
      return ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(165, 20),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
        ),
        onPressed: () async {
          if (Platform.isMacOS) {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.image);

            if (widget.isEditing && widget.emotionListForEdit.isNotEmpty) {
              for (Emotion emo in widget.emotionListForEdit) {
                emo.imagePath = result?.files.first.path ?? "";
                emotionListProvider.notifyListenerManually();
              }
            } else {
              for (Emotion emo in selectedEmotions) {
                emo.imagePath = result?.files.first.path ?? "";
                print(result?.files.first.path ?? "NO FILE");
                emotionListProvider.notifyListenerManually();
              }
            }
          } else {
            ImagePicker imagePicker = ImagePicker();
            XFile? image =
                await imagePicker.pickImage(source: ImageSource.gallery);

            if (widget.isEditing && widget.emotionListForEdit.isNotEmpty) {
              for (Emotion emo in widget.emotionListForEdit) {
                emo.imagePath = image?.path ?? "";
                emotionListProvider.notifyListenerManually();
              }
            } else {
              for (Emotion emo in selectedEmotions) {
                emo.imagePath = image?.path ?? "";
                emotionListProvider.notifyListenerManually();
              }
            }
          }
        },
        child: const Text(
          "앨범에서",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
