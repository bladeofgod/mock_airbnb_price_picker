import 'package:flutter/material.dart';

class ChartBean {
  String x; //x轴
  double y; //y轴
  int millisSeconds;
  Color color;

  ChartBean(
      {@required this.x, @required this.y, this.millisSeconds, this.color});
}
