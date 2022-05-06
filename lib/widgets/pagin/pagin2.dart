import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';

pagination2(List<IconData> widgets, var select, Color color, double width){
  print("pagination2 select=$select");
  List<Widget> list = [];
  var index = 0;
  for (var item in widgets) {
    if (index <= select)
      list.add(Icon(item, color: color,));
    else
      list.add(Icon(item, color: (darkMode) ? Colors.white : Colors.black.withAlpha(100),));
    if (index != widgets.length-1){
      if (index < select)
        list.add(Container(width: width*0.05, height: 3, color: color));
      else
        list.add(Container(width: width*0.05, height: 3, color: (darkMode) ? Colors.white : Colors.black.withAlpha(100),));
    }
    index++;
  }
  return Container(
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    )
  );
}