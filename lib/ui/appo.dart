import 'dart:math';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/cards/card3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class BarberAppoScreen extends StatefulWidget {
  final Function(String)? callback;
  final Function(Function()) openDialog;
  final Function(String name, Function(int, String)) openDialogComplete;

  const BarberAppoScreen({Key? key, this.callback, required this.openDialog,
    required this.openDialogComplete}) : super(key: key);
  @override
  _BarberAppoScreenState createState() => _BarberAppoScreenState();
}

class _BarberAppoScreenState extends State<BarberAppoScreen> with TickerProviderStateMixin {

  var windowWidth;
  var windowHeight;
  double? windowSize;
  TabController? _tabController;
  List<AppointmentData> _appointments = [];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _loadData();
    super.initState();
  }

  _loadData(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return;
    FirebaseFirestore.instance.collection("appointment")
        .where('customer_id', isEqualTo: user.uid)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        var t = result.data();
        var _date = DateFormat('yyyy.MM.dd').parse(t["date"]);
        var _start = DateFormat('HH:mm').parse(t["time_start"]);
        var _end = DateFormat('HH:mm').parse(t["time_end"]);
        var _time = "${DateFormat(getTimeFormat()).format(_start)}-${DateFormat(getTimeFormat()).format(_end)}";
        double rate = 0;
        int rateCount = 0;
        for (var item in employee)
          if (item.id == t["employee_id"]) {
            rate = item.rate;
            rateCount = item.rateCount;
          }
        _appointments.add(AppointmentData(result.id, DateFormat(dateFormat).format(_date),
            t["employee_name"], t["payment"], _time,
            t["work_name"], t["employee_url"], t["status"], rate, rateCount,
            (t["rate"] == null) ? 0 : t["rate"],
            (t["rate_text"] == null) ? "" : t["rate_text"],
            (t["toPay"] == null) ? 0 : t["toPay"],
            (t["couponId"] == null) ? "" : t["couponId"],
            (t["discount"] == null) ? "" : t["discount"],
            (t["total"] == null) ? 0 : t["total"],
            t["payed"]
            ));
      });
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
        child: ListView(
          padding: EdgeInsets.only(top: 0),
        children: [

            TabBar(
              labelColor: Colors.black,
              tabs: [
                Text(strings.get(80), // "Upcoming",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black)),
                Text(strings.get(81), // "Completed",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black)),
                Text(strings.get(82), //"Canceled",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black)),
              ],
              controller: _tabController,
            ),

            Container(
              height: windowHeight,
              width: windowWidth,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _tabChild("create", ""),
                  _tabChild("complete", ""),
                  _tabChild("cancelled_by_user", "cancelled_by_salon"),
                ],
              ),
            ),
        ],
        )

        ),

    ]));
  }

  _tabChild(String sort, String sort2){
    List<Widget> list = [];
    for (var item in _appointments) {
      if (item.status != sort && item.status != sort2)
        continue;
      var _str = getPriceString(item.toPay);
      if (item.discount.isNotEmpty)
        _str = "$_str (${item.discount}) = ${getPriceString(item.total)}";
      if (item.payed)
        _str = "$_str\n${strings.get(92)}"; // Payed
      else
        _str = "$_str\n${strings.get(93)}"; // Not Paid
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: card3(item.image, item.employeeName, "",
            item.workName,
            _str,
            item.date, windowWidth,
            strings.get(75), // "Your Time:",
            item.time,
            item.empRate, item.empRateCount,
            item.rate, item.review,
            (item.status == "create"), (){_cancel(item);},
            (item.status == "create"), (){_complete(item);},

      )));
      list.add(SizedBox(height: 10,));
    }
    if (list.isEmpty)
      return Container(
        alignment: Alignment.topCenter,
        width: windowWidth,
        height: windowHeight,
        child: Column(
          children: [
            UnconstrainedBox(
                child: Container(
                    margin: EdgeInsets.only(top: windowHeight*0.2),
                    width: windowWidth/4,
                    height: windowWidth/4,
                    child: Image.asset(
                      'assets/no.png',
                      fit: BoxFit.contain,
                    ))),
            SizedBox(height: 20,),
            Text(strings.get(87), style: TextStyle(fontSize: 20, color: Colors.grey),) // "No appointments",
          ],
        )
      );
    list.add(SizedBox(height: 200,));
    return ListView(
      children: list,
    );
  }

  _complete(AppointmentData item){
    widget.openDialogComplete(item.employeeName, (int rate, String text){
      print("rate=$rate text=$text");
      FirebaseFirestore.instance.collection("appointment").doc(item.id).set({
        "status": "complete",
        "rate": rate,
        "rate_text": text,
        "stamp": DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge:true)).then((value2) {
        item.status = "complete";
        item.rate = rate;
        item.review = text;
        setState(() {
        });
      });
      print("cancel ${item.id}");
    });
  }

  _cancel(AppointmentData item){
    widget.openDialog((){
      FirebaseFirestore.instance.collection("appointment").doc(item.id).set({
        "status": "cancelled_by_user",
      }, SetOptions(merge:true)).then((value2) {
        item.status = "cancelled_by_user";
        setState(() {
        });
      });
      print("cancel ${item.id}");
    });
  }
}


