import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button135.dart';

import '../main.dart';
import '../model/pref.dart';

class BarberLanguageScreen extends StatefulWidget {
  final Function(String) callback;
  final Function() redraw;
  const BarberLanguageScreen({Key? key, required this.callback, required this.redraw}) : super(key: key);

  @override
  _BarberTermsScreenState createState() => _BarberTermsScreenState();
}

class _BarberTermsScreenState extends State<BarberLanguageScreen> {

  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

            if (!darkMode)
            Container(
              width: windowWidth,
              height: windowHeight,
              color: Colors.white30,
            ),

            Container (
              child: ListView(
                shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, strings.get(95), context, () { // Select Language
              widget.callback("root");
            })

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 50,));

    for (var item in strings.langData){
      list.add(Button135(
          color: (darkMode) ? Color(0xff303030) : Colors.white, text: item.name,
          textStyle: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black),
          icon: item.image,
          pressButton: (){
            print("button pressed id=${item.id}");
            pref.set(Pref.language, "${item.id}");
            strings.setLang(item.id);
            widget.redraw();
            widget.callback("root");
          }));
      list.add(SizedBox(height: 10,));
    }

    return list;
  }
}

class LangData{
  String id;
  String icon;
  String text;
  LangData(this.id, this.icon, this.text);
}

