




import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/price_slider/price_slier_widget.dart';

import '../../../fake_data.dart';

class PriceSliderMP extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return PriceSliderMPState();
  }

}

class PriceSliderMPState extends State<PriceSliderMP> {


  //默认左右截取位置
  double leftValue =0,
      rightValue = 1;

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

          ],
        ),
      ),
    );
  }
}






















