




import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/price_slider/price_slier_widget.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/line_data_provider.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/fill_formatter/i_fill_formatter.dart';

import '../../../fake_data.dart';

class PriceSliderMP extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return PriceSliderMPState();
  }

}

class PriceSliderMPState extends State<PriceSliderMP> {

  var random = Random(1);
  int _count = 45;
  double _range = 100.0;


  //默认左右截取位置
  double leftValue =0,
      rightValue = 1;

  List<Entry> _originList = List();
  List<Entry> values = List();
  LineChartController controller;

  @override
  void initState() {
    _initController();
    initData();
    _initLineData(values);
    super.initState();
  }

  initData(){
    for (int i = 0; i < _count; i++) {
      double val = (random.nextDouble() * (_range + 1)) + 20;
      values.add(Entry(x: i.toDouble(), y: val, icon: null));
    }

    _originList.addAll(values);
  }

  void _initLineData(List<Entry> values) async {

    LineDataSet set1;
    // create a dataset and give it a type
    set1 = LineDataSet(values, "DataSet 1");

    set1.setMode(Mode.CUBIC_BEZIER);
    set1.setCubicIntensity(0.2);
    set1.setDrawFilled(true);
    set1.setDrawCircles(false);
    set1.setLineWidth(1.8);
    set1.setCircleRadius(4);
    set1.setDrawValues(false);//点击图表 不显示value
    //set1.setCircleColor(Colors.red);//折线上的圆点颜色
    set1.setHighLightColor(Colors.yellowAccent);
    set1.setColor1(Colors.red);//曲线颜色
    set1.setFillColor(Colors.grey);//填充颜色
    //set1.setFillAlpha(100);
    set1.setDrawHorizontalHighlightIndicator(false);
    set1.setFillFormatter(A());

    // create a data object with the data sets
    controller.data = LineData.fromList(List()..add(set1))
      ..setValueTypeface(TypeFace())
      ..setValueTextSize(9)
      ..setDrawValues(false);

    setState(() {});
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.enabled = (false);
//          axisLeft
//            ..typeface = Util.LIGHT
//            ..setLabelCount2(6, false)
//            ..textColor = (ColorUtils.WHITE)
//            ..position = (YAxisLabelPosition.INSIDE_CHART)
//            ..drawGridLines = (false)
//            ..axisLineColor = (ColorUtils.WHITE);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
          legend.enabled = (false);
          var data = (controller as LineChartController).data;
          if (data != null) {
            var formatter = data.getDataSetByIndex(0).getFillFormatter();
            if (formatter is A) {
              formatter.setPainter(controller);
            }
          }
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis.enabled = (false);
        },
        drawGridBackground: true,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        gridBackColor: Color.fromARGB(255, 104, 241, 175),
        backgroundColor: Colors.white,
        description: desc);
  }


  @override
  Widget build(BuildContext context) {

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

            buildLineChart(),

          ],
        ),
      ),
    );
  }


  Widget buildLineChart(){

  }

}


class A implements IFillFormatter {
  LineChartController _controller;

  void setPainter(LineChartController controller) {
    _controller = controller;
  }

  @override
  double getFillLinePosition(
      ILineDataSet dataSet, LineDataProvider dataProvider) {
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}






















