/*
* Author : LiJiqqi
* Date : 2020/3/12
*/



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/airbnb_price_picker.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/price_slider/price_slier_widget.dart';
import 'package:flutter_slider_demo/combine_demo/own_demo/use_mp_chart_demo/price_slider_mp.dart';
import 'package:flutter_slider_demo/combine_page.dart';
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
          RaisedButton(
            child: Text("combine demo ( price slider)"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return PriceSliderWidget();
              }));
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text("combine demo "),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return CombinePage();
              }));
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text("price slider with MP chart "),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){
                return PriceSliderMP();
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




















