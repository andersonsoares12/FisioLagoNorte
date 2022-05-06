import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button15.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import '../main.dart';

class BarberAppointment5Screen extends StatefulWidget {
  const BarberAppointment5Screen({Key? key}) : super(key: key);

  @override
  _BarberAppointment5ScreenState createState() => _BarberAppointment5ScreenState();
}

class _BarberAppointment5ScreenState extends State<BarberAppointment5Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  @override
  void initState() {
    initializeDateFormatting();
    // _initData();
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
                    children: _step3(),
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


  _step3() {
    List<Widget> list = [];

    list.add(Container(
        padding: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15, top: 30, bottom: 30),
        child: pagination2([Icons.home, Icons.stairs, Icons.date_range, Icons.local_offer, Icons.payment, Icons.send],
            5, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 20,));

    // var _time = "";
    // for (var slot in _slots)
    //   if (slot.id == _selectItem){
    //     var _start = DateFormat(getTimeFormat()).format(slot.timeStart);
    //     var _end = DateFormat(getTimeFormat()).format(slot.timeEnd);
    //     _time = "$_start-$_end";
    //   }

    var _time = "${appointmentData.getStartTime()}-${appointmentData.getEndTime()}";

    list.add(Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          //
          // Block #1
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(appointmentData.salon!.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                      color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,),
                  SizedBox(height: 10,),
                  Row(children: [
                    Icon(Icons.location_city, color: Colors.grey,),
                    SizedBox(width: 10,),
                    Expanded(child: Text(appointmentData.salon!.address,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey), maxLines: 3,)),
                  ],),
                  SizedBox(height: 10,),
                  Row(children: [
                    Icon(Icons.phone, color: Colors.grey,),
                    SizedBox(width: 10,),
                    Expanded(child: Text(appointmentData.salon!.phone,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey), maxLines: 3,)),
                  ],)
                  // Text(text5, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.orange), maxLines: 3,),
                ],)),
              SizedBox(width: 20,),
              if (appointmentData.payed)
                UnconstrainedBox(
                    child: Container(
                        height: windowWidth*0.25,
                        width: windowWidth*0.25,
                        child: Image.asset("assets/barber/paid.jpg",
                            fit: BoxFit.contain
                        )
                    )),
            ],
          ),

          //
          // Block #2
          //
          Container(width: double.maxFinite, height: 0.5, color: Colors.grey,
            margin: EdgeInsets.only(top: 20, bottom: 20),),

          Row(children: [
            Expanded(child: Text(appointmentData.services,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
            // SizedBox(width: 10,),
            // Expanded(child: Text(DateFormat(dateFormat).format(appointmentData.selectedDay),
            //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.orange), maxLines: 1, textAlign: TextAlign.end,)),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.account_circle_rounded, color: Colors.grey,),
            SizedBox(width: 10,),
            Expanded(child: Text(appointmentData.employee!.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey), maxLines: 1,)),
            SizedBox(width: 10,),
            Text("${DateFormat(dateFormat).format(appointmentData.selectedDay)}\n$_time",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF225C3C)), textAlign: TextAlign.end,),
          ],),
        ],
      ),
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: button2(strings.get(73), // "Book More Appointment",
            Color(0xFF225C3C), 10, (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              if (appointmentData.callback0Redraw != null)
                appointmentData.callback0Redraw!();
              appointmentData.clear();
            }, true)
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 100),
        child: button15(strings.get(74), // "Go to Appointments",
            Color(0xFF225C3C), 15, (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              if (appointmentData.callback != null)
                appointmentData.callback!("appointments");
            }, true)
    ));

    return list;
  }
}


