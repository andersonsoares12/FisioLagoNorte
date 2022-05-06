import 'package:flutter/material.dart';

class Edit26a extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final Color borderColor;
  final IconData icon;
  final double radius;
  Edit26a({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black, this.radius = 0,
    this.onChangeText, required this.icon, this.borderColor = Colors.transparent});

  @override
  _Edit26aState createState() => _Edit26aState();
}

class _Edit26aState extends State<Edit26a> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.color;

    return Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      /*child: TextFormField(
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
          suffixIcon: IconButton(icon: Icon(Icons.cancel),
            onPressed: () {
            widget.controller.text = "";
            widget.onChangeText!("");
            },
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _colorDefaultText,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),*/
    );
  }
}