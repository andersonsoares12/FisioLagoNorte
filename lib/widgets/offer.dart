import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/offers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

offerItem(OffersData item, double windowWidth){
  var _text = "";
  if (item.percentage)
    _text = "-${item.discount.toStringAsFixed(0)}%";
  else
    _text = "-${getPriceString(item.discount)}";
  String _min = "";
  for (var item in item.salons) {
    for (var salon in salons)
      if (item == salon.id) {
        if (_min.isNotEmpty) {
          _min = "$_min ${strings.get(116)}\n"; // "and other",
          break;
        } else
          _min = salon.name;
      }
    if (_min.endsWith("\n"))
      break;
  }
  if (!_min.endsWith("\n"))
    _min = "$_min\n";
  if (item.minAmount != null && item.minAmount != 0)
    _min = "$_min${strings.get(94)} ${getPriceString(item.minAmount!)}"; // Minimum

  return Directionality(
      textDirection: strings.directionLTR,
      child: Container(
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: Stack(
        children: [
          PhysicalShape(
            color: (darkMode) ? Color(0xff303030) : Colors.white,
            elevation: 4,
            shadowColor: Color(0xFFE4E4E4).withOpacity(0.5),
            clipper: TicketClipper(),
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: TicketClipper(),
                  child: Container(
                    width: windowWidth,
                    height: 100,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                CustomPaint(
                  painter: BorderPainter(),
                  child: Container(
                    height: 100,
                    width: windowWidth,
                  ),
                ),
              ],
            ),
          ),

          Container(
              margin: EdgeInsets.only(left: 10),
              height: 100,
              width: windowWidth*0.2,
              child: Image.asset("assets/offer.png",
                  fit: BoxFit.contain
              )
          ),

          Container(
            margin: EdgeInsets.only(left: windowWidth*0.2+10),
            height: 100,
            width: windowWidth*3/4-windowWidth*0.2-40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("${strings.get(89)} ${DateFormat(dateFormat).format(item.dateStart)}"    // from to
                    "\n${strings.get(90)} ${DateFormat(dateFormat).format(item.dateEnd)}", style: TextStyle(color: Colors.grey),),
                Text(_min, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey,), textAlign: TextAlign.center,),
              ],
            ),

          ),

          Container(
            height: 100,
            alignment: Alignment.centerRight,
            child: RotationTransition(
                turns: new AlwaysStoppedAnimation(-45 / 360),
                child: Container(
                    width: 80,
                    height: 20,
                    // alignment: Alignment.topRight,
                    // color: Colors.green,
                    child: Center(child:  FittedBox(child: Text(_text,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.pink),))))
            ),
          )

        ],
      )));
}


class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.grey[300]!;
    Path path = Path();
//    uncomment this and will get the border for all lines
    path.lineTo(size.width*3/4, 0.0);
    path.relativeArcToPoint(const Offset(20, 0),
        radius: const Radius.circular(10.0), largeArc: true, clockwise: false);
    path.lineTo(size.width-10, 0);
    path.quadraticBezierTo(size.width, 0.0, size.width, 10.0);
    path.lineTo(size.width, size.height -10 );
    path.quadraticBezierTo(
        size.width, size.height, size.width-10, size.height);
    path.lineTo(size.width*3/4+20, size.height);
    path.arcToPoint(Offset((size.width*3/4), size.height),
        radius: const Radius.circular(10.0), clockwise: false);
    path.lineTo(10.0, size.height);
    path.quadraticBezierTo(0.0, size.height, 0.0, size.height - 10);
    path.lineTo(0.0, 10.0);
    path.quadraticBezierTo(0.0, 0.0, 10.0, 0.0);
    path.close();
    canvas.drawPath(path, paint);

    paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey[300]!
      ..isAntiAlias = true;

    for (double i = 10; i < size.height-10; i+=4)
      canvas.drawLine(Offset(size.width*3/4+10,i), Offset(size.width*3/4+10,i+1), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TicketClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(size.width*3/4, 0.0);
    path.relativeArcToPoint(const Offset(20, 0),
        radius: const Radius.circular(10.0), largeArc: true, clockwise: false);
    path.lineTo(size.width-10, 0);
    path.quadraticBezierTo(size.width, 0.0, size.width, 10.0);
    path.lineTo(size.width, size.height -10 );
    path.quadraticBezierTo(
        size.width, size.height, size.width-10, size.height);
    path.lineTo(size.width*3/4+20, size.height);
    path.arcToPoint(Offset((size.width*3/4), size.height),
        radius: const Radius.circular(10.0), clockwise: false);
    path.lineTo(10.0, size.height);
    path.quadraticBezierTo(0.0, size.height, 0.0, size.height - 10);
    path.lineTo(0.0, 10.0);
    path.quadraticBezierTo(0.0, 0.0, 10.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}