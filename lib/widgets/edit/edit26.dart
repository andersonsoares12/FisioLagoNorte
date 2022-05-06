import 'package:flutter/material.dart';

class Edit26 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Color borderColor;
  final IconData icon;
  final double radius;
  Edit26({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black, this.radius = 0,
    this.onChangeText, required this.icon, this.borderColor = Colors.transparent});

  @override
  _Edit26State createState() => _Edit26State();
}

class _Edit26State extends State<Edit26> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.color;

    return Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: widget.color.withAlpha(60),
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      child: TextFormField(
        obscureText: false,
        cursorColor: _colorDefaultText,
        keyboardType: widget.type,
        controller: widget.controller,
        onChanged: (String value) async {
          widget.onChangeText!(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: new InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: _colorDefaultText,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}