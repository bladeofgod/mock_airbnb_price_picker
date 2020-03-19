/*
* Author : LiJiqqi
* Date : 2020/3/18
*/


import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';

import 'price_slider_mp.dart';

class BottomLineChart extends StatelessWidget{

  List<Entry> values;
  LineChartController controller;

  BottomLineChart(List<Entry> values){
    this.values = values;
    controller = LineChartController();
    _initController();
    _initLineData(this.values);
  }



  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.enabled = false;
          //axisLeft.setLabelCount2(6, false);
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

    //setState(() {});
  }

  Widget buildLineChart(){
    var lineChart = LineChart(controller);
    controller.autoScaleMinMaxEnabled = false;
//    controller.animator
//      ..reset()
//      ..animateXY1(2000, 2000);
    return lineChart;

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildLineChart();
  }

}