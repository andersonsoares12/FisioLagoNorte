import 'package:flutter/material.dart';

text51(String text, TextStyle textStyle, String text2, TextStyle textStyle2, Color color){
  return IntrinsicHeight(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(right: 5),
            width: 10,
            height: 10,
          ),
          SizedBox(width: 10,),
          Expanded(child: Text(text, textAlign: TextAlign.start, style: textStyle,)),
          Text(text2, textAlign: TextAlign.start, style: textStyle2,)
        ],
      ),

        // Expanded(child: Container(
        //   margin: EdgeInsets.only(left: 25),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //
        //       Text(text2, textAlign: TextAlign.start, style: textStyle2,)
        //       ],
        //   )))
    ],
  ));
}
