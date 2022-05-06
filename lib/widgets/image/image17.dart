import 'package:flutter/material.dart';

image17(Widget item, double width, Color color){
    return UnconstrainedBox(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 6),
                shape: BoxShape.circle,
            ),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(width),
    child: Container(
            width: width,
            height: width,
            child: item,
    ))
    ));
}
