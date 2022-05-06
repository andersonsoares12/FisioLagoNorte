// user
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'notification.dart';

class Points{
  String salonId;
  int points;
  Points(this.salonId, this.points);

  Map toJson() => {
    'salon' : salonId,
    'points' : points,
  };
}

String userEmail = "";
String userName = "";
String userPhone = "";
String userAvatar = "";

List<Points> allPoints = [];

int userGetPoints(String salonId){
  for (var item in allPoints)
    if (item.salonId == salonId)
      return item.points;
  return 0;
}

userAddPoints(String salonId, int points){
  if (points == 0)
    return;
  var _totalPoints = 0;
  bool _found = false;
  for (var item in allPoints)
    if (item.salonId == salonId) {
      item.points += points;
      _totalPoints = item.points;
      _found = true;
    }
  if (!_found)
    allPoints.add(Points(salonId, points));
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "points": allPoints.map((i) => i.toJson()).toList(),
    }, SetOptions(merge: true)).then((value2) {});
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).collection("points").add({
      "operation": "add",
      "salon": salonId,
      "points": points,
      "total" : _totalPoints,
      "time": FieldValue.serverTimestamp(),
    }).then((value2) {});
  }
}

userSubPoints(String salonId, int points){
  if (points == 0)
    return;
  var _totalPoints = 0;
  bool _found = false;
  for (var item in allPoints)
    if (item.salonId == salonId) {
      item.points -= points;
      _totalPoints = item.points;
      _found = true;
    }
  if (!_found)
    return;
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "points": allPoints.map((i) => i.toJson()).toList(),
    }, SetOptions(merge: true)).then((value2) {});
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).collection("points").add({
      "operation": "sub",
      "salon": salonId,
      "points": points,
      "total" : _totalPoints,
      "time": FieldValue.serverTimestamp(),
    }).then((value2) {});
  }
}

logout() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null)
    FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
      "FCB": "",
    }, SetOptions(merge:true)).then((value2) {});
  await FirebaseAuth.instance.signOut();
  userEmail = "";
  userName = "";
  userPhone = "";
  userAvatar = "";
  allPoints = [];
}
//

userListen(Function() _redraw, BuildContext context, Function(int) _setUnread){
  FirebaseAuth.instance
      .userChanges()
      .listen((User? user) {
    if (user == null) {
      log('Main User is currently signed out!');
    } else {
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
        if (querySnapshot.exists){
          var t = querySnapshot.data()!["visible"];
          if (t != null)
            if (!t){
              log("User not visible. Exit...");
              FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
                "FCB": "",
              }, SetOptions(merge:true)).then((value2) {});
              await FirebaseAuth.instance.signOut();
              return _redraw();
            }
        }
      });
      log('Main User is signed in!');
      firebaseInitApp(context);
      firebaseGetToken(context);
      FirebaseFirestore.instance.collection("messages")
          .where('user', isEqualTo: user.uid).where("read", isEqualTo: false )
          .get().then((querySnapshot) {
        _setUnread(querySnapshot.size);
      });

      log("user.email=${user.email}");
      if (user.email != null)
        userEmail = user.email!;
      log("user phone = ${user.phoneNumber}");
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
        log("querySnapshot.exists=${querySnapshot.exists}");
        allPoints = [];
        if (querySnapshot.exists){
          var data = querySnapshot.data()!;
          userName = (data["name"]  != null) ? data["name"] : "";
          userPhone = (data["phone"]  != null) ? data["phone"] : "";
          userAvatar = (data["avatar"]  != null) ? data["avatar"] : "";
          if (userAvatar.isNotEmpty) {
            userAvatar = await FirebaseStorage.instance.ref(userAvatar).getDownloadURL();
            log("_avatar=$userAvatar");
          }
          if (data['points'] != null)
            List.from(data['points']).forEach((element){
              allPoints.add(Points(element["salon"], element["points"]));
            });
          _redraw();
        }
      });
    }
  });
}

