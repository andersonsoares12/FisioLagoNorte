import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/loader/loader32.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button134.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'main.dart';
import 'otp.dart';

class BarberCreateAccountScreen extends StatefulWidget {
  final Function(String)? callback;

  const BarberCreateAccountScreen({Key? key, this.callback}) : super(key: key);

  @override
  _BarberCreateAccountScreenState createState() => _BarberCreateAccountScreenState();
}

class _BarberCreateAccountScreenState extends State<BarberCreateAccountScreen> {

  var windowWidth;
  var windowHeight;
  var _controllerName = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _controllerPassword2 = TextEditingController();

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPassword2.dispose();
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

            Center (
              child: ListView(
                shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, strings.get(15), //  "Create New Account",
                context, () {widget.callback!("root");}),

            if (_wait)
              Center(child: Container(child: Loader32())),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    _item(list, strings.get(22), // "Name",
        strings.get(23), // "Enter your full name",
        _controllerName, TextInputType.text);
    _item(list, strings.get(7), // "Email ID",
        strings.get(24), // "Enter your email id",
        _controllerEmail, TextInputType.emailAddress);
    _item(list, strings.get(25), // "Password",
        strings.get(26), // "Enter your Password",
        _controllerPassword, TextInputType.text);
    _item(list, strings.get(27), // "Confirm Password",
        strings.get(26), // "Enter your password",
        _controllerPassword2, TextInputType.text);
    list.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 10),
        child: button2(strings.get(15), // "Create new account",
            barberMainColor, 10, _create, true)));

    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(strings.get(28), // "Already have an account?",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
      button134(strings.get(29), // "LOGIN",
          _login, true,
          TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: barberMainColor)),
      ]
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: RichText(
          textAlign: TextAlign.center,
          maxLines: 2,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: strings.get(30), // "By clicking ",
                style: TextStyle(fontSize: 16, color: Colors.grey),),
              TextSpan(text: strings.get(15), // "Create new account",
                  style: TextStyle(fontSize: 16, color: (darkMode) ? Colors.white : Colors.black)),
              TextSpan(text: strings.get(31), // " you agree to the following",
                style: TextStyle(fontSize: 16, color: Colors.grey),),
            ],
          ),
      )));

    list.add(Container(
      alignment: Alignment.center,
        child: button134(strings.get(32), // "Privacy Policy",
            _terms, true,
        TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black))));

    return list;
  }

  _item(List<Widget> list, String text1, String text2, TextEditingController _controller, TextInputType _type){
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.08, right: windowWidth*0.08, bottom: 3),
      child: Text(text1, style: TextStyle(color: Colors.grey),),));

    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 20),
      child: Edit24(
        type: _type,
        hint: text2,
        color: Colors.grey,
        radius: 10,
        controller: _controller,
      ),));
  }

  _login(){
    widget.callback!("");
  }

  _errorMessage(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: barberMainColor,
        content: Text(msg,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
  }

  bool validateEmail(String value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _create() async {
    if (_controllerName.text.isEmpty)
      return _errorMessage(strings.get(23)); // "Enter your name",
    if (_controllerEmail.text.isEmpty)
      return _errorMessage(strings.get(24)); // "Enter your email id",
    if (_controllerPassword2.text.isEmpty || _controllerPassword2.text.isEmpty)
      return _errorMessage(strings.get(33)); // "Enter password",
    if (_controllerPassword2.text != _controllerPassword2.text)
      return _errorMessage(strings.get(34)); // "Passwords are not equal",
    if (!validateEmail(_controllerEmail.text))
      return _errorMessage(strings.get(34)); // "Email are wrong",

    _waits(true);

    final User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    ).catchError((Object error){
      _waits(false);
      _errorMessage(error.toString());
    })).user;

    // print("createUserWithEmailAndPassword =${user!.uid}");

    if (user != null) {
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "visible": true,
        "phoneVerified": false,
        "email": user.email,
        "phone": "",
        "name": _controllerName.text,
        "date_create" : DateFormat('yyyy.MM.dd').format(DateTime.now())
      }).then((value2) {

        if (otpEnable){
          _waits(false);
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                callback: _finish,
              ),
            ),
          );
        }else
          widget.callback!("registerOrLogin");
      }).catchError((Object error){
        _waits(false);
        _errorMessage(error.toString());
      });
    }
  }


  _finish(String _phone, PhoneAuthCredential? _credential) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("_finish =${user.uid}");
      print("phone number ${user.phoneNumber}");
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "phoneVerified": true,
        "phone": _phone,
        }, SetOptions(merge:true)).then((value2) {
          widget.callback!("registerOrLogin");
        }).catchError((Object error){
        _waits(false);
        _errorMessage(error.toString());
        });
      }
  }

  _terms(){
    widget.callback!("policy");
  }

}


