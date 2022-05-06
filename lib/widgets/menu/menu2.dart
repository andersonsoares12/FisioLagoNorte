import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/checkbox/checkbox17.dart';

class Menu2Data{
  int type;
  String id;
  String text;
  IconData? icon;
  bool checkValue;
  Menu2Data(this.type, this.id, this.text, {this.icon, this.checkValue = true});
}

class Menu2 extends StatefulWidget {
  final BuildContext context;
  final List<Menu2Data> data;
  final Function? onPressCheck;
  Menu2(this.context, this.data, {this.onPressCheck});

  @override
  _Menu2State createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var item in widget.data) {
      if (item.type == 1)
        list.add(_menuItem(item.id, item.text, item.icon),);
      if (item.type == 2)
        list.add(_menuItem2(item),);
    }
    return Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 50),
            children: list
          ),
        )
    );
  }

  _menuItem(String id, String name, IconData? iconData){
    return ListTile(
      title: Text(name, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w800 ),),
      leading:  UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Icon(iconData,
              )
          )),
    );
  }

  _menuItem2(Menu2Data item){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: checkBox17(item.text, Colors.orange, TextStyle(fontSize: 14), item.checkValue, (bool? val) {
      item.checkValue = val!;
      setState(() {
      });
      widget.onPressCheck!(item.id, item.checkValue);
    } ));
  }

}