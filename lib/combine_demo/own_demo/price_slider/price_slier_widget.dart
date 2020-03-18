/*
* Author : LiJiqqi
* Date : 2020/3/12
*/





import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/view/chart_bean.dart';



class PriceSliderWidget extends StatefulWidget{
  final List<ChartBean> list ;
  //拖拽时，出现的指示线
  final Color leftIndicatorLineColor ;
  final Color rightIndicatorLineColor ;

  //widget 宽和高
  final double rootWidth,
          rootHeight;

  //滑块监听 目前参数暂定为 : param1 : 是否滑动  param2 : 当前index
  final Function rightSlidListener,leftSlidListener;


  PriceSliderWidget({@required this.list,
    this.leftIndicatorLineColor = Colors.red,
    this.rightIndicatorLineColor = Colors.red,
    this.rootWidth,
    this.rootHeight = 300,
    this.rightSlidListener, this.leftSlidListener});

  @override
  State<StatefulWidget> createState() {

    return PriceSliderWidgetState();
  }

}

class PriceSliderWidgetState extends State<PriceSliderWidget> {



  int segmentPart;

  String _leftPrice = '0';
  String _rightPrice = '不限';


  double _leftImageMargin = 0;
  double _rightImageMargin = 0;
  double _leftBlackLineW = 0; // 左边黑线的宽度
  double _rightBlackLineW = 0; // 右边黑线的宽度

  int _leftImageCurrentIndex = 0; // 左边选中的价格索引
  int _rightImageCurrentIndex = 0; // 右边选中的价格索引

  //是否拖动中
  bool isLeftDragging = false;
  bool isRightDragging = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //分割多少块
    segmentPart = widget.list.length - 1;
    _leftPrice = widget.list[0].x;
    _rightPrice = widget.list.last.x;
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenWidth = widget.rootWidth;
    return Material(
      color: Colors.transparent,
      child: Container(
        height: widget.rootHeight,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //_priceRangeBlock(),
            //SizedBox(height: 10,),
            //_priceBlock(_leftPrice, _rightPrice),
            //SizedBox(height: 10,),
            /// x轴 +  左右滑块
            Container(
              height: widget.rootHeight,
              color: Colors.transparent,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    bottom: 15,
                    child: _lineBlock(context, screenWidth),
                  ),
                  _leftImageBlock(context, screenWidth),
                  _rightImageBlock(context, screenWidth),
                ],
              ),
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
    double singleW = (screenWidth)/segmentPart;
    return Positioned(
        left: _leftImageMargin,
        //top: 0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: isLeftDragging,
                  child: Text("$_leftPrice",style: TextStyle(fontSize: 12,color: Colors.black),),
                ),

                Container(
                  width: 4,
                  height: 100,
                  color: Colors.red,
                ),
                GestureDetector(
                  child: _imageItem(),
                  //水平方向移动
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    isLeftDragging = true;
                    print('拖拽中');
                    if(_leftImageMargin < 0) {//处理左边边界
                      _leftImageMargin = 0;
                      _leftBlackLineW = 2;
                    } else if (((screenWidth-(_rightImageMargin+30))-(_leftImageMargin+30))<(singleW-45)) {
                      // 处理两球相遇情况
                      _leftImageMargin = screenWidth-(_rightImageMargin+singleW+15);
                      _leftBlackLineW = _leftImageMargin-20;
                    } else {
                      _leftImageMargin += details.delta.dx;
                      _leftBlackLineW = _leftImageMargin-20 >= 0 ? _leftImageMargin-20 : 2;
                    }

                    double _leftImageMarginFlag = _leftImageMargin;
                    print('拖拽结束');
                    //刷新上方的 price indicator
                    for(int i = 0; i< widget.list.length;i++){
                      if(_leftImageMarginFlag < singleW * (0.5 + i)){
                        _leftPrice = widget.list[i].x;
                        _leftImageCurrentIndex = i;
                        break;
                      }
                    }
                    setState(() {});// 刷新UI
                    if(widget.leftSlidListener != null){
                      widget.leftSlidListener(true,_leftImageCurrentIndex);
                    }
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    isLeftDragging = false;
                    double singleW = (screenWidth-40)/segmentPart;
                    double _leftImageMarginFlag = _leftImageMargin;
                    print('拖拽结束');
                    for(int i = 0; i< widget.list.length;i++){
                      if(_leftImageMarginFlag < singleW * (0.5 + i)){
                        if(i == 0){
                          _leftImageMargin = 0;

                        }else{
                          _leftImageMargin = singleW * i + 5;

                        }
                        _leftPrice = widget.list[i].x;
                        _leftImageCurrentIndex = i;
                        break;
                      }
                    }

                    print('选中第$_leftImageCurrentIndex个');
                    setState(() {});// 刷新UI

                    if(widget.leftSlidListener != null){
                      widget.leftSlidListener(false,_leftImageCurrentIndex);
                    }
                  },
                ),

                Visibility(
                  visible:  ! isLeftDragging,
                  child: Text("$_leftPrice",style: TextStyle(fontSize: 12,color: Colors.black),),
                ),

              ],
            ),

          ],
        ),
    );
  }

  /*
      * 右边image滑块，使用到：_imageItem
      * */
  _rightImageBlock(BuildContext context, double screenWidth) {
    double singleW = (screenWidth)/segmentPart;
    return Positioned(
      right: _rightImageMargin,
      //top: 0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: isRightDragging,
                child: Text("$_rightPrice",style: TextStyle(fontSize: 12,color: Colors.black),),
              ),

              Container(
                width: 4,
                height: 100,
                color: Colors.red,
              ),
              GestureDetector(
                child: _imageItem(),
                //水平方向移动
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  isRightDragging = true;
                  print(_rightImageMargin);
                  if(_rightImageMargin < 0) {//处理右边边界
                    _rightImageMargin = 0;
                    _rightBlackLineW = 2;
                  } else if(((screenWidth-(_rightImageMargin+30))-(_leftImageMargin+30))<(singleW-45)) { // 处理两球相遇情况
                    _rightImageMargin = screenWidth-(_leftImageMargin+15+singleW);
                    _rightBlackLineW = _rightImageMargin-20;
                  } else {
                    _rightImageMargin -= details.delta.dx;
                    _rightBlackLineW = _rightImageMargin-20 >= 0 ? _rightImageMargin-20 : 2;
                  }
                  //double singleW = (screenWidth-40)/segmentPart;
                  double _rightImageMarginFlag = _rightImageMargin;
                  print('拖拽结束');
                  for(int i = 0; i< widget.list.length;i++){
                    if(_rightImageMarginFlag < singleW * (0.5 + i)){
                      _rightPrice = widget.list[(widget.list.length - 1) -i].x;
                      _rightImageCurrentIndex = i;
                      break;
                    }
                  }
                  setState(() {}); // 刷新UI
                  if(widget.rightSlidListener != null){
                    widget.rightSlidListener(true,_rightImageCurrentIndex);
                  }
                },
                onHorizontalDragEnd: (DragEndDetails details){
                  isRightDragging = false;
                  double singleW = (screenWidth)/segmentPart;
                  double _rightImageMarginFlag = _rightImageMargin;
                  print('拖拽结束');
                  for(int i = 0; i< widget.list.length;i++){
                    if(_rightImageMarginFlag < singleW * (0.5 + i)){
                      if(i == 0){
                        _rightImageMargin = 0;

                      }else{
                        _rightImageMargin = singleW * i + 5;

                      }
                      _rightPrice = widget.list[(widget.list.length - 1) -i].x;
                      _rightImageCurrentIndex = i;
                      break;
                    }
                  }
                  print('选中第$_rightImageCurrentIndex个');
                  setState(() {});// 刷新UI

                  if(widget.rightSlidListener != null){
                    widget.rightSlidListener(false,_rightImageCurrentIndex);
                  }
                },
              ),
              Visibility(
                visible: ! isRightDragging,
                child: Text("$_rightPrice",style: TextStyle(fontSize: 12,color: Colors.black),),
              ),
            ],
          ),

        ],
      ),
    );
  }



  /*
      * 横线视图模块,包括黄色横线和黑色横线
      * */
  _lineBlock(BuildContext context, double screenWidth) {
    return Row(
      children: <Widget>[
//        SizedBox(
//          width: 20,
//        ),
        Stack(
          children: <Widget>[
            Container(// 黄色横线
              color: Colors.transparent,
              height: 30,
              width: screenWidth - 20,
              alignment: Alignment.center,
              child: Container(
                //color: Color.fromRGBO(254, 216, 54, 1),
                height: 2,
                width: screenWidth - 20,
              ),
            ),
//            Positioned(// 左边黑色竖线
//                left: 0,
//                top: 13,
//                child:Container(
//                  height: 4,
//                  width: _leftBlackLineW,
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      border: Border(left: BorderSide(color: Colors.black, width: 1), top: BorderSide(color: Colors.black, width: 1), bottom: BorderSide(color: Colors.black, width: 1))
//                  ),
//                )
//            ),
//            Positioned(// 右边黑色竖线
//                right: 0,
//                top: 13,
//                child:Container(
//                  height: 4,
//                  width: _rightBlackLineW,
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      border: Border(right: BorderSide(color: Colors.black, width: 1), top: BorderSide(color: Colors.black, width: 1), bottom: BorderSide(color: Colors.black, width: 1))
//                  ),
//                )
//            ),
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

























