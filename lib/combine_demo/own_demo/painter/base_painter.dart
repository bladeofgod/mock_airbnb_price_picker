/*
* Author : LiJiqqi
* Date : 2020/3/12
*/



import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';

class BasePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  /// 计算Y轴的 最大和最小值
  List<double> calculateMaxMin(List<ChartBean> chartBeans){
    if(chartBeans == null || chartBeans.length == 0) return [0,0];
    double max = 0.0,min = 0.0;
    for(ChartBean bean in chartBeans){
      if(max < bean.y){
        max = bean.y;
      }
      if(min > bean.y){
        min = bean.y;
      }
    }
    return [max,min];
  }

}


















