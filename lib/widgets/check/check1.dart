import 'package:flutter/material.dart';

check1(double sourceWidth, double sourceHeigth, double radius, IconData icon, Color color, Color iconColor, double size){
  return Container(
    width: sourceWidth,
    height: sourceHeigth,
    alignment: Alignment.topRight,
    child:

    ClipPath(
      clipper: ClipPathClass95(),

      child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.only(topRight: Radius.circular(radius)),
      ),

      width: size,
      height: size,
        child: Container(
          width: size*0.3,
          height: size*0.3,
          margin: EdgeInsets.only(left: size*0.4, bottom: size*0.4),
          child: Container(
            // color: Colors.red,
            child: Icon(icon, color: iconColor, size: size*0.4,),
          )
        // ),

    )),
  ));
}


class ClipPathClass95 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}