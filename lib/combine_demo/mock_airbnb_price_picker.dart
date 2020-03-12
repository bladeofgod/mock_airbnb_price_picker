/*
* Author : LiJiqqi
* Date : 2020/3/12
*/



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/airbnb_price_picker.dart';
import 'package:flutter_slider_demo/price_slider.dart';

import '../chart_example.dart';

class PricePicker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return PricePickerState();
  }

}

class PricePickerState extends State<PricePicker> {
  @override
  Widget build(BuildContext context) {

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("price slider"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return HousePrice();
              }));
            },
          ),
          SizedBox(
          height: 20,
          ),
          RaisedButton(
            child: Text("chart demo"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return ChartExample();
              }));
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text("combine demo ( curve chart)"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return AirbnbPricePicker();
              }));
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}




















