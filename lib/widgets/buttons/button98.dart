import 'package:flutter/material.dart';

button98(Color color, String _icon, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(100),
          ),
        child: UnconstrainedBox(
            child: Container(
                height: 25,
                width: 25,
                child: Image.asset(_icon,
                  fit: BoxFit.contain, color: Colors.white,
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
