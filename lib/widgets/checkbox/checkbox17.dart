import 'package:flutter/material.dart';

checkBox17(String text, Color color, TextStyle style, bool init, Function(bool?) callback){
  return Row(
    children: <Widget>[
      Expanded(child: Text(text, style: style)),
      SizedBox(width: 10,),
    SizedBox(
    height: 24.0,
    width: 24.0,
    child: Checkbox(
          value: init,
          activeColor: color,
          onChanged: callback
      ),),


    ],
  );
}
