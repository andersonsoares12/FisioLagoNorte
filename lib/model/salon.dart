import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data.dart';
import 'util.dart';

class Salon {
  Salon({required this.id, required this.name, required this.address,
    required this.lat, required this.lng, required this.desc, required this.image,
    this.imageUrl = "", required this.board, required this.color, required this.phone,
    required this.openTime, required this.closeTime, required this.weekend1,
    required this.weekend2, required this.weekend3, required this.weekend4,
    required this.weekend5, required this.weekend6, required this.weekend7,
    required this.instagram, required this.website, required this.works, required this.employee,
    required this.gallery, this.distance = 0,
    required this.loyaltyEnable, required this.points, required this.loyaltyInPercentages});
  final String id;
  String name;
  String address;
  double lat;
  double lng;
  String desc;
  String board;
  Color color;
  String image;
  String imageUrl;
  String openTime;
  String closeTime;
  bool weekend1;
  bool weekend2;
  bool weekend3;
  bool weekend4;
  bool weekend5;
  bool weekend6;
  bool weekend7;
  String phone;
  String instagram;
  String website;
  List<String> works;
  List<String> employee;
  List<String> gallery;
  Marker? marker;
  double distance;
  bool loyaltyEnable;
  int points;
  bool loyaltyInPercentages;

  factory Salon.fromJson(String id, Map<String, dynamic> data){
    List<String> _works = [];
    if (data['works'] != null)
      for (dynamic key in data['works'])
        _works.add(key);
    List<String> _employee = [];
    if (data['employee'] != null)
      for (dynamic key in data['employee'])
        _employee.add(key);
    List<String> _gallery = [];
    if (data['gallery_images'] != null)
      for (dynamic key in data['gallery_images'])
        _gallery.add(key["url"]);
    log("Salon.fromJson ${data["name"]} _employee=$_employee");
    return Salon(
      id: id,
      phone : (data["phone"] != null) ? data["phone"]: "",
      name : (data["name"] != null) ? data["name"]: "",
      address : (data["address"] != null) ? data["address"]: "",
      lat : (data["lat"] != null) ? toDouble(data["lat"]) : 0,
      lng : (data["lng"] != null) ? toDouble(data["lng"]) : 0,
      desc : (data["desc"] != null) ? data["desc"]: "",
      image : (data["image"] != null) ? data["image"]: "",
      board : (data["board"] != null) ? data["board"]: "",
      color : getColor(data["board_color"]),
      openTime : (data["open_time"] != null) ? data["open_time"]: "",
      closeTime : (data["close_time"] != null) ? data["close_time"]: "",
      weekend1 : (data["weekend1"] != null) ? data["weekend1"]: false,
      weekend2 : (data["weekend2"] != null) ? data["weekend2"]: false,
      weekend3 : (data["weekend3"] != null) ? data["weekend3"]: false,
      weekend4 : (data["weekend4"] != null) ? data["weekend4"]: false,
      weekend5 : (data["weekend5"] != null) ? data["weekend5"]: false,
      weekend6 : (data["weekend6"] != null) ? data["weekend6"]: false,
      weekend7 : (data["weekend7"] != null) ? data["weekend7"]: false,
      instagram : (data["instagram"] != null) ? data["instagram"]: "",
      website : (data["website"] != null) ? data["website"]: "",
      works: _works,
      employee: _employee,
      gallery: _gallery,
      loyaltyEnable : (data["loyaltyEnable"] != null) ? data["loyaltyEnable"]: false,
      points : (data["points"] != null) ? data["points"]: 0,
      loyaltyInPercentages : (data["loyaltyInPercentages"] != null) ? data["loyaltyInPercentages"]: false,
    );
  }

  int compareTo(Salon b){
    if (salonSort == "nearMe")
      return distance.compareTo(b.distance);
    if (salonSort == "nameAZ")
      return b.name.compareTo(name);
    if (salonSort == "nameZA")
      return name.compareTo(b.name);
    return 1;
  }
}


loadSalons(Function() callback, Function() callbackError){
  initDistance = false;
  log("loadSalons");
  FirebaseFirestore.instance.collection("salons").get()
      .then((querySnapshot) async {
    salons = [];
    querySnapshot.docs.forEach((result) {
      var data = result.data();
      log("loadSalons name=${data["name"]}");
      salons.add(Salon.fromJson(result.id, data));
    });
    salons.sort((a, b) => a.compareTo(b));
    if (salonSort == "nearMe")
      await getSalonsDistances();
    callback();
    await _downloadURL();
    callback();
  });
}

Future<void> _downloadURL() async {
  for (var item in salons){
    log("get image address ${item.image}");
    if (item.image.isNotEmpty)
      item.imageUrl = await FirebaseStorage.instance.ref(item.image).getDownloadURL();
  }
}

getSalonsDistances() async {
  if (!initDistance) {
    initDistance = false;
    for (var item in salons)
      item.distance = await distance(item.lat, item.lng);
  }
}
