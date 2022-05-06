import 'package:flutter/material.dart';

button170(Color color, Widget _icon, double radius, double size, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: Border.all(color: (enable) ? color : Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(radius),
          ),
        child: _icon,
      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius) ),
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
