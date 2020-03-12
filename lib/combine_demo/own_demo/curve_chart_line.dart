/*
* Author : LiJiqqi
* Date : 2020/3/12
*/


import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/painter/curve_line_chart_painter.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';

class CurveChartLine extends StatefulWidget{

  final Size size; //图表宽高
  final double lineWidth; //线宽
  final bool isCurve; //标记是否为曲线
  final List<ChartBean> chartBeans;
  final List<Color> shaderColors; //Line渐变色
  final Color lineColor; //曲线或折线的颜色
  final Color xyColor; //xy轴的颜色
  final Color backgroundColor; //绘制的背景色
  final int yNum;

  CurveChartLine({this.size, this.lineWidth, this.isCurve, this.chartBeans,
    this.shaderColors, this.lineColor, this.xyColor, this.backgroundColor,
    this.yNum}); //y刻度文本的数量





  @override
  State<StatefulWidget> createState() {
    return CurveChartLineState();
  }

}

class CurveChartLineState extends State<CurveChartLine>
  with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    var painter = CurveLineChartPainter(
        chartBeans: widget.chartBeans,
        lineColor: widget.lineColor,
        shaderColors: widget.shaderColors,
        isCurve: widget.isCurve,
        lineWidth: widget.lineWidth,
        yNum: widget.yNum,);
    return CustomPaint(
      size: widget.size,
      painter: widget.backgroundColor == null ? painter : null,
      foregroundPainter: widget.backgroundColor != null ? painter : null,
      child: widget.backgroundColor != null
          ? Container(
        width: widget.size.width,
        height: widget.size.height,
        color: widget.backgroundColor,
      )
          : null,
    );
  }
}













