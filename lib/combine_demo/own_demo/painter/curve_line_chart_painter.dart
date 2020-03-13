/*
* Author : LiJiqqi
* Date : 2020/3/12
*/



import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/painter/base_painter.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';

class CurveLineChartPainter extends BasePainter{

  double leftValue, // 左侧控制值，可以控制其实绘制点
      rightValue; //右侧控制值，可以控制其实绘制点

  List<ChartBean> chartBeans; //数据块

  bool isCurve; //是否曲线绘制

  List<Color> shaderColors;//渐变色
  Color lineColor;//线的颜色

  //外部可以不留边，具体看情况
  static const double basePadding = 16; //默认边距（防止太靠近边缘而引发的显示或者滑动问题）

  List<double> maxMin = [0,0];  //Y轴 的最大和最小值

  //bool isCurve; //是否为曲线
  int yNum ; // Y轴刻度 默认是5个
  //bool isShowFloat;//是否显示小数
  double lineWidth;//线宽

  double startX,endX,startY,endY;//表的起始点和终点
  double _fixedHeight, _fixedWidth; //表的宽高

  Path path; // 线路径
  //key =  x点   y 等于offset(x,y)
  Map<double, Offset> _points = new Map();//数据 在 屏幕上的 位置

  CurveLineChartPainter({@required this.chartBeans,
    this.isCurve = true,this.shaderColors, this.lineColor,
    this.yNum, this.lineWidth,this.leftValue = 0.2,this.rightValue = 0.8});


  @override
  void paint(Canvas canvas, Size size) {
    init(size);
    drawLine(canvas,size);//绘制线
  }

  @override
  bool shouldRepaint(CurveLineChartPainter oldDelegate) {

    return oldDelegate.leftValue != leftValue || oldDelegate.rightValue != rightValue;
  }

  //x轴 path 长度
  var xPathLength ;

  //曲线路径
  var curvePathLength;

  //x轴和曲线路径长度比
  var ratio;

  initXPath(){
    Path xPath = new Path();
    xPath.moveTo(startX, startY);
    xPath.lineTo(endX, endY);

    var pm = xPath.computeMetrics();
    var list = pm.toList();
    xPathLength = list[0].length;

  }

  //绘制曲线或者折线
  drawLine(Canvas canvas,Size size){
    if (chartBeans == null || chartBeans.length == 0) return;

    initXPath();

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;


    if (maxMin[0] <= 0) return;
    var pathMetrics = path.computeMetrics(forceClosed: false);
    var list = pathMetrics.toList();
    curvePathLength = list[0].length;
    ratio = curvePathLength / xPathLength;
    print("list size : ${list.length}");
    print(" the ratio : $ratio");
    print("curvePathLength   :  $curvePathLength");
    print("xPathLength    : $xPathLength");
    //如果由 leftValue,rightValue 来控制表的绘制区间的话，需要进行对list的截取
    //抽取长度
    var length = list.length.toInt() -
                    (list.length.toInt() * leftValue) - (list.length.toInt() * (1-rightValue));
    //动画value,如果不用动画 直接取 list.length.toInt
    //var length = value * list.length.toInt();
    //var length = list.length.toInt();
    Path linePath = new Path();
    //填充颜色区域
    Path shadowPath = new Path();
    shadowPath.moveTo(endX * leftValue, startY);
    for (int i = 0; i < length; i++) {
      //开始抽取位置
      double startExtr = list[i].length * (leftValue );//左侧取值用ratio进行放大
      //结束抽取位置
      double endExtr = list[i].length * (rightValue);//右侧取值用ratio进行缩小
      var extractPath =
      list[i].extractPath(startExtr, endExtr , startWithMoveTo: true);
      linePath.addPath(extractPath, Offset(0, 0));
      shadowPath = extractPath;
    }

    ///画阴影,注意LinearGradient这里需要指定方向，默认为从左到右
    if (shaderColors != null) {
      var shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
          colors: shaderColors)
          .createShader(Rect.fromLTRB(startX, endY, startX, startY));

      ///从path的最后一个点连接起始点，形成一个闭环
      shadowPath
        ..lineTo(startX + (_fixedWidth * rightValue) , startY)
        ..lineTo((startX+ (endX * leftValue ) ), startY)
        ..close();

      canvas
        ..drawPath(
            shadowPath,
            new Paint()
              ..shader = shader
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    }

    ///先画阴影再画曲线，目的是防止阴影覆盖曲线
    canvas.drawPath(linePath, paint);

  }


  //初始化
  init(Size size){
    //initValue();
    initBorder(size);//初始化边界
    initPath(size); //初始化路径
  }

  List<Path> segmentPathList = List();

  initPath(Size size){
    if(path == null){
      if(chartBeans != null && chartBeans.length >0 && maxMin[0] > 0){
        path = Path();
        double preX,//前一个数据的 x 值
            preY,//前一个数据的 y 值
            currentX,
            currentY;
        int length = chartBeans.length;
        double W = _fixedWidth / (length - 1); //两个点之间的x方向距离
        //数值个数 这里是7
        for (int i = 0; i < length; i++) {
          if (i == 0) {
            var key = startX;//第一个数的x值
            // chartBeans[i].y / maxMin[0] 算出当前y值为最大的值得百分比， *  表高 得出具体的y值
            //用 startY - y值  可以得到最终在屏幕上的y值
            var value = (startY - chartBeans[i].y / maxMin[0] * _fixedHeight);
            //移动到对应数据的位置
            path.moveTo(key, value);
            //保存下来这个数据的位置
            _points[key] = Offset(key, value);
            continue;
          }
          //绘制完第一个点后，向右平移一个 宽度（w）
          currentX = startX + W * i;
          //前一个数据的 x 值
          preX = startX + W * (i - 1);
          //前一个数据的y值
          preY = (startY - chartBeans[i - 1].y / maxMin[0] * _fixedHeight);
          currentY = (startY - chartBeans[i].y / maxMin[0] * _fixedHeight);
          _points[currentX] = Offset(currentX, currentY);

          if (isCurve) {
            //绘制路径
            path.cubicTo((preX + currentX) / 2, preY, // control point 1
                (preX + currentX) / 2, currentY,      //  control point 2
                currentX, currentY);                  // target point
          } else {
            path.lineTo(currentX, currentY);
          }
        }
      }
    }
  }


  //计算图表边界
  initBorder(Size size){
    ///对于预留刻度尺，具体可以根据效果 缩减
//    startX = yNum > 0 ? basePadding * 2.5 : basePadding * 2; //预留出y轴刻度值所占的空间
//    endX = size.width - basePadding * 2;
//    startY = size.height - (basePadding * 2);  //预留出x轴刻度值所占的空间
//    endY = basePadding * 2;
  //不预留刻度尺
    startX = 0;
    endX = size.width;
    startY = size.height;
    endY = 0;
    _fixedHeight = startY - endY;
    _fixedWidth = endX - startX;
    maxMin = calculateMaxMin(chartBeans);

  }

  //initValue(){}










}






















