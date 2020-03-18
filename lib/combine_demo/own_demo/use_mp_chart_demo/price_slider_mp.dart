




import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/price_slider/price_slier_widget.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/use_mp_chart_demo/bottom_line_chart.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
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
  int _count = 75;
  double _range = 100.0;


  //默认左右截取位置
  double leftValue =0,
      rightValue = 1;


  List<Entry> values = List();
  List<Entry> bottomValues = List();
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
      bottomValues.add(Entry(x: i.toDouble(), y: val, icon: null));
    }


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
        gridBackColor: Color.fromARGB(0, 0, 0, 0),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        description: desc);
        controller.infoBgColor = Colors.transparent;
    //controller.painter.setGridBackgroundColor(Colors.transparent);

  }




  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Material(
      child: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width,
              height: 150,

              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[

                  //buildPriceSlider(),
                  Container(
                    height: 130,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: <Widget>[
                        BottomLineChart(bottomValues),
//                  Container(
//                    color: Colors.red,
//                  ),
                        buildLineChart(),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width,
                      child:
                      priceSlider(size),
                      //sliderWidget(),
                    ),
                  ),
//            Container(
//              height: 300,
//              child: buildLineChart(),
//            ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget priceSlider(Size size){
    List<ChartBean> list = [];
    values.forEach((v){
      list.add(ChartBean(x: "${v.x}",y: v.y));
    });
    return PriceSliderWidget(
      list:list ,
      rootWidth: size.width-40,
      rootHeight: 300,
      leftSlidListener: (isDragging,leftIndex){
        ///left
        //leftValue = leftIndex/ FakeData.listLong.length;
        print("left index : $leftIndex ___ ratio : $leftValue");
        rangeStart = leftIndex / 1;
        resetChartValues(rangeStart, rangeEnd);

//        setState(() {
//
//        });
      },
      rightSlidListener: (isDragging,rightIndex){
        ///right
        //rightValue = (FakeData.listLong.length - rightIndex) / FakeData.listLong.length;
        print("right index : $rightIndex ___ ratio : $rightValue");
        rangeEnd = (74-rightIndex)/1;
        resetChartValues(rangeStart, rangeEnd);

//        setState(() {
//
//        });
      },
    );
  }

  double rangeStart = 0,rangeEnd = 74;

  Widget sliderWidget(){
    return RangeSlider(

      values: RangeValues(rangeStart, rangeEnd),
      min: 0,
      max: 74,
      divisions: 74,
      onChanged: (values){
        if(values.start == values.end)return;
        print("${values.start}   ___  ${values.end} ");
        resetChartValues(values.start,values.end);
      },
    );
  }


  resetChartValues(double start,double end){
    print("start ${start} ,  end ${end}");
    rangeStart = start;
    rangeEnd = end;

    for(int i=0;i<values.length;i++){

      if(i>start && i < end){
        values[i].y = bottomValues[i].y;
      }else{
        values[i].y = 0;
      }

    }


    setState(() {


    });
  }



  Widget buildPriceSlider(){
    return buildLineChart();
  }


  Widget buildLineChart(){
    var lineChart = LineChart(controller);

    controller.autoScaleMinMaxEnabled = false;
    controller.infoBgColor = Colors.transparent;
    //controller.backgroundColor = Colors.yellowAccent;
//    controller.animator
//      ..reset()
//      ..animateXY1(2000, 2000);
    return lineChart;

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
    _controller.painter.setGridBackgroundColor(Colors.transparent);
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}






















