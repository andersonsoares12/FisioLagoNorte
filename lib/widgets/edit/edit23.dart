import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

edit23(TextEditingController _controller, String _hint, double radius, Color color){
  bool _obscure = false;
  return
    Container(
      padding: EdgeInsets.only(left: 10, right: 10, ),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
        border: new Border.all(
          color: color,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {
        },
        cursorColor: color,
        style: TextStyle(fontSize: 14, color: color),
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 100,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: _hint,
          hintStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
}