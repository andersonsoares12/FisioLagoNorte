
import 'package:FisioLago/model/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';

import '../main.dart';

class DocumentsScreen extends StatefulWidget {
  final Function(String) callback;
  final String backRoute;
  final String source;
  const DocumentsScreen({Key? key, required this.callback, required this.backRoute, required this.source}) : super(key: key);

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {

  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var _text = "";
    if (widget.source == "terms")
      _text = strings.get(98); // "Terms & Conditions"
    if (widget.source == "about")
      _text = strings.get(96); // "About us",
    if (widget.source == "policy")
      _text = strings.get(32); // "Privacy Policy",

    return Scaffold(
      backgroundColor: (darkMode) ? Colors.white : Colors.white,
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1(Colors.transparent, Colors.black, _text,
                context, () {
                widget.callback(widget.backRoute);
            })

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    var _text = "";
    if (widget.source == "terms")
      _text = terms;
    if (widget.source == "about")
      _text = about;
    if (widget.source == "policy")
      _text = policy;
    list.add(Html(
      data: _text,
    ));
    return list;
  }
}


