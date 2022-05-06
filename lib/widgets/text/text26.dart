import 'package:flutter/material.dart';

text26(String text, String icon){
  return Row(
    children: [
      UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset(icon,
                  fit: BoxFit.contain
              )
        )),
        SizedBox(width: 8,),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.black),),
    ],
  );
}
