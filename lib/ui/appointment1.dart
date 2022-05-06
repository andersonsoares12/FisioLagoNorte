import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button145.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/check/check1.dart';
import 'package:FisioLago/widgets/checkbox/checkbox21.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'appointment2.dart';
import 'main.dart';

class BarberAppointment1Screen extends StatefulWidget {
  const BarberAppointment1Screen({Key? key}) : super(key: key);

  @override
  _BarberAppointment1ScreenState createState() => _BarberAppointment1ScreenState();
}

class _BarberAppointment1ScreenState extends State<BarberAppointment1Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  _redraw(){
    if (mounted)
      setState(() {
      });
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
            1, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black));

    list.add(SizedBox(height: 20,));

    for (var item in category){
      list.add(Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF225C3C)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: (){
              item.expanded = !item.expanded;
              _redraw();
            },
            child: Row(
              children: [
                Expanded(child: Text(item.name, style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,))),
                Text((item.expanded) ? "-" : "+", style: TextStyle(fontSize: 20, color: (darkMode) ? Colors.white : Colors.black,))
              ],
            )
          )));
      if (item.expanded)
        for (var item2 in work){
          if (item2.categoryId != item.id)
            continue;
          if (appointmentData.salon != null)
            if (!appointmentData.salon!.works.contains(item2.id))
              continue;
          print("${item2.name} ${item2.select}");
          list.add(Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(child: Text(item2.name, style: TextStyle(fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,))),
                  Text("${item2.duration} ${strings.get(59)}", style: TextStyle(fontWeight: FontWeight.w400, color: barberMainColor)), // min
                  SizedBox(width: 20,),
                  Text(getPriceString(toDouble(item2.price)), style: TextStyle(color: (darkMode) ? Colors.white : Colors.black,)),
                  SizedBox(width: 10,),
                  checkBox21(barberMainColor, item2.select,
                      (bool val){
                        item2.select = val;
                        appointmentData.works = [];
                        appointmentData.selectService = false;
                        appointmentData.priceAll = 0;
                        for (var item3 in work)
                          if (item3.select) {
                            appointmentData.works.add(item3);
                            appointmentData.selectService = true;
                            appointmentData.priceAll += item3.price2;
                          }
                        _redraw();
                      })
                ],)));
        }
    }

    list.add(SizedBox(height: 20,));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(strings.get(64), // "Choose Specialist",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,)),
            SizedBox(height: 10,),
            _horizontalSpecialist()
          ],
        )
    ));

    list.add(SizedBox(height: 30,));
    var _messageShow = false;
    for (var item in employee) {
      if (appointmentData.employee!.id == item.id){
      // if (appointmentData.currentItem == item.id){
        for (var item3 in work)
          if (item3.select){
            if (!item.works.contains(item3.id)){
              if (!_messageShow)
                list.add(Container(
                    child: Center(child: Text(strings.get(102), // "This specialist don't make",
                  style: TextStyle(fontSize: 20, color:  especialistaNaoAtende, fontWeight: FontWeight.w800), textAlign: TextAlign.center,))));
              _messageShow = true;
              list.add(Container(
                  child: Center(child: Text("${item3.name}",
                    style: TextStyle(fontSize: 20, color: especialistaNaoAtende, fontWeight: FontWeight.w800), textAlign: TextAlign.center,))));
            }
          }
      }
    }
    list.add(SizedBox(height: 30,));

    log("appointmentData.currentItem.isEmpty && appointmentData.selectService ${appointmentData.employee == null} "
        "&& ${appointmentData.selectService}");
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button2(strings.get(91), // "Next",
            Color(0xFF225C3C), 10, _next, (appointmentData.employee != null && appointmentData.selectService && !_messageShow) ? true : false)
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _horizontalSpecialist(){
    List<Widget> list = [];
    for (var item in employee){
      if (!appointmentData.salon!.employee.contains(item.id))
        continue;
      bool _weekend = false;
      if (appointmentData.employee == null)
        appointmentData.employee = item;
      // if (appointmentData.currentItem.isEmpty)
      //   appointmentData.currentItem = item.id;
      // for (var item2 in item.weekends)
      //   if (item2.day == _selectedDay.day && item2.month == _selectedDay.month && item2.year == _selectedDay.year){
      //     _weekend = true;
      // }
      list.add(Stack(
        children: [
          button145(item.name, TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black,),
              Colors.white, item.image, 100, 150, 10, (){
                print("button pressed");
                appointmentData.employee = item;
                // appointmentData.currentItem = item.id;
                _redraw();
              }),
          if (appointmentData.employee!.id == item.id)
          // if (appointmentData.currentItem == item.id)
              check1(100, 150, 10, Icons.check, Color(0xFF225C3C), Colors.white, (windowSize/2-20)*0.3),
          // if (_weekend)
          //   Positioned.fill(child: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.black.withAlpha(200),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     child: Center(child: Text(strings.get(65), // Weekend
          //     style: TextStyle(color: Colors.white),
          //     ), )
          //   ))
        ],
      ));
      list.add(SizedBox(width: 10,));
    }
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _next(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberAppointment2Screen(),
      ),
    );
  }
}


