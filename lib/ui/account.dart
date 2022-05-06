import 'dart:io';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/user.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/cards/card22.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import 'main.dart';

class BarberAccountScreen extends StatefulWidget {
  final Function(String)? callback;
  final Function() redraw;

  const BarberAccountScreen({Key? key, this.callback, required this.redraw}) : super(key: key);
  @override
  _BarberAccountScreenState createState() => _BarberAccountScreenState();
}

class _BarberAccountScreenState extends State<BarberAccountScreen> {

  var windowWidth;
  var windowHeight;
  var _controllerName = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerPhone = TextEditingController();
  var _controllerNewPassword = TextEditingController();
  var _controllerNew2Password = TextEditingController();

  @override
  void initState() {
    _controllerEmail.text = userEmail;
    _controllerName.text = userName;
    _controllerPhone.text = userPhone;
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerEmail.dispose();
    _controllerNewPassword.dispose();
    _controllerNew2Password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 10),
              child: ListView(
              children: _getList(),
            ),),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    list.add(card22(Color(0xFF225C3C), barberMainColor, _photo, userAvatar));

    list.add(SizedBox(height: 30,));

    if (allPoints.isNotEmpty){
      list.add(Text(strings.get(136).toUpperCase(), // Your points
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),));
      list.add(SizedBox(height: 10,));
      for (var item in allPoints){
        for (var salon in salons)
          if (salon.id == item.salonId){
            list.add(Row(
              children: [
                Expanded(child: Text(salon.name, // Points
                  style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black),)),
                Text(item.points.toString(), // Points
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF225C3C)),)
              ],
            ));
          }
        list.add(SizedBox(height: 10,));
      }
    }

    list.add(SizedBox(height: 30,));

    list.add(Text(strings.get(45), // "Personal Info",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
    );
    list.add(SizedBox(height: 10,));

    _item(list, strings.get(46), // "Edit Your Name",
        "", _controllerName);
    _item(list, strings.get(47), // "Edit Your Email",
        "", _controllerEmail);
    _item(list, strings.get(48), // "Edit Your Contact number",
        "", _controllerPhone);

    list.add(button2(strings.get(49), // "Change Info",
        Color(0xFF225C3C), 10, _changeInfo, true));

    list.add(SizedBox(height: 30,));

    list.add(Text(strings.get(38), // "Change Password",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
    );
    list.add(SizedBox(height: 10,));

    _item(list, strings.get(41), // "New Password",
        strings.get(42), // "Enter New Password",
        _controllerNewPassword);
    _item(list, strings.get(43), // "Confirm Password",
        strings.get(44), // "Enter Confirm Password",
        _controllerNew2Password);

    list.add(button2(strings.get(38), // "Change Password",
        Color(0xFF225C3C), 10, _changePassword, true));
    list.add(SizedBox(height: 10,));
    list.add(button2(strings.get(37), // "Log Out",
        Color(0xFF225C3C), 10, () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null)
        FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
          "FCB": "",
        }, SetOptions(merge:true)).then((value2) {});
      await FirebaseAuth.instance.signOut();
      widget.redraw();
    }, true));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _item(List<Widget> list, String text1, String text2, TextEditingController _controller){
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.02, right: windowWidth*0.02, bottom: 3),
      child: Text(text1, style: TextStyle(color: Colors.grey),),));

    list.add(Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Edit24(
        hint: text2,
        color: Colors.grey,
        radius: 10,
        controller: _controller,
      ),));

    return list;
  }

  _errorMsg(String str){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: barberMainColor,
        content: Text(str,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
  }

  _changePassword(){
    if (_controllerNewPassword.text.isEmpty)
      return _errorMsg(strings.get(14)); // "Enter Password"
    if (_controllerNew2Password.text.isEmpty)
      return _errorMsg(strings.get(39)); // "Enter Confirm Password"
    if (_controllerNewPassword.text != _controllerNew2Password.text)
      return _errorMsg(strings.get(34)); // "Passwords are not equal",

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
        user.updatePassword(_controllerNewPassword.text).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: barberMainColor,
              duration: Duration(seconds: 5),
              content: Text(strings.get(40), // "Password changed"
                style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
        }).catchError(
            (Object error){
              _errorMsg(error.toString());
            }
        );
    }
  }

  _changeInfo(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      user.updateEmail(_controllerEmail.text);
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "name": _controllerName.text,
        "phone": _controllerPhone.text,
        "email": user.email
      }, SetOptions(merge:true)).then((value2) {
        userName = _controllerName.text;
        userPhone = _controllerPhone.text;
        if (user.email != null)
          userEmail = user.email!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: barberMainColor,
            duration: Duration(seconds: 5),
            content: Text(strings.get(50), // "Data saved"
              style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
      }).catchError((Object error){
        _errorMsg(error.toString());
      });

    }
  }

  _photo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await ImagePicker().getImage(
          maxWidth: 200,
          maxHeight: 200,
          source: ImageSource.camera);
      if (pickedFile != null) {
        print("Photo file: ${pickedFile.path}");
        // load to storage
        String _name = await _imageUpload(pickedFile.path);
        // save avatar file name
        print("save avatar = $_name");
        if (_name.isNotEmpty)
            FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
              "avatar": _name,
            }, SetOptions(merge:true)).then((value2) {}).catchError((Object error) {
              _errorMsg(error.toString());
            });
        setState(() {});
      }
    }
  }

  Future<String> _imageUpload(String _imageFile) async {
    var f = Uuid().v4();
    var name = "avatar/$f.jpg";
    try{
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null)
        return "";
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
      TaskSnapshot s = await firebaseStorageRef.putFile(File(_imageFile));
      userAvatar = await s.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return "";
    }
    return name;
  }
}


