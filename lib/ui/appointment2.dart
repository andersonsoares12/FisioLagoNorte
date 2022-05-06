import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/offers.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button15.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import '../main.dart';
import 'appointment3.dart';
import 'appointment4.dart';

class BarberAppointment2Screen extends StatefulWidget {
  const BarberAppointment2Screen({Key? key}) : super(key: key);

  @override
  _BarberAppointment2ScreenState createState() => _BarberAppointment2ScreenState();
}

class _BarberAppointment2ScreenState extends State<BarberAppointment2Screen> {

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
    initializeDateFormatting();
    _getSelectDateInformation();
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

  _callBack() {
    Navigator.pop(context);
    return true;
  }

  _step1() {
    List<Widget> list = [];

    list.add(Container(
        padding: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15, top: 30, bottom: 30),
        child: pagination2([Icons.home, Icons.stairs, Icons.date_range, Icons.local_offer, Icons.payment, Icons.send],
            2, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));

    list.add(SizedBox(height: 30,));

    var kNow = DateTime.now();
    list.add(Container(
        decoration: BoxDecoration(
          //color: (blackMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TableCalendar(
          locale: strings.locale,
          firstDay: kNow,
          lastDay: DateTime(kNow.year, kNow.month + 3, kNow.day),
          calendarFormat: CalendarFormat.week,
          availableGestures: AvailableGestures.horizontalSwipe,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronIcon: Icon(Icons.chevron_left, color: (darkMode) ? Colors.white : Colors.black,),
            rightChevronIcon: Icon(Icons.chevron_right, color: (darkMode) ? Colors.white : Colors.black,),
          ),
          selectedDayPredicate: (day) => isSameDay(appointmentData.selectedDay, day),
          focusedDay: appointmentData.selectedDay,
          onDaySelected: (selectedDay, focusedDay) {
            print(selectedDay.toString());
            // if (selectedDay.weekday == DateTime.sunday)
            //   return;
            appointmentData.selectedDay = selectedDay;
            _getSelectDateInformation();
            _redraw();
          },
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (BuildContext context, DateTime day){ // в заголовке день и месяц
              return Container(
                child: Text(DateFormat.yMMM(strings.locale).format(day),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: barberMainColor)),
              );
            },
            // outsideBuilder: (BuildContext context, DateTime day, DateTime focusedDay){ // дни другого месяца
            //   return Container(color: Colors.red,);
            // },
            dowBuilder: (BuildContext context, DateTime day){
              return _buildCalendarDayOfWeeek(day);
            },
            todayBuilder: (context, day, selectDay) {
              return _buildCalendarCell(day, selectDay, false);
            },
            selectedBuilder: (context, day, selectDay) {
              return _buildCalendarCell(day, selectDay, true);
            },
            defaultBuilder: (context, day, selectDay) {
              return _buildCalendarCell(day, selectDay, false);
            },
          ),
        ))
    );

    list.add(SizedBox(height: 30,));

    list.add(_slotsList());

    list.add(SizedBox(height: 30,));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button2(strings.get(91), // "Next",
            Color(0xFF225C3C), 10, _next, (appointmentData.selectSlot != null) ? true : false)
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _buildCalendarDayOfWeeek(DateTime day){
    var _text = DateFormat.E(strings.locale).format(day);
    return Container(
        child: Center(child: Text(
            _text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey)),
        ));
  }

  _buildCalendarCell(DateTime day, DateTime selectDay, bool select){
    bool _select = false;
    for (var item in appointmentData.selectDays){
      if (day.day == item.day && day.month == item.month && day.year == item.year)
        _select = true;
    }
    return Positioned.fill(child: Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: (select) ? BoxDecoration(
          border: Border.all(color: barberMainColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
                day.day.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey)),
            if (_select)
              Container(
                child: FittedBox(child: Text(strings.get(65), // "Weekend",
                  style: TextStyle(fontSize: 10, color: barberMainColor), overflow: TextOverflow.fade,)),
              )
          ],
        )));
  }

  slotsItem(String text, String id, TimeSlot slot){
    if (appointmentData.selectSlot != null && appointmentData.selectSlot!.id == id)
      return Expanded(child: button2(text, Color(0xFF225C3C), 10, (){
        appointmentData.selectSlot = null;
        _redraw();
      }, true));
    else
      return Expanded(child: button15(text, Color(0xFF225C3C), 15, (){
        print("button pressed");
        appointmentData.selectSlot = slot;
        _redraw();
      }, true));
  }

  _next(){
    if (offers.isNotEmpty){
      for (var item in offers) {
        if (DateTime.now().difference(item.dateStart).inDays < 0)
          continue;
        if (DateTime.now().difference(item.dateEnd).inDays > 0)
          continue;
        if (!item.salons.contains(appointmentData.salon!.id))
          continue;
        if (item.minAmount != null && item.minAmount! > appointmentData.priceAll)
          continue;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarberAppointment3Screen(),
          ),
        );
        return;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberAppointment4Screen(),
      ),
    );
  }

  _timeEnds(DateTime _current){
    if (_current.hour < appointmentData.closeTime!.hour)
      return true;
    if (_current.minute < appointmentData.closeTime!.minute)
      return true;
    return false;
  }

  List<TimeSlot> _timeSlotsByDate = [];

  _getSelectDateInformation(){
    _timeSlotsByDate = [];
    FirebaseFirestore.instance.collection("appointment")
        .where('date', isEqualTo: DateFormat('yyyy.MM.dd').format(appointmentData.selectedDay))
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        log("appointment ${result.data()}");
        var data = result.data();
        if (data["salon"] != null)
          if (data["salon"] == appointmentData.salon!.id)
            if (data["employee_id"] == appointmentData.employee!.id){
              _timeSlotsByDate.add(TimeSlot(result.id,
                DateFormat('HH:mm').parse(data["time_start"]),
                DateFormat('HH:mm').parse(data["time_end"]),
              ));
            }
      });
      _redraw();
    });
  }

  List<TimeSlot> _slots = [];

  _slotsList(){
    if (appointmentData.openTime == null || appointmentData.closeTime == null) {
      appointmentData.selectSlot = null;
      return Container(child: Center(child: Text(strings.get(121), // "Work Time for this Salon don't set",
          style: TextStyle(fontSize: 20, color: barberMainColor, fontWeight: FontWeight.w800))));
    }
    for (var item in appointmentData.selectDays)
      if (item.day == appointmentData.selectedDay.day && item.month == appointmentData.selectedDay.month && item.year == appointmentData.selectedDay.year){
        appointmentData.selectSlot = null;
        return Container(child: Center(child: Text(strings.get(66), // "This is weekend",
            style: TextStyle(fontSize: 20, color: barberMainColor, fontWeight: FontWeight.w800))));
      }
    //
    int _slot = 0; // int.parse(_workData!.duration);
    for (var item3 in work)
      if (item3.select)
        _slot += int.parse(item3.duration);
    log("time for work _slot=$_slot");
    //

    for (var item in employee)
      if (appointmentData.employee!.id == item.id)
        for (var item2 in item.weekends)
          if (item2.day == appointmentData.selectedDay.day && item2.month == appointmentData.selectedDay.month && item2.year == appointmentData.selectedDay.year){
            appointmentData.selectSlot = null;
            return Container(child: Center(child: Text(strings.get(122), // "This is weekend for this master",
                style: TextStyle(fontSize: 20, color: barberMainColor, fontWeight: FontWeight.w800))));
          }

    List<Widget> list = [];
    var _current = DateTime(1970,1,1, appointmentData.openTime!.hour, appointmentData.openTime!.minute);
    Widget? _first;
    _slots = [];
    log("-----------TimeSlots-----------");
    var _startId = "";
    var _start = "";
    var _end = "";
    var _endId = "";
    late TimeSlot slot;
    do{
      _start = DateFormat(getTimeFormat()).format(_current);
      _startId = DateFormat("HH:mm").format(_current);
      var _current2 = _current.add(Duration(minutes: _slot));
      if (_slot == 0)
        break;
      _end = DateFormat(getTimeFormat()).format(_current2);
      _endId = DateFormat("HH:mm").format(_current2);
      var _delete = false;
      for (var _timeSlot in _timeSlotsByDate){
        print("_timeSlotsByDate ${_timeSlot.timeStart} $_current");
        if (timeInRange(_current, _current2, _timeSlot.timeEnd, _timeSlot.timeStart))
          _delete = true;
      }
      var _id = "$_startId-$_endId";
      slot = TimeSlot(_id, _current, _current2);
      _slots.add(slot);
      _current = _current2;
      if (_delete){
        print("delete $_start-$_end");
        continue;
      }
      print("add $_start-$_end");
      if (_first == null)
        _first = slotsItem("$_start-$_end", "$_startId-$_endId", slot);
      else {
        list.add(Row(children: [
          _first,
          SizedBox(width: 10,),
          slotsItem("$_start-$_end", _id, slot),
        ],));
        _first = null;
        list.add(SizedBox(height: 10,));
      }
    }while(_timeEnds(_current));
    if (_first != null)
      list.add(Row(
        children: [
          slotsItem("$_start-$_end", "$_startId-$_endId", slot),
          SizedBox(width: 10,),
          Expanded(child: Container())
        ],
      ));

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            children: list
        )
    );
  }
}


