import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/appbars/appbar2.dart';
import 'package:FisioLago/widgets/buttons/button134.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:FisioLago/widgets/edit/edit25.dart';

import '../main.dart';
import 'main.dart';

class BarberLoginScreen extends StatefulWidget {
  final Function(String) callback;
  const BarberLoginScreen({Key? key, required this.callback}) : super(key: key);
  @override
  _BarberLoginScreenState createState() => _BarberLoginScreenState();
}

class _BarberLoginScreenState extends State<BarberLoginScreen> {

  var windowWidth;
  var windowHeight;
  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );

  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

            Stack(
              children: [
                Container(
                    height: 200,
                    width: 400,
                  padding: EdgeInsets.fromLTRB(80,30,0,0),
                    child: Image.asset("assets/barber/1.jpg",
                        fit: BoxFit.scaleDown
                    )),
                ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          height: windowHeight,
                          width: windowWidth,
                          decoration: new BoxDecoration(
                              //color: Colors.white.withOpacity(0.5)
                          ),))
                )

              ],
            ),

            Container(

              padding: EdgeInsets.fromLTRB(5, 100, 5, 0),
              margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  Edit24(
                    hint: strings.get(7), // "Email ID",
                    color: Colors.grey,
                    radius: 10,
                    controller: _controllerEmail,
                  ),
                  SizedBox(height: 10,),
                  Edit25(
                    hint: strings.get(8), // "Password",
                    color: Colors.grey,
                    radius: 10,
                    controller: _controllerPassword,
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: button134(strings.get(9), // "Forgot password ?",
                        _forgot, true,
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.grey)),
                  ),
                  SizedBox(height: 10,),
                  button2(strings.get(10), // "Login",
                      barberMainColor, 10, _login, true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(strings.get(11), // "Don't have an account?",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.grey),),
                    button134(strings.get(12), // "Signup",
                        _signup, true,
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: barberMainColor)),
                  ],)

                ],
              ),
            )),

            appbar2(Colors.transparent, Colors.black, "", Icons.arrow_back, context, (){
              widget.callback("root");
            })

          ],
        )

    );
  }

  _signup(){
    widget.callback("createAccount");
  }

  _forgot(){
    widget.callback("forgot");
  }

  _errorMsg(String str){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: barberMainColor,
        content: Text(str,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
  }

  _login() async {
    if (_controllerEmail.text.isEmpty)
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: barberMainColor,
          content: Text(strings.get(13), // "Enter Email ID"
            style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));

    if (_controllerPassword.text.isEmpty)
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: barberMainColor,
          content: Text(strings.get(14), // "Enter Password"
            style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));

    User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,).catchError((Object error){
               _errorMsg(error.toString());
        })).user;

    if (user != null) {
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
        if (querySnapshot.exists){
          var t = querySnapshot.data()!["visible"];
          if (t != null)
            if (!t){
              print("User not visible. Don't enter...");
              FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
                "FCB": "",
              }, SetOptions(merge:true)).then((value2) {});
              await FirebaseAuth.instance.signOut();
              setState(() {
              });
              return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  backgroundColor: barberMainColor,
                  content: Text(strings.get(55), // "User is disabled. Connect to Administrator for more information."
                    style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
            }
          widget.callback("registerOrLogin");
        }
      });
      // pref.set(Pref.email, _controllerEmail.text);
      // pref.set(Pref.password, _controllerEmail.text);

    }
  }

}


