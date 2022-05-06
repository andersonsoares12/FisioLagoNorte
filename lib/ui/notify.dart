import 'dart:math';

import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/loader/loader32.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/edit/edit26.dart';
import 'package:FisioLago/widgets/text/text51.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class BarberNotifyScreen extends StatefulWidget {
  final Function(String) callback;

  const BarberNotifyScreen({Key? key, required this.callback}) : super(key: key);
  @override
  _BarberNotifyScreenState createState() => _BarberNotifyScreenState();
}

class MessageData{
  MessageData(this.title, this.body, this.time);
  final String title;
  final String body;
  final int time;

  int compareTo(MessageData b){
    if (time > b.time)
      return -1;
    if (time < b.time)
      return 1;
    return 0;
  }
}

Function()? loadMessagesFunc;

class _BarberNotifyScreenState extends State<BarberNotifyScreen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  var _controllerSearch = TextEditingController();
  String _searchText = "";
  List<MessageData> _messages = [];
  bool _loadTime = true;

  @override
  void initState() {
    loadMessages();
    loadMessagesFunc = loadMessages;
    super.initState();
  }

  loadMessages(){
    _loadTime = true;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _waits(false);
      _loadTime = false;
      return;
    }
    FirebaseFirestore.instance.collection("messages").where('user', isEqualTo: user.uid)
        .get().then((querySnapshot) {
      _messages = [];
      querySnapshot.docs.forEach((result) {
        print(result.data());
        _messages.add(MessageData(result.data()["title"], result.data()["body"], result.data()["time"]));
      });
      _messages.sort((a, b) => a.compareTo(b));
      _waits(false);
      _loadTime = false;
    }).catchError((_){
      _loadTime = false;
      _waits(false);
    });

    _setToRead();
  }

  bool _wait = true;
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _setToRead(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return;
    FirebaseFirestore.instance.collection("messages").where('user', isEqualTo: user.uid).where('read', isEqualTo: false)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        FirebaseFirestore.instance.collection("messages").doc(result.id).set({
          "read": true,
        }, SetOptions(merge:true)).then((value2) {});
      });
    });
  }

  @override
  void dispose() {
    loadMessagesFunc = null;
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 10),
              child: ListView(
              children: _getList(),
            ),),

            if (_messages.isEmpty && !_loadTime)
              Center(child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: windowSize*0.5,
                    height: windowSize*0.5,
                    child: Image.asset("assets/nomsg.png",
                        fit: BoxFit.contain
                    )),
                SizedBox(height: 10,),
                Text(strings.get(54), // No messages, yet.
                  style: TextStyle(color: Colors.grey, fontSize: 25),
                ),
              ],
            )),

            if (_wait)
              Center(child: Container(child: Loader32())),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    list.add(Edit26(
      hint: strings.get(53), // "Search",
      color: Colors.grey,
      radius: 10,
      icon: Icons.search,
      controller: _controllerSearch,
      onChangeText: (String value){
        _searchText = value;
        setState(() {
        });
      }
    ));

    list.add(SizedBox(height: 40,));

    var _now = DateFormat('dd MMMM').format(DateTime.now());

    for (var item in _messages){
      if (_searchText.isNotEmpty)
        if (!item.title.toUpperCase().contains(_searchText.toUpperCase()))
          if (!item.body.toUpperCase().contains(_searchText.toUpperCase()))
            continue;
      var time = DateFormat('dd MMMM').format(DateTime.fromMillisecondsSinceEpoch(item.time));
      if (time == _now)
        time = strings.get(52); // Today
      list.add(text51(item.title, TextStyle(fontSize: 18, color: (darkMode) ? Colors.white : Colors.black),
          time, TextStyle(fontSize: 16, color: Colors.grey), Colors.blue));
      list.add(Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: Text(item.body, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black),),
      ));
      list.add(SizedBox(height: 15,));
      list.add(Container(
        margin: EdgeInsets.only(left: 25, top: 10, bottom: 30),
        height: 0.5, width: windowWidth, color: Colors.grey,));
      // list.add(SizedBox(height: 5,));
    }

    list.add(SizedBox(height: 100,));

    return list;
  }
}


