import 'dart:developer';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'data.dart';
import 'offers.dart';

class Appointment {
  Salon? salon;     // salon
  List<DateTime> selectDays = [];
  DateTime selectedDay = DateTime.now();
  DateTime? openTime;
  DateTime? closeTime;
  EmployeeData? employee;
  bool selectService = false;
  TimeSlot? selectSlot; // slot
  double priceAll = 0;
  double priceWithCoupon = 0;
  OffersData? offer;
  List<WorkData> works = [];
  String couponDiscount = "";
  bool payed = false;
  String services = "";
  bool enablePoints = false;
  int subPoints = 0;

  clear(){
    salon = null;
    selectDays = [];
    selectedDay = DateTime.now();
    openTime = null;
    closeTime = null;
    employee = null;
    selectService = false;
    selectSlot = null;
    priceAll = 0;
    priceWithCoupon = 0;
    offer = null;
    works = [];
    couponDiscount = "";
    payed = false;
    services = "";
    enablePoints = false;
    subPoints = 0;
  }

  init(){
    for (var item in work)
      item.select = false;
    if (salon == null)
      return;
    if (salon!.openTime.isNotEmpty || salon!.closeTime.isNotEmpty) {
      openTime = DateFormat('HH:mm').parse(salon!.openTime);
      closeTime = DateFormat('HH:mm').parse(salon!.closeTime);
    }
    _setWeekend();
  }

  _setWeekend() {
    var _now = DateTime.now().subtract(Duration(days: 90));
    for (var i = 0; i < 180; i++) {
      if (salon!.weekend1 && _now.weekday == DateTime.monday ||
          salon!.weekend2 && _now.weekday == DateTime.tuesday ||
          salon!.weekend3 && _now.weekday == DateTime.wednesday ||
          salon!.weekend4 && _now.weekday == DateTime.thursday ||
          salon!.weekend5 && _now.weekday == DateTime.friday ||
          salon!.weekend6 && _now.weekday == DateTime.saturday ||
          salon!.weekend7 && _now.weekday == DateTime.sunday)
        selectDays.add(_now);
      _now = _now.add(Duration(days: 1));
    }
  }

  getStartTime() => DateFormat("HH:mm").format(selectSlot!.timeStart);
  getEndTime() => DateFormat("HH:mm").format(selectSlot!.timeEnd);

  Function(String)? callback;
  Function()? callback0Redraw;

  int getPointsInt(){
    if (!salon!.loyaltyEnable)
      return 0;
    if (salon == null)
      return 0;
    return (salon!.loyaltyInPercentages) ? ((salon!.points/100)*priceWithCoupon).toInt()
        : salon!.points;
  }

  String getPoints(){
    if (!salon!.loyaltyEnable)
      return "";
    if (salon == null)
      return "";
    var t = getPointsInt();
    if (t == 0)
      return "";
    return  t.toString();
  }

  Future<String?> finish(String id) async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    if (selectSlot == null)
      return "selectSlot == null";
    var _start = getStartTime();
    var _end = getEndTime();

    payed = (id != strings.get(70)); // "Cash payment",

    log("appointments data finish");
    log("_start=$_start, _end=$_end");

    if (enablePoints)
      couponDiscount = "$couponDiscount -$subPoints ${strings.get(135)}"; // points

    try{
      await FirebaseFirestore.instance.collection("appointment").add({
        "salon": salon!.id,
        "salon_name": salon!.name,
        "stamp_create" : DateTime.now(),
        "stamp": selectedDay.millisecondsSinceEpoch,
        "date": DateFormat('yyyy.MM.dd').format(selectedDay),
        "time_start": "$_start",
        "time_end": "$_end",
        "customer_id": user.uid,
        "customer_name": userName,
        "employee_id": employee!.id,
        "employee_name": employee!.name,
        "work_name" : services,
        "payment" : id,
        "payed" : payed,
        "employee_url" : employee!.image,
        "status" : "create",
        "toPay" : priceAll,
        "couponId" :  (offer == null) ? "" : offer!.id,
        "discount" : couponDiscount,
        "total" : priceWithCoupon,
      });
      userAddPoints(salon!.id, getPointsInt());
      if (enablePoints)
        userSubPoints(salon!.id, subPoints);
    }catch(ex){
        log("appointmentData");
        log(ex.toString());
        return ex.toString();
    }
    return null;
  }
}

Appointment appointmentData = Appointment();

loadWeekend() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return;

  try {
    var querySnapshot = await FirebaseFirestore.instance.collection("weekend").get();

    for (var result in querySnapshot.docs) {
      var t = result.data();
      var date = t["date"];
      appointmentData.selectDays.add(DateFormat('yyyy.MM.dd').parse(date));
    }
  }catch(ex){
    log("loadWeekend ${ex.toString()}");
  }
}