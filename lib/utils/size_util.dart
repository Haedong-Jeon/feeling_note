import 'package:flutter/material.dart';

class SizeUtil {
  static Size? size; //BuildContext 상실 대비, 이전 값 백업용 변수
  static Size getWidgetSizeByGlobalKey(GlobalKey key) {
    if (key.currentContext == null) return size ?? const Size(0, 0);
    size = (key.currentContext!.findRenderObject() as RenderBox).size;
    return size ?? const Size(0, 0);
  }
}
