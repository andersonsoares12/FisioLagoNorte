import 'dart:async';
import 'package:FisioLago/ui/login.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/ui/register.dart';
import 'package:FisioLago/ui/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'model/data.dart';
import 'model/langs/lang.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await pref.init();

  if (pref.get(Pref.dark) == "true")
    darkMode = true;
  else
    darkMode = false;

  var email = pref.get(Pref.email);
  var password = pref.get(Pref.password);
  if (email.isNotEmpty && password.isNotEmpty){
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,);
      print("login ok");
  }
  runZonedGuarded(() {
    runApp(FisioLago());
  }, (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

var pref = Pref();

Lang strings = Lang();

class FisioLago extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var id = pref.get(Pref.language);
    var lid = Lang.portugal;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - portugues

    return MaterialApp(
      title: strings.get(1),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Tajawal",
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/barber_start',
      // initialRoute: '/login',
      routes: {
        '/barber_start': (BuildContext context) => BarberSplashScreen(),
        '/barber_main': (BuildContext context) => BarberMainScreen(),
        '/barber_login': (BuildContext context) => BarberLoginScreen(callback: (String _){}),
        '/barber_createAccount': (BuildContext context) => BarberCreateAccountScreen(),
      },
    );
  }
}

