import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/datas/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class WriteDoneButton extends StatefulWidget {
  GlobalKey imageKey;
  WriteDoneButton({required this.imageKey});
  @override
  State<WriteDoneButton> createState() => _WriteDoneButtonState();
}

class _WriteDoneButtonState extends State<WriteDoneButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var emotionListProvider = ref.watch(emotionListChangeNotifierProvider);
      return ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(200, 20),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
        ),
        onPressed: () {
          Scrollable.ensureVisible(
            widget.imageKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
        child: const Text(
          "다 썼어요!",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
