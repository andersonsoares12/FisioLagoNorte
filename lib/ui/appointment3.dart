import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/offers.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/offer.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/check/check1.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import '../main.dart';
import 'appointment4.dart';

class BarberAppointment3Screen extends StatefulWidget {
  const BarberAppointment3Screen({Key? key}) : super(key: key);

  @override
  _BarberAppointment3ScreenState createState() => _BarberAppointment3ScreenState();
}

class _BarberAppointment3ScreenState extends State<BarberAppointment3Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  // bool _wait = true;
  // _waits(bool value){
    // _wait = value;
  //   _redraw();
  // }
  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  @override
  void initState() {
    // initializeDateFormatting();
    super.initState();
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
      Navigator.pop(context);
      return false;
  }

  _step1() {
    List<Widget> list = [];

    list.add(Container(
        padding: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15, top: 30, bottom: 30),
        child: pagination2([Icons.home, Icons.stairs, Icons.date_range, Icons.local_offer, Icons.payment, Icons.send],
            3, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));

    list.add(SizedBox(height: 10,));

    if (offers.isNotEmpty) {
      List<Widget> list2 = [];
      for (var item in offers) {
        log("item.dateStart=${item.dateStart} ${DateTime.now().difference(item.dateStart).inDays}");
        if (DateTime.now().difference(item.dateStart).inDays < 0) {
          log("delete");
          continue;
        }
        log("item.dateEnd=${item.dateEnd} ${DateTime.now().difference(item.dateEnd).inDays}");
        if (DateTime.now().difference(item.dateEnd).inDays > 0) {
          log("delete");
          continue;
        }
        if (!item.salons.contains(appointmentData.salon!.id))
          continue;
        if (item.minAmount != null && item.minAmount! > appointmentData.priceAll)
          continue;
        list2.add(InkWell(
            onTap: () {
              if (!item.select){
                appointmentData.offer = null;
                for (var item2 in offers)
                  item2.select = false;
                item.select = true;
                appointmentData.offer = item;
                log("select offer ${item.name} item.discount=${item.discount}");
                setState(() {
                });
              }
            },
            child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Stack(
          children: [
            offerItem(item, windowWidth),
            if (item.select)
              check1(windowWidth-25, 100, 10, Icons.check, Color(0xFF225C3C), Colors.white, (windowSize/2-20)*0.3)
          ],
        ))));
      }
      if (list2.isNotEmpty){
        list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text(strings.get(88), // "Special offers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,),),
        ));
        list.add(SizedBox(height: 20,));
        list.addAll(list2);
      }
    }

    list.add(SizedBox(height: 30,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: button2(strings.get(91), // "Next",
          Color(0xFF225C3C), 10, _next, true)
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _next(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberAppointment4Screen(),
      ),
    );
  }
}


