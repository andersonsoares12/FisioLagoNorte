import 'package:flutter/material.dart';

checkBox21(Color color, bool init, Function(bool) callback){
  return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        callback(!init);
      },
  child: Stack(
        children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 25,
              padding: EdgeInsets.only(left: (!init) ? 12 : 0,
                  right: (!init) ? 12 : 0),
              height: 25,
              child: Image.asset(
                "assets/checkbox4.png",
                fit: BoxFit.contain,
                color: color,
          )),
          Container(
            height: 25,
            width: 25,
            child: Image.asset(
              "assets/checkbox4_off.png",
              fit: BoxFit.contain,
              color: color,
            )
          ),


    ],
  ));
}
