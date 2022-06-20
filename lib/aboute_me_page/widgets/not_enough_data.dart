import 'package:flutter/material.dart';

class NotEnoughData extends StatelessWidget {
  const NotEnoughData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/statistic.png"),
          const SizedBox(height: 10),
          Text(
            "일기가 아직 모이지 않았어요",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "통계/분석을 위해선 일기를 조금 더 써주세요",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
