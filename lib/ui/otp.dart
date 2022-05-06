import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/widgets/edit/edit24otp.dart';
import 'package:FisioLago/widgets/edit/edit29.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import '../main.dart';
import 'main.dart';

class OTPScreen extends StatefulWidget {
  final Function(String, PhoneAuthCredential?) callback;

  const OTPScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  var windowWidth;
  var windowHeight;
  var _controllerPhone = TextEditingController();
  bool _needDelete = true;

  @override
  void dispose() {
    _controllerPhone.dispose();
    if (_needDelete) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null)
        user.delete();
    }
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

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, strings.get(103), //  OTP verification
                context, () {Navigator.pop(context);}),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    if (verificationId.isNotEmpty)
      list.add(Edit29(color: Colors.orange, callback: _otp));
    else{
      _item(list, strings.get(104), // "Phone number",
          strings.get(105), // "Enter your phone number",
          _controllerPhone, TextInputType.text);

      list.add(SizedBox(height: 20,));
      list.add(Container(
          margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 10),
          child: button2(strings.get(106), // "Send Code",
              barberMainColor, 10, _sendcode, true)));
    }

    return list;
  }

  _otp(String code) async {
    if (code.length != 6)
      return;
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    User? user = FirebaseAuth.instance.currentUser;
    user!.linkWithCredential(_credential).then((user) {
      print("linkWithCredential =${user.user!.uid}");
      _needDelete = false;
      Navigator.pop(context);
      widget.callback(_controllerPhone.text, _credential);
    }).catchError((error) {
      print(error.toString());
      _message(error.toString());
    });
  }

  _item(List<Widget> list, String text1, String text2, TextEditingController _controller, TextInputType _type){
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.08, right: windowWidth*0.08, bottom: 3),
      child: Text(text1, style: TextStyle(color: Colors.grey),),));

    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 20),
      child: Row(
        children: [
          Text(otpPrefix, style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(width: 5,),
          Expanded(child: Edit24OTP(
            type: _type,
            hint: text2,
            color: Colors.grey,
            radius: 10,
            controller: _controller,
          ),)
        ],
      )));
  }

  _message(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.blue,
        content: Text(msg,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
  }


  String _checkPhoneNumber(String _phoneText){
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

  String verificationId = "";

  _sendcode() async {
    if (_controllerPhone.text.isEmpty)
      return _message(strings.get(105)); // "Enter your phone number",

    var _phoneNumber = _checkPhoneNumber("$otpPrefix${_controllerPhone.text}");
    if (_phoneNumber.length != otpPrefix.length+otpNumber)
      return _message("${strings.get(108)} ${otpPrefix.length+otpNumber} ${strings.get(109)}"); // "Phone number must be xx symbols",

    print(_phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Verification complete. number=$_phoneNumber code=${credential.smsCode}");
        _needDelete = false;
        widget.callback(_phoneNumber, null);
        // _message("Verification complete. number=$_phoneNumber code=${credential.smsCode}");
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
        _message('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
      },
      codeSent: (String _verificationId, int? resendToken) {
        verificationId = _verificationId;
        setState(() {
        });
        print('Code sent. Please check your phone for the verification code. verificationId=$verificationId');
        _message(strings.get(107)); // 'Code sent. Please check your phone for the verification code.'
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Time Out');
        verificationId = "";
        setState(() {
        });
        _message('Time Out');
      },
    ).catchError((Object error){
      _message(error.toString());
    });
  }
}


