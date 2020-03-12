/*
* Author : LiJiqqi
* Date : 2020/3/11
*/


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'combine_demo/view/chart_bean.dart';
import 'combine_demo/view/chart_line.dart';

class ChartExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return ChartExampleState();
  }

}

class ChartExampleState extends State<ChartExample> {
  @override
  Widget build(BuildContext context) {

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildChartCurve(context),
        ],
      ),
    );
  }


  ///curve
  Widget _buildChartCurve(context) {
    //chart bean 每个数据块
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      //整个图表的宽高。
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: true,
      lineWidth: 4,
      lineColor: Colors.blueAccent,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.blueAccent.withOpacity(0.3),
        Colors.blueAccent.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.green.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

}























