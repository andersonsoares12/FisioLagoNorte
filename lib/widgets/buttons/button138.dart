import 'package:flutter/material.dart';

button138(Color color, Color iconColor, String _icon, double radius, double size, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius),
          ),
        child: UnconstrainedBox(
            child: Container(
                height: size/2,
                width: size/2,
                child: Image.asset(_icon,
                  fit: BoxFit.contain, color: iconColor,
                )
            )),
      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(100) ),
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
