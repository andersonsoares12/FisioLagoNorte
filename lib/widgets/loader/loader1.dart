import 'package:flutter/material.dart';

loader1(double width, Color bkgColor, Color color){
  return UnconstrainedBox(child: Container(
    width: width,
      height: width,
      child: CircularProgressIndicator(
      backgroundColor: bkgColor,
    valueColor: AlwaysStoppedAnimation<Color>(color),
    strokeWidth: 1,
  )));
}
