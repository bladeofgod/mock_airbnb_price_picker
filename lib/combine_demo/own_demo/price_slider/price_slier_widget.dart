/*
* Author : LiJiqqi
* Date : 2020/3/12
*/





import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';

class PriceSliderWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return PriceSliderWidgetState();
  }

}

class PriceSliderWidgetState extends State<PriceSliderWidget> {

  final List<ChartBean> list = [
    ChartBean(x: "\$2000", y: 32),
    ChartBean(x: "\$1100", y: 48),
    ChartBean(x: "\$1400", y: 32),
    ChartBean(x: "\$500", y: 24),
    ChartBean(x: "\$800", y: 50),
    ChartBean(x: "\$1800", y: 25),
    ChartBean(x: "\$1200", y: 18),
    ChartBean(x: "\$2000", y: 32),
    ChartBean(x: "\$1100", y: 48),
    ChartBean(x: "\$1400", y: 32),
  ];

  int segmentPart;

  String _leftPrice = '0';
  String _rightPrice = '不限';


  double _leftImageMargin = 20;
  double _rightImageMargin = 20;
  double _leftBlackLineW = 0; // 左边黑线的宽度
  double _rightBlackLineW = 0; // 右边黑线的宽度

  int _leftImageCurrentIndex = 0; // 左边选中的价格索引
  int _rightImageCurrentIndex = 0; // 右边选中的价格索引

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //分割多少块
    segmentPart = list.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _priceRangeBlock(),
            SizedBox(height: 10,),
            _priceBlock(_leftPrice, _rightPrice),
            SizedBox(height: 10,),
            /// x轴 +  左右滑块
            Stack(
              children: <Widget>[
                _lineBlock(context, screenWidth),
                _leftImageBlock(context, screenWidth),
                _rightImageBlock(context, screenWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 滑块的image
  _imageItem(){
    return Icon(Icons.settings_applications,color: Colors.red,size: 30,);
//    return Image.asset(
//      'assets/images/house_price_sliding.png',
//      width: 30,
//      height: 30,
//    );
  }

  /*
      * 左边image滑块，使用到：_imageItem
      * */
  _leftImageBlock(BuildContext context, double screenWidth) {
    //减掉左右边界20 *2
    double singleW = (screenWidth-40)/segmentPart;
    return Positioned(
        left: _leftImageMargin,
        top: 0,
        child: GestureDetector(
          child: _imageItem(),
          //水平方向移动
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            print('拖拽中');
            if(_leftImageMargin < 20) {//处理左边边界
              _leftImageMargin = 20;
              _leftBlackLineW = 2;
            } else if (((screenWidth-(_rightImageMargin+30))-(_leftImageMargin+30))<(singleW-45)) {
              // 处理两球相遇情况
              _leftImageMargin = screenWidth-(_rightImageMargin+singleW+15);
              _leftBlackLineW = _leftImageMargin-20;
            } else {
              _leftImageMargin += details.delta.dx;
              _leftBlackLineW = _leftImageMargin-20 >= 0 ? _leftImageMargin-20 : 2;
            }
            setState(() {});// 刷新UI
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            double singleW = (screenWidth-40)/segmentPart;
            double _leftImageMarginFlag = _leftImageMargin;
            print('拖拽结束');
            for(int i = 0; i< list.length;i++){
              if(_leftImageMarginFlag < singleW * (0.5 + i)){
                if(i == 0){
                  _leftImageMargin = 20;

                }else{
                  _leftImageMargin = singleW * i + 5;

                }
                _leftPrice = list[i].x;
                _leftImageCurrentIndex = i;
                break;
              }
            }
//            if(_leftImageMarginFlag <singleW/2) {
//              _leftImageMargin = 20;
//              _leftBlackLineW = 2;
//              _leftImageCurrentIndex = 0;
//              _leftPrice = '¥0';
//            } else if (_leftImageMarginFlag <singleW*1.5) {
//              _leftImageMargin = singleW+5;
//              _leftBlackLineW = _leftImageMargin;
//              _leftImageCurrentIndex = 1;
//              _leftPrice = '¥200';
//            } else if (_leftImageMarginFlag < singleW*2.5) {
//              _leftImageMargin = singleW*2+5;
//              _leftBlackLineW = _leftImageMargin;
//              _leftImageCurrentIndex = 2;
//              _leftPrice = '¥300';
//            } else if (_leftImageMarginFlag < singleW*3.5) {
//              _leftImageMargin = singleW*3+5;
//              _leftBlackLineW = _leftImageMargin;
//              _leftImageCurrentIndex = 3;
//              _leftPrice = '¥400';
//            } else if (_leftImageMarginFlag < singleW*4.5) {
//              _leftImageMargin = singleW*4+5;
//              _leftBlackLineW = _leftImageMargin;
//              _leftImageCurrentIndex = 4;
//              _leftPrice = '¥500';
//            } else if (_leftImageMarginFlag < singleW*5.5) {
//              _leftImageMargin = singleW*5+5;
//              _leftBlackLineW = _leftImageMargin;
//              _leftImageCurrentIndex = 5;
//              _leftPrice = '¥600';
//            } else {
//
//            }
            print('选中第$_leftImageCurrentIndex个');
            setState(() {});// 刷新UI
          },
        )
    );
  }

  /*
      * 右边image滑块，使用到：_imageItem
      * */
  _rightImageBlock(BuildContext context, double screenWidth) {
    double singleW = (screenWidth-40)/segmentPart;
    return Positioned(
      right: _rightImageMargin,
      top: 0,
      child: GestureDetector(
        child: _imageItem(),
        //水平方向移动
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          print(_rightImageMargin);
          if(_rightImageMargin < 20) {//处理右边边界
            _rightImageMargin = 20;
            _rightBlackLineW = 2;
          } else if(((screenWidth-(_rightImageMargin+30))-(_leftImageMargin+30))<(singleW-45)) { // 处理两球相遇情况
            _rightImageMargin = screenWidth-(_leftImageMargin+15+singleW);
            _rightBlackLineW = _rightImageMargin-20;
          } else {
            _rightImageMargin -= details.delta.dx;
            _rightBlackLineW = _rightImageMargin-20 >= 0 ? _rightImageMargin-20 : 2;
          }
          setState(() {}); // 刷新UI
        },
        onHorizontalDragEnd: (DragEndDetails details){
          double singleW = (screenWidth-40)/segmentPart;
          double _rightImageMarginFlag = _rightImageMargin;
          print('拖拽结束');
          for(int i = 0; i< list.length;i++){
            if(_rightImageMarginFlag < singleW * (0.5 + i)){
              if(i == 0){
                _rightImageMargin = 20;

              }else{
                _rightImageMargin = singleW * i + 5;

              }
              _rightPrice = list[(list.length - 1) -i].x;
              _rightImageCurrentIndex = i;
              break;
            }
          }
//          if(_rightImageMarginFlag <singleW/2) {
//            _rightImageMargin = 20;
//            _rightBlackLineW = 2;
//            _rightImageCurrentIndex = 0;
//            _rightPrice = '不限';
//          } else if (_rightImageMarginFlag <singleW*1.5) {
//            _rightImageMargin = singleW+5;
//            _rightBlackLineW = _rightImageMargin;
//            _rightImageCurrentIndex = 1;
//            _rightPrice = '¥600';
//          } else if (_rightImageMarginFlag < singleW*2.5) {
//            _rightImageMargin = singleW*2+5;
//            _rightBlackLineW = _rightImageMargin;
//            _rightImageCurrentIndex = 2;
//            _rightPrice = '¥500';
//          } else if (_rightImageMarginFlag < singleW*3.5) {
//            _rightImageMargin = singleW*3+5;
//            _rightBlackLineW = _rightImageMargin;
//            _rightImageCurrentIndex = 3;
//            _rightPrice = '¥400';
//          } else if (_rightImageMarginFlag < singleW*4.5) {
//            _rightImageMargin = singleW*4+5;
//            _rightBlackLineW = _rightImageMargin;
//            _rightImageCurrentIndex = 4;
//            _rightPrice = '¥300';
//          } else if (_rightImageMarginFlag < singleW*5.5) {
//            _rightImageMargin = singleW*5+5;
//            _rightBlackLineW = _rightImageMargin;
//            _rightImageCurrentIndex = 5;
//            _rightPrice = '¥200';
//          }
          print('选中第$_rightImageCurrentIndex个');
          setState(() {});// 刷新UI
        },
      ),
    );
  }



  /*
      * 横线视图模块,包括黄色横线和黑色横线
      * */
  _lineBlock(BuildContext context, double screenWidth) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Stack(
          children: <Widget>[
            Container(// 黄色横线
              color: Colors.purple,
              height: 30,
              width: screenWidth - 40,
              alignment: Alignment.center,
              child: Container(
                color: Color.fromRGBO(254, 216, 54, 1),
                height: 4,
                width: screenWidth - 40,
              ),
            ),
            Positioned(// 左边黑色竖线
                left: 0,
                top: 13,
                child:Container(
                  height: 4,
                  width: _leftBlackLineW,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(left: BorderSide(color: Colors.black, width: 1), top: BorderSide(color: Colors.black, width: 1), bottom: BorderSide(color: Colors.black, width: 1))
                  ),
                )
            ),
            Positioned(// 右边黑色竖线
                right: 0,
                top: 13,
                child:Container(
                  height: 4,
                  width: _rightBlackLineW,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(right: BorderSide(color: Colors.black, width: 1), top: BorderSide(color: Colors.black, width: 1), bottom: BorderSide(color: Colors.black, width: 1))
                  ),
                )
            ),
          ],
        ),
      ],
    );
  }

  /*
      * title模块
      * */
  _priceRangeBlock() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Text(
          '价格范围',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(33, 33, 33, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  /*
      * 价格区间
      * leftPrice：选中的起始价格
      * rightPrice： 选中的最大价格
      * */
  _priceBlock(String leftPrice, String rightPrice) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Text(
          '$leftPrice-$rightPrice',
          style: TextStyle(
            fontSize: 12,
            color: Color.fromRGBO(117, 117, 117, 1),
          ),
        ),
      ],
    );
  }


}

























