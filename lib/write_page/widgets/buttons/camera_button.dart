import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CameraButton extends StatefulWidget {
  bool isEditing = false;
  List<Emotion> emotionListForEdit = [];
  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
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
          backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
        ),
        onPressed: () async {
          ImagePicker imagePicker = ImagePicker();
          XFile? image =
              await imagePicker.pickImage(source: ImageSource.camera);

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
        },
        child: const Text(
          "카메라",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
