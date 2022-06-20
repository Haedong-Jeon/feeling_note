import 'package:flutter/material.dart';

class EmptyDiariesWidget extends StatelessWidget {
  bool isRangeSearch;
  EmptyDiariesWidget({
    Key? key,
    this.isRangeSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/sorry.png"),
          const SizedBox(height: 10),
          Text(
            isRangeSearch ? "해당 기간에 작성 된 일기가 없습니다." : "저장된 일기가 없습니다.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
