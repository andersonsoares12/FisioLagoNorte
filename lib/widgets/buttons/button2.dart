import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';

button2(String text, Color color, double _radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
              color: (darkMode) ? Colors.white : Colors.white), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
      ),
      if (enable)
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(_radius) ),
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.2),
              onTap: (){
                _callback();
              }, // needed
            )),
      )
    ],
  );
}
