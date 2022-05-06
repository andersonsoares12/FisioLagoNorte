import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/loader/loader1.dart';

class BarberSplashScreen extends StatefulWidget {
  @override
  _BarberSplashScreenState createState() => _BarberSplashScreenState();
}

class _BarberSplashScreenState extends State<BarberSplashScreen> {

  _startNextScreen(){
    Navigator.pushNamedAndRemoveUntil(context, "/barber_main", (r) => false);
  }

  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                    height: windowHeight,
                    width: windowWidth,
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
                              //color: Colors.greenAccent.withOpacity(0.0)
                          ),))
                )

              ],
              alignment: Alignment.center,
            ),


          Center(
            child: loader1(40, Colors.green, Colors.white),
            ),

          ],
        )

    );
  }

}


