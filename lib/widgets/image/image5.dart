import 'package:flutter/material.dart';

image5(Widget item, double radius){
    return Container(
        child: ClipPath(
            clipper: ClipImageClass(radius),
            child: item
    ));
}

class ClipImageClass extends CustomClipper<Path> {
  final double radius;
  ClipImageClass(this.radius);
  @override
  Path getClip(Size size) {
    print(size.toString());
    var path = Path();
    path.moveTo(0, size.height-radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(size.width-radius, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height-radius);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
