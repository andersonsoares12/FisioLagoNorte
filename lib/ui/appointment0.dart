import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button142.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/check/check1.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'appointment1.dart';

class BarberAppointment0Screen extends StatefulWidget {
  final Function(String) callback;
  final String backRoute;
  const BarberAppointment0Screen({Key? key, required this.callback, required this.backRoute}) : super(key: key);

  @override
  _BarberAppointment0ScreenState createState() => _BarberAppointment0ScreenState();
}

class _BarberAppointment0ScreenState extends State<BarberAppointment0Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void initState() {
    appointmentData.clear();
    _initData();
    super.initState();
  }

  _initData() async {
    await loadWeekend();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return WillPopScope(
        onWillPop: () async {
      return _callBack();
    },
    child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

            Container(
              width: windowWidth,
              height: windowHeight,
              color: (darkMode) ? Colors.black : Colors.white30,
            ),

            Container (
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                children: _step1(),
              ),),

            appbar1((darkMode) ? Colors.black : Colors.white,
                (darkMode) ? Colors.white : Colors.black, strings.get(60), // "Book Appointment",
                context, () {
              _callBack();
            })

          ],
        )

    ));
  }

  _callBack(){
    widget.callback(widget.backRoute);
    return false;
  }

  _step1() {
    List<Widget> list = [];

    list.add(Container(
      padding: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15, top: 30, bottom: 30),
      child: pagination2([Icons.home, Icons.stairs, Icons.date_range, Icons.local_offer, Icons.payment, Icons.send],
          0, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));

    list.add(SizedBox(height: 10,));
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
        child: Text("Selecionar Clinica", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
            color: (darkMode) ? Colors.white : Colors.black),)));  // "Select Salon",
    list.add(SizedBox(height: 20,));

    for (var item in salons){
      list.add(Stack(
        children: [
          button142(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
              0, 0,
              item.address, TextStyle(fontSize: 13, color: (darkMode) ? Colors.white : Colors.black),
              Colors.white, item.imageUrl, windowWidth, windowWidth*0.5, 10, (){
                appointmentData.salon = item;
                print("button pressed");
                _redraw();
              }, ""),
          if (appointmentData.salon != null && appointmentData.salon!.id == item.id)
            Container(
              margin: EdgeInsets.only(top: 10),
              child: check1(windowWidth-10, windowWidth*0.5-10, 10, Icons.check, Color(0xFF225C3C), Colors.white, (windowSize/2-20)*0.3),
            )
        ],
      ));
    }

    list.add(SizedBox(height: 30,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: button2(strings.get(91), // "Next",
          Color(0xFF225C3C), 10, _next, (appointmentData.salon != null) ? true : false)
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _next(){
    appointmentData.callback = widget.callback;
    appointmentData.callback0Redraw = _redraw;
    appointmentData.init();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberAppointment1Screen(),
      ),
    );
  }
}


