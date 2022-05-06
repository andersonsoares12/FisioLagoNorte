import 'dart:io';
import 'package:FisioLago/ui/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'data.dart';

Color getColor(String? boardColor){
  if (boardColor == null)
    return Colors.red;
  var t = int.tryParse(boardColor);
  if (t != null)
    return Color(t);
  return Colors.red;
}

messageError(BuildContext context, String _text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: barberMainColor,
      duration: Duration(seconds: 5),
      content: Text(_text,
        style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
}

messageOk(BuildContext context, String _text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: barberMainColor,
      duration: Duration(seconds: 5),
      content: Text(_text,
        style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
}

List<String> bugLog = [];

log(String str){
  if (!kReleaseMode)
    print("---> $str");
  else{
    bugLog.add("\n${DateTime.now()}----> $str");
  }
}

String checkPhoneNumber(String _phoneText){
  String s = "";
  for (int i = 0; i < _phoneText.length; i++) {
    int c = _phoneText.codeUnitAt(i);
    if ((c == "1".codeUnitAt(0)) || (c == "2".codeUnitAt(0)) || (c == "3".codeUnitAt(0)) ||
        (c == "4".codeUnitAt(0)) || (c == "5".codeUnitAt(0)) || (c == "6".codeUnitAt(0)) ||
        (c == "7".codeUnitAt(0)) || (c == "8".codeUnitAt(0)) || (c == "9".codeUnitAt(0)) ||
        (c == "0".codeUnitAt(0)) || (c == "+".codeUnitAt(0))) {
      String h = String.fromCharCode(c);
      s = "$s$h";
    }
  }
  return s;
}

callMobile(String phone) async {
  var uri = "tel:${checkPhoneNumber(phone)}";
  if (await canLaunch(uri))
    await launch(uri);
}

openWebSite(String website) async {
  if (await canLaunch(website))
    await launch(website);
}

openInstagram(String instagram) async {
  if (await canLaunch(instagram))
    await launch(instagram);
}

share() async {
  var code = "";
  if (Platform.isIOS)
    code = appStoreLink;
  if (Platform.isAndroid)
    code = googlePlayLink;
  await Share.share(code,
      subject: strings.get(113), // Share This App,
      sharePositionOrigin: null);
}

/*
  Time in period
  true - if period (periodStart-periodEnd) in range (sourceStart-sourceEnd)
    Example period 10:20-11:50 in source 10:00-10:40 - true
    Example period 10:50-11:50 in source 10:00-10:40 - false
 */
timeInRange(DateTime sourceStart, DateTime sourceEnd, DateTime periodStart, DateTime periodEnd){
  if (periodEnd.isBefore(periodStart)){
    var t = periodEnd;
    periodEnd = periodStart;
    periodStart = t;
  }
  if (sourceEnd.isBefore(sourceStart)){
    var t = sourceEnd;
    sourceEnd = sourceStart;
    sourceStart = t;
  }

  var ret = false;
  if ((periodStart.isAfter(sourceStart) || periodStart.isAtSameMomentAs(sourceStart)) && periodStart.isBefore(sourceEnd)){
    ret = true;
  }else{
    if (periodStart.isBefore(sourceStart) && (periodEnd.isAfter(sourceStart)))
      ret = true;
  }
  log("timeInRange sourceStart=$sourceStart sourceEnd=$sourceEnd periodStart=$periodStart periodEnd=$periodEnd");
  return ret;
}

distance(double lat, double lng) async {
  Position? location = await getCurrentLocation();
  if (location == null)
    return 0;
  return Geolocator.distanceBetween(location.latitude, location.longitude, lat, lng);
}

Future<Position?> getCurrentLocation() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log("getCurrentLocation permission denied");
      return null;
    }
  }
  return await getCurrent();
}

Future<Position> getCurrent() async {
  Position _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
      .timeout(Duration(seconds: 10));
  log("MyLocation::_currentPosition $_currentPosition");
  return _currentPosition;
}

int toInt(String str){
  int ret = 0;
  try {
    ret = int.parse(str);
  }catch(_){}
  return ret;
}

double toDouble(String str){
  double ret = 0;
  try {
    ret = double.parse(str);
  }catch(_){}
  return ret;
}
