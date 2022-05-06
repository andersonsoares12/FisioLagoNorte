import 'package:flutter/material.dart';

class Edit25 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final double radius;
  Edit25({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black, this.radius = 0,
    this.onChangeText});

  @override
  _Edit25State createState() => _Edit25State();
}

class _Edit25State extends State<Edit25> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.color;

    var _icon = Icons.visibility_off;
    if (!_obscureText)
      _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon, //_icon,
        color: _colorDefaultText,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );

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
          suffixIcon: _sicon2,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}