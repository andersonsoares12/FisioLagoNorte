import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Edit24OTP extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color color;
  final double radius;
  Edit24OTP({this.hint = "", required this.controller, this.type = TextInputType.text, this.color = Colors.black, this.radius = 0,
    this.onChangeText});

  @override
  _Edit24OTPState createState() => _Edit24OTPState();
}

class _Edit24OTPState extends State<Edit24OTP> {

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
        keyboardType: TextInputType.phone,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText!(value);
        },
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^(\+?)\d{0,' + otpNumber.toString() + '}')),
        ],
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