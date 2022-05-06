import 'package:flutter/material.dart';

button15(String text, Color color, double radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: (enable) ? color : Colors.grey.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
              color: (enable) ? color : Colors.grey.withOpacity(0.5)
          ), textAlign: TextAlign.center,)
      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius) ),
              child: InkWell(
                splashColor: color.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}
