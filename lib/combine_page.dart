/*
* Author : LiJiqqi
* Date : 2020/3/13
*/


import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/price_slider/price_slier_widget.dart';
import 'package:flutter_slider_demo/fake_data.dart';

import 'combine_demo/own_demo/airbnb_price_picker.dart';
import 'combine_demo/own_demo/curve_chart_line.dart';
import 'combine_demo/view/chart_bean.dart';

class CombinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return CombinePageState();
  }

}

class CombinePageState extends State<CombinePage> {

//  var dataList = [
//    ChartBean(x: "\$2000", y: 32),
//    ChartBean(x: "\$1100", y: 48),
//    ChartBean(x: "\$1400", y: 32),
//    ChartBean(x: "\$500", y: 24),
//    ChartBean(x: "\$800", y: 50),
//    ChartBean(x: "\$1800", y: 25),
//    ChartBean(x: "\$1200", y: 18),
//    ChartBean(x: "\$2000", y: 32),
//    ChartBean(x: "\$1100", y: 48),
//    ChartBean(x: "\$1400", y: 32),
//  ];

  //默认左右截取位置
  double leftValue =0,
          rightValue = 1;

  @override
  Widget build(BuildContext context) {
    //dataList = FakeData.listLong;
    return Material(
      child: Container(
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            PriceSliderWidget(
              list:FakeData.listLong ,
              rootHeight: 300,
              leftSlidListener: (isDragging,leftIndex){
                ///left
                leftValue = leftIndex/ FakeData.listLong.length;
                print("left index : $leftIndex ___ ratio : $leftValue");
                setState(() {

                });
              },
              rightSlidListener: (isDragging,rightIndex){
                ///right
                rightValue = (FakeData.listLong.length - rightIndex) / FakeData.listLong.length;
                print("right index : $rightIndex ___ ratio : $rightValue");
                setState(() {

                });
              },
            ),
            ///曲线图
            buildCurveChart(),
          ],
        ),
      ),
    );
  }

  Widget buildCurveChart(){
    var curveChartLine = CurveChartLine(
      //金额500-2000
      //房屋数量10-50
      chartBeans: FakeData.listLong,
      //整个图表的宽高。
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: true,
      yNum: 11,//y轴刻度尺值 暂时无用
      lineWidth: 4,
      lineColor: Colors.blueAccent,
      shaderColors: [
        Colors.orange.withOpacity(0.8),
        Colors.orangeAccent.withOpacity(0.5)
      ],
      leftValue: leftValue,
      rightValue: rightValue,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: curveChartLine,
    );
  }


}





















