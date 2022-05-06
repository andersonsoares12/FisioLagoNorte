import 'package:flutter/material.dart';

class Edit24 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final double radius;
  Edit24({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black, this.radius = 0,
    this.onChangeText});

  @override
  _Edit24State createState() => _Edit24State();
}

class _Edit24State extends State<Edit24> {

  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.color;

    return Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: widget.color.withAlpha(60),
          borderRadius: BorderRadius.circular(widget.radius),
        ),

      child: TextFormField(
        obscureText: _obscureText,
        cursorColor: _colorDefaultText,
        keyboardType: widget.type,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText!(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}