import 'dart:math';

import 'package:flutter/material.dart';

class BottomBar5 extends StatefulWidget {
  final Function(int) callback;
  final Color colorBackground;
  final Color colorSelect;
  final Color colorUnSelect;
  final List<IconData> icons;
  final int initialSelect;
  final double radius;
  final Function getItem;
  final int shadow;
  final Function() getMessagesCount;
  final Function() getCount;
  BottomBar5({this.colorBackground = Colors.green, required this.callback, this.colorSelect = Colors.red,
    this.colorUnSelect = Colors.red, required this.icons, this.initialSelect = 0, required this.getItem, this.radius = 10,
    required this.getMessagesCount, required this.getCount,
  this.shadow = 20});

  @override
  _BottomBar5State createState() => _BottomBar5State();
}

class _BottomBar5State extends State<BottomBar5> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: windowWidth,
          height: 90,
          child: _bottomBar(),
        ));
  }

  double height = 60;
  double marginTop = 30;

  _bottomBar(){
    return Stack(
      children: [
        _background(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _childs(),
          ),
        ),
      ],
    );
  }

  _childs(){
    double width = windowWidth/widget.getCount();
    double iconSize = 35;
    List<Widget> list = [];
    var index = 0;
    for (var _ in widget.icons) {
      list.add(Stack(
        children: [
          _button(marginTop, width, height, iconSize, index),
          if (index == widget.getItem())
            Container(
              width: width/2,
              height: 8,
              margin: EdgeInsets.only(left: width*0.25, top: 82, right: width*0.25),
              decoration: BoxDecoration(
                color: widget.colorUnSelect,
                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            )
        ],
      ));
      index++;
    }
    return list;
  }

  _background(){
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      height: height,
      width: windowWidth,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(topLeft: Radius.circular(widget.radius), topRight: Radius.circular(widget.radius)),
        color: widget.colorBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(widget.shadow),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }

  _button(double marginTop, double width, double height, double iconSize, int index){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: marginTop),
          height: height,
          width: width,
          child: _icon(iconSize, index, width),
        ),
        Container(
          margin: EdgeInsets.only(top: marginTop),
          height: height,
          width: width,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  if (widget.getItem() != index) {
                    widget.callback(index);
                    setState(() {
                      //_select = index;
                    });
                  }
                }, // needed
              )),
        ),
      ],
    );
  }

  _icon(double size, int index, double width){
    Color color = widget.colorSelect;
    if (widget.icons.length-1 < index)
      return;
    IconData icon = widget.icons[index];
    if (index != widget.getItem()) {
      color = widget.colorUnSelect;
      size = size * 0.8;
    }
    if (index == 3 && widget.getMessagesCount() != 0)
      return UnconstrainedBox(
          child: Container(
              height: size,
              width: size,
              child: Stack(
                children: [
                  Icon(icon , color: color, size: 30,),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(widget.getMessagesCount().toString(), style: TextStyle(fontSize: 14, color: Colors.white),)
                    )
                  ),
                ],
              )
          ));
    return UnconstrainedBox(
        child: Container(
            height: size,
            width: size,
            child: Icon(icon , color: color, size: 30,)
        ));
  }
}
