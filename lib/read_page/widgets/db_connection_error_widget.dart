import 'package:flutter/material.dart';

class DBConnectionErrorWidget extends StatelessWidget {
  const DBConnectionErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/error.png"),
          const SizedBox(height: 10),
          Text(
            "데이터베이스 연결에 실패 했습니다.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
