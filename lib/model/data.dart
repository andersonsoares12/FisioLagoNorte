import 'dart:async';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'offers.dart';
import 'pref.dart';

/*
appointment statuses

create
cancelled_by_user
cancelled_by_salon
complete

 */

class TimeSlot{
  TimeSlot(this.id, this.timeStart, this.timeEnd);
  final String id;
  final DateTime timeStart;
  final DateTime timeEnd;
}

class EmployeeData{
  EmployeeData(this.id, this.name, this.desc, this.board, this.boardColor, this.image, this.rate, this.rateCount, this.works, this.weekends);
  final String id;
  final String name;
  final String desc;
  final String board;
  final Color boardColor;
  final String image;
  final double rate;
  final int rateCount;
  final List<String> works;
  final List<DateTime> weekends;
}

class CategoryData{
  CategoryData(this.id, this.name, this.visible, this.board, this.boardColor, this.image, {this.expanded = false});
  final String id;
  final String name;
  final bool visible;
  final String board;
  final Color boardColor;
  final String image;
  bool expanded;
}

class WorkData{
  WorkData(this.id, this.name, this.desc, this.visible, this.duration, this.price, this.price2, this.categoryId, {this.select = false});
  final String id;
  final String name;
  final String desc;
  final bool visible;
  final String duration;
  final String price;
  final double price2;
  final String categoryId;
  bool select;
}

class AppointmentData{
  AppointmentData(this.id, this.date, this.employeeName, this.payment, this.time, this.workName, this.image,
      this.status, this.empRate, this.empRateCount, this.rate, this.review, this.toPay, this.couponId, this.discount,
      this.total, this.payed);
  final String id;
  final String date;
  final String employeeName;
  final String payment;
  final String time;
  final String workName;
  final String image;
  String status;
  final double empRate;
  final int empRateCount;
  int rate;
  String review;
  final double toPay;
  final String couponId;
  final String discount;
  final double total;
  final bool payed;
}

class GalleryData {
  GalleryData({required this.image, required this.url});
  final String image;
  final String url;
  Map toJson() => {'image' : image, "url" : url};
}

class UserData{
  UserData({required this.role, required this.image, required this.id,
    required this.name, required this.salons, this.avatarUrl = ""});
  final String id;
  final String name;
  final String image;
  final String role;
  int all = 0;
  int unread = 0;
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? listen;

  String avatarUrl;
  final List<String> salons;
  factory UserData.fromJson(String id, Map<String, dynamic> data){
    List<String> _salons = [];
    if (data['salons'] != null)
      for (dynamic key in data['salons'])
        _salons.add(key);
    return UserData(
      id: id,
      name : (data["name"] != null) ? data["name"]: "",
      image : (data["avatar"] != null) ? data["avatar"]: "",
      role : (data["role"] != null) ? data["role"]: "",
      salons: _salons,
    );
  }
}

List<Salon> salons = [];
List<EmployeeData> employee = [];
List<CategoryData> category = [];
List<WorkData> work = [];

bool employeeLoaded = false;
bool categoryLoaded = false;

String appname = "";
int timeSlot = 15;
String code = "";
String symbol = "";
String distanceUnit = "km";
String _timeFormat = "24h";
String dateFormat = "yyyy.MM.dd";
String googleMapApiKey = "";
bool googleMapEnable = false;
int digitsAfterComma = 0;
bool rightSymbol = false;
String cloudKey = "";
bool otpEnable = false;
String otpPrefix = "";
int otpNumber = 100;
String googlePlayLink = "";
String appStoreLink = "";

//
String copyright = "";
String policy = "";
String terms = "";
String about = "";
//
bool darkMode = false;
String salonSort = "";
bool initDistance = false;

String getDistanceStringFromDouble(double distance){
  if (distanceUnit == "km")
    return "${(distance/1000).toStringAsFixed(3)} $distanceUnit";
  return "${(distance/1609.344).toStringAsFixed(3)} $distanceUnit";
}

setSalonSort(int code) async {
  var text = "";
  if (code == 2)
    text = "nameAZ";
  if (code == 3)
    text = "nameZA";
  if (code == 4) {
    text = "nearMe";
    await getSalonsDistances();
  }
  log("setSalonSort text=$text");
  salonSort = text;
  pref.set(Pref.salonSort, salonSort);
  salons.sort((a, b) => a.compareTo(b));
}

getTimeFormat(){
  if (_timeFormat == "12h")
    return 'hh:mm a';
  return 'HH:mm';
}

getPriceString(double price){
  //print("_getPriceString price=$price");
  if (rightSymbol)
    return "$symbol${price.toStringAsFixed(digitsAfterComma)}";
  return "${price.toStringAsFixed(digitsAfterComma)}$symbol";
}

loadMainData(Function() callback, Function() callbackError){
  salonSort = pref.get(Pref.salonSort);
  log("loadMainData salonSort=$salonSort");
  FirebaseFirestore.instance.collection("employee")
      .get().then((querySnapshot) async {
    employeeLoaded = true;
    employee = [];
    for (var result in querySnapshot.docs){
      var t = result.data();
      print("image = ${t["image"]}");
      var _image = "";
      if (t["image"] != "")
        _image = await FirebaseStorage.instance.ref(t["image"]).getDownloadURL();
      FirebaseFirestore.instance.collection("appointment").where("employee_id", isEqualTo: result.id).where("status", isEqualTo: "complete")
          .get().then((querySnapshot) async {
        int rating = 0;
        for (var result in querySnapshot.docs){
          var t = result.data();
          int y = t["rate"];
          rating += y;
        }
        List<String> _works = [];
        if (t['works'] != null){
          List.from(t['works']).forEach((element){
            _works.add(element["id"]);
          });
        }
        List<DateTime> _weekend = [];
        if (t["weekends"] != null){
          List.from(t['weekends']).forEach((element){
            _weekend.add(DateTime.fromMillisecondsSinceEpoch(element));
          });
        }
        employee.add(EmployeeData(result.id, t["name"], t["desc"], t["board"], Color(int.parse(t["board_color"])),
            _image, rating/querySnapshot.size, querySnapshot.size, _works, _weekend));
        print("rating = ${rating/querySnapshot.size}");
        callback();
      }).catchError((ex){
        print(ex.toString());
        callbackError();
      });
    }
  }).catchError((ex){
    print(ex.toString());
    callbackError();
  });
  //
  _loadCategory(callback, callbackError);
  _loadWorks(callback, callbackError);
  _settings(callback, callbackError);
  loadOffers(callback, callbackError);
  loadSalons(callback, callbackError);
}

_loadCategory(Function() callback, Function() callbackError){
  FirebaseFirestore.instance.collection("category")
      .get().then((querySnapshot) async {
    categoryLoaded = true;
    category = [];
    for (var result in querySnapshot.docs){
      var t = result.data();
      print("image = ${t["image"]}");
      var _image = "";
      if (t["image"] != "")
        _image = await FirebaseStorage.instance.ref(t["image"]).getDownloadURL();
      category.add(CategoryData(result.id, t["name"], t["visible"], t["board"], Color(int.parse(t["board_color"])), _image));
    }
    callback();
  }).catchError((ex){
    print(ex.toString());
    callbackError();
  });
}

_loadWorks(Function() callback, Function() callbackError){
  FirebaseFirestore.instance.collection("work").get().then((querySnapshot) async {
    work = [];
    for (var result in querySnapshot.docs){
      var t = result.data();
      work.add(WorkData(result.id, t["name"], t["desc"], t["visible"], t["duration"], t["price"], toDouble(t["price"]), t["categoryId"]));
    }
  }).catchError((ex){
    callbackError();
  });
}

bool stripe = false;
bool razorpay = false;
bool paypal = false;
String stripePKey = "";
String stripeSKey = "";
String payPalSKey = "";
String payPalClient = "";
String razorpayCompanyName = "";
String razorpayKeyId = "";

_settings(Function() callback, Function() callbackError){
  FirebaseFirestore.instance.collection("settings").doc("main")
      .get().then((querySnapshot) {
    if (querySnapshot.exists){
      print("settings: ${querySnapshot.data()}");
      if (querySnapshot.data()!["appname"] != null)
        appname = querySnapshot.data()!["appname"];
      if (querySnapshot.data()!["code"] != null)
        code = querySnapshot.data()!["code"];
      if (querySnapshot.data()!["symbol"] != null)
        symbol = querySnapshot.data()!["symbol"];
      if (querySnapshot.data()!["distance_unit"] != null)
        distanceUnit = querySnapshot.data()!["distance_unit"];
      if (querySnapshot.data()!["time_format"] != null)
        _timeFormat = querySnapshot.data()!["time_format"];
      if (querySnapshot.data()!["date_format"] != null)
        dateFormat = querySnapshot.data()!["date_format"];
      if (querySnapshot.data()!["google_map_apikey"] != null)
        googleMapApiKey = querySnapshot.data()!["google_map_apikey"];
      if (querySnapshot.data()!["google_map_enable"] != null)
        googleMapEnable = querySnapshot.data()!["google_map_enable"];
      if (querySnapshot.data()!["digits_after_comma"] != null)
        digitsAfterComma = int.parse(querySnapshot.data()!["digits_after_comma"]);
      if (querySnapshot.data()!["right_symbol"] != null)
        rightSymbol = querySnapshot.data()!["right_symbol"];
      if (querySnapshot.data()!["time_slot"] != null)
        timeSlot = int.parse(querySnapshot.data()!["time_slot"]);
      if (querySnapshot.data()!["cloud_key"] != null)
        cloudKey = querySnapshot.data()!["cloud_key"];
      if (querySnapshot.data()!["OTPEnable"] != null)
        otpEnable = querySnapshot.data()!["OTPEnable"];
      if (querySnapshot.data()!["otpPrefix"] != null)
        otpPrefix = querySnapshot.data()!["otpPrefix"];
      if (querySnapshot.data()!["otpNumber"] != null)
        otpNumber = querySnapshot.data()!["otpNumber"];
      if (querySnapshot.data()!["googlePlayLink"] != null)
        googlePlayLink = querySnapshot.data()!["googlePlayLink"];
      if (querySnapshot.data()!["appStoreLink"] != null)
        appStoreLink = querySnapshot.data()!["appStoreLink"];
      // documents
      if (querySnapshot.data()!["copyright"] != null)
        copyright = querySnapshot.data()!["copyright"];
      if (querySnapshot.data()!["policy"] != null)
        policy = querySnapshot.data()!["policy"];
      if (querySnapshot.data()!["about"] != null)
        about = querySnapshot.data()!["about"];
      if (querySnapshot.data()!["terms"] != null)
        terms = querySnapshot.data()!["terms"];
      // payments gateway
      if (querySnapshot.data()!["stripe_key"] != null)
        stripePKey = querySnapshot.data()!["stripe_key"];
      if (querySnapshot.data()!["stripe_secret_key"] != null)
        stripeSKey = querySnapshot.data()!["stripe_secret_key"];
      if (querySnapshot.data()!["paypal_secret_key"] != null)
        payPalSKey = querySnapshot.data()!["paypal_secret_key"];
      if (querySnapshot.data()!["paypal_client_id"] != null)
        payPalClient = querySnapshot.data()!["paypal_client_id"];
      if (querySnapshot.data()!["razorpay_name"] != null)
        razorpayCompanyName = querySnapshot.data()!["razorpay_name"];
      if (querySnapshot.data()!["razorpay_key"] != null)
        razorpayKeyId = querySnapshot.data()!["razorpay_key"];
      if (querySnapshot.data()!["stripe_enable"] != null)
        stripe = querySnapshot.data()!["stripe_enable"];
      if (querySnapshot.data()!["razorpay_enable"] != null)
        razorpay = querySnapshot.data()!["razorpay_enable"];
      if (querySnapshot.data()!["paypal_enable"] != null)
        paypal = querySnapshot.data()!["paypal_enable"];
      callback();
    }
  });
}

