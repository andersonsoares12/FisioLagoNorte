import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';

checkBox43(String text, Color color, String icon, TextStyle style, bool init, Function(bool) callback){
  return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        callback(!init);
      },
  child: Row(
    children: <Widget>[
      if (icon.isNotEmpty)
        UnconstrainedBox(
            child: Container(
                height: 35,
                width: 100,
                child: Image.asset(icon,
                    fit: BoxFit.contain
                )
            )),
      SizedBox(width: 10,),
      Expanded(child: Text(text, style: style)),
      SizedBox(width: 10,),
      Stack(
        children: [
            AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 35,
                height: 35,
                padding: EdgeInsets.only(right: (init) ? 18 : 0, left: (init) ? 17 : 0),
                child: Image.asset(
                  "assets/checkbox10_off.png",
                  fit: BoxFit.fill,
                  color: (darkMode) ? Colors.white : Colors.black,
                )),

            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 35,
              padding: EdgeInsets.only(right: (!init) ? 18 : 0, left: (!init) ? 17 : 0),
              height: 35,
              child: Image.asset(
                "assets/checkbox10.png",
                fit: BoxFit.fill,
                color: color,
          )),
        ],
      ),
    ],
  ));
}
