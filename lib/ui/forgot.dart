import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:FisioLago/widgets/loader/loader32.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'main.dart';

class BarberForgotScreen extends StatefulWidget {
  final Function(String)? callback;

  const BarberForgotScreen({Key? key, this.callback}) : super(key: key);

  @override
  _BarberForgotScreenState createState() => _BarberForgotScreenState();
}

class _BarberForgotScreenState extends State<BarberForgotScreen> {

  var windowWidth;
  var windowHeight;

  var _controllerEmail = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
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

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, strings.get(9), // "Forgot password ?",
                context, () {widget.callback!("login");}),

            if (_wait)
              Center(child: Container(child: Loader32())),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    list.add(Container(
      alignment: Alignment.center,
      //margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 10),
      child: Icon(Icons.mark_email_read_outlined, size: windowWidth/4, color: Colors.grey,)
    ));

    list.add(SizedBox(height: 50,));

    list.add(Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 10),
      child: Text(strings.get(16), // "Email Verification!",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
    ));

    list.add(Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 3),
      child: Text(strings.get(17), // "Don't worry, we will find your account",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black),),
    ));

    list.add(SizedBox(height: 30,));

    _item(list, strings.get(7), // "Email ID"
        strings.get(18), // "Enter your email id",
        _controllerEmail);

    list.add(SizedBox(height: 10,));

    list.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 10),
        child: button2(strings.get(20), // "Send",
            barberMainColor, 10, _next, true)));

    list.add(Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: windowWidth*0.2, right: windowWidth*0.2, bottom: 3),
      child: Text(strings.get(19), // "Please check your email we will send you one OTP on you email.",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),),
    ));

    return list;
  }

  _item(List<Widget> list, String text1, String text2, TextEditingController _controller){
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.12, right: windowWidth*0.12, bottom: 3),
      child: Text(text1, style: TextStyle(color: Colors.grey),),));

    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 20),
      child: Edit24(
        hint: text2,
        color: Colors.grey,
        radius: 10,
        controller: _controller,
      ),));
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _next() async {
    _waits(true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text);
    _waits(false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: barberMainColor,
        duration: Duration(seconds: 5),
        content: Text(strings.get(21), // "Reset password email sended. Please check your mail."
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
    //widget.callback!("");
  }
}


