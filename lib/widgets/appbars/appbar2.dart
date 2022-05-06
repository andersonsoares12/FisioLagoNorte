import 'package:flutter/material.dart';

appbar2(Color bkgColor, Color color, String text, IconData icon, BuildContext context, Function() callback){
  return Container(
    height: 40+MediaQuery.of(context).padding.top,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    color: bkgColor,
    child: Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(icon, color: color,)),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        callback();
                      }, // needed
                    )),
              )
            ],
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color), )),
      ],
    )
  );
}