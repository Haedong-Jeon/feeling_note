import 'package:feeling_note/constants/colors.dart';
import 'package:flutter/material.dart';

class AlreadyWrittenPage extends StatefulWidget {
  const AlreadyWrittenPage({Key? key}) : super(key: key);

  @override
  State<AlreadyWrittenPage> createState() => _AlreadyWrittenPageState();
}

class _AlreadyWrittenPageState extends State<AlreadyWrittenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bottomNavBarColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/thumbs_up.png"),
            const SizedBox(height: 10),
            Text(
              "오늘은 일기를 이미 작성 하셨습니다",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "일기는 하루에 한번만 쓸 수 있어요",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
