import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/user.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/appbars/appbar30.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/dialog/easyDialog2.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:FisioLago/widgets/slider/slider3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/ui/register.dart';
import 'package:FisioLago/ui/terms.dart';
import 'package:FisioLago/widgets/menu/menu1.dart';
import '../main.dart';
import '../model/notification.dart';
import 'account.dart';
import 'package:FisioLago/widgets/bottom/bottom5.dart';
import 'addLocation.dart';
import 'appo.dart';
import 'appointment0.dart';
import 'catdetails.dart';
import 'chat.dart';
import 'details.dart';
import 'forgot.dart';
import 'home.dart';
import 'invite.dart';
import 'lang.dart';
import 'login.dart';
import 'main2.dart';
import 'map.dart';
import 'notify.dart';

///teste conexao
const String SERVER_ADDRESS = "https://demo.freaktemplate.com/bookappointment";

Color barberMainColor = Color(0xFF225C3C);
Color barberCompanionColor = Color(0xFF94BF5D);
Color barberColorError = Color(0xff09662B);
Color especialistaNaoAtende = Colors.red;
Color corVerdeClaro = Color(0xFF225C3C);
Color white = Colors.white;
Color black = Colors.black;
Color amber = Colors.amber.shade700;

class BarberMainScreen extends StatefulWidget {
  @override
  _BarberMainScreenState createState() => _BarberMainScreenState();
}

class _BarberMainScreenState extends State<BarberMainScreen> {

  var windowWidth;
  var windowHeight;
  int _currentPage = 2;
  var _termsBackRoute = "createAccount";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _numberOfUnreadMessages = 0;
  var _controllerReview = TextEditingController();

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _controllerReview.dispose();
    super.dispose();
  }

  int _chatCount = 0;
  _chatCallback(){
    _chatCount++;
    _redraw();
  }

  @override
  void initState() {
    setChatCallback(_chatCallback);
    loadMainData(
      (){_redraw();},
      (){_redraw();}
    );

    setNotifyCallback((RemoteMessage message){
      log("message.notification=${message.notification!.title}");
      if (message.notification != null) {
        log("setNotifyCallback ${message.notification!.title}");
        if (_currentPage != 3) {
          _numberOfUnreadMessages++;
          log("_numberOfUnreadMessages=$_numberOfUnreadMessages");
        }else
          if (loadMessagesFunc != null)
            loadMessagesFunc!();
        _redraw();
      }
    });

    userListen((){_redraw();}, context, (int _unread){
      _numberOfUnreadMessages = _unread;
      _redraw();
      log("_numberOfUnreadMessages=$_numberOfUnreadMessages");
    });

    super.initState();
  }

  bool _transparent = true;
  _redrawAppBar(double val){
    if (val > windowWidth*0.65)
      _transparent = false;
    else
      _transparent = true;
    _redraw();
    //log("_appValue=$val");
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Future<Null> _handleRefresh() async{
    _refreshIndicatorKey.currentState!.deactivate();
    loadMainData(
            (){_redraw();},
            (){_redraw();}
    );
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    var _title = strings.get(3); // "Home"
    if (_currentPage == 0)
      _title = strings.get(4); // "Appointment";
    if (_currentPage == 1)
      _title = strings.get(2); // "Our Location";
    if (_currentPage == 3) {
      _title = strings.get(5); // "Messages";
      _numberOfUnreadMessages = 0;
    }
    if (_currentPage == 4)
      _title = strings.get(6); // "Account";
    //log("build Main - _title=$_title _currentPage=$_currentPage");
    return WillPopScope(
        onWillPop: () async {
          if (_state == "addLocation"){
            _state = "";
            setState(() {
            });
            return false;
          }
          if (_state.isNotEmpty){
            _state = "";
            setState(() {
            });
            return false;
          }
          _state = "";
          if(_currentPage != 2){
            _currentPage = 2;
            setState(() {
            });
            return false;
          }

          // Navigator.pop(context);
      return true;
    },
    child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu1(context: context, callback: _routeMenu1, data: menu1,),
        //endDrawer: Menu2(context, menu2, onPressCheck: (String id, bool checkValue){
        //   print("Menu check pressed: id=$id value=$checkValue");
        // }),
      backgroundColor: Colors.white,
        body: Directionality(
          textDirection: strings.direction,
          child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: Stack(
          children: <Widget>[

            if (_currentPage == 0)                                              // Appointment
              BarberAppoScreen(callback: _route, openDialog: _openDialog, openDialogComplete: _openDialogComplete),
            if (_currentPage == 1)                                              // map
              BarberMapScreen(callback: _route),
            if (_currentPage == 2)
              BarberHomeScreen(callback: _routeParam, openFilter: _openFilter, openSalon: _openSalon,
                specialist: _specialist, redrawAppBar: _redrawAppBar),
            if (_currentPage == 3)                                              // notify
              BarberNotifyScreen(callback: _route),
            if (_currentPage == 4 && FirebaseAuth.instance.currentUser != null && _state == "")                  // account
              BarberAccountScreen(callback: _route, redraw: (){setState(() {});},),

            appbar30((_currentPage == 2) ? (_transparent) ? Colors.transparent : (darkMode) ? Colors.black : Colors.white
                : (darkMode) ? Colors.black : Colors.white,
                 (darkMode) ? Colors.white : Colors.black,
                _title, Icons.menu, Icons.chat_bubble_outline, Icons.calendar_today, context, _chatCount, (int id) {
              switch(id){
                case 0:
                  print("icon menu");
                  _scaffoldKey.currentState!.openDrawer();
                  break;
                case 2:
                  print("chat");
                  _state = "chat";
                  _chatCount = 0;
                  setState(() {
                  });
                  break;
                case 3:
                  print("right icon 2");
                  _currentPage = 0;
                  setState(() {
                  });
                  break;
              }
            }),

            BottomBar5(colorBackground: barberMainColor,
                colorSelect: Colors.white,
                colorUnSelect: Colors.white,
                callback: (int y){
                  _state = "";
                  if (googleMapEnable)
                    _currentPage = y;
                  else {
                    if (y == 3) y++;
                    if (y == 2) y++;
                    if (y == 1) y++;
                    _currentPage = y;
                  }
                  setState(() {
                  });
                }, initialSelect: _currentPage,
                getItem: (){return _currentPage;},
                icons: (googleMapEnable) ? [Icons.calendar_today, Icons.location_on_outlined, Icons.home_filled, Icons.mark_chat_unread_outlined, Icons.account_circle_rounded] :
                    [Icons.calendar_today,  Icons.home_filled, Icons.mark_chat_unread_outlined, Icons.account_circle_rounded],
                getMessagesCount: (){return _numberOfUnreadMessages;},
                getCount: (){return (googleMapEnable) ? 5 : 4;}
            ),

            if (_state == "addLocation")
              BarberAddLocationScreen(callback: _route),
            if (_state == "createAccount")
              BarberCreateAccountScreen(callback: _route),

            if (_state == "terms")
              DocumentsScreen(callback: _route, backRoute: _termsBackRoute, source: _state,),
            if (_state == "policy")
              DocumentsScreen(callback: _route, source: _state, backRoute: _termsBackRoute,),
            if (_state == "about")
              DocumentsScreen(callback: _route, source: _state, backRoute: _termsBackRoute,),

            if (_state == "invite")
              InviteScreen(callback: _route),

            if (_state == "forgot")
              BarberForgotScreen(callback: _route),
            if (_state == "lang")
              BarberLanguageScreen(callback: _route, redraw: (){setState(() {});},),
            if (_state == "details")
              BarberDetailsScreen(callback: _route),
            if (_state == "appointment1" && user != null)
              BarberAppointment0Screen(callback: _route, backRoute: "root",),
            if (_state == "appointment1" && user == null)
              BarberLoginScreen(callback: _route),
            if (_state == "cat_details")
              CategoryDetailsScreen(callback: _route, title: _param,),

            if (_state == "salon")
              BarberMain2Screen(callback: _routeParam, openFilter: _openFilter, salon: _openSalonData!, specialist: _specialist),

            if (_state == "chat")
              if (FirebaseAuth.instance.currentUser != null)
                ChatScreen(callback: _route),
            if (_state == "chat")
              if (FirebaseAuth.instance.currentUser == null)
                BarberLoginScreen(callback: _route),

            if (_currentPage == 4 && FirebaseAuth.instance.currentUser == null && _state == "")                // login
              BarberLoginScreen(callback: _route),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: barberMainColor,
              body: _dialogBody, backgroundColor:  (darkMode) ? Colors.black : Colors.white,),

          ],
        )

    ))));
  }

  Salon? _openSalonData;
  _openSalon(Salon item){
    _openSalonData = item;
    _state = "salon";
    _redraw();
  }

  _specialist(){
    _state = "details";
    _redraw();
  }

  String _state = "";
  String _param = "";

  _routeParam(String route, String param){
    _param = param;
    _route(route);
  }

  _route(String route){
    _termsBackRoute = "createAccount";

    if (route == "appointments")
      _currentPage = 0;

    if (route == "registerOrLogin")
      route = "";

    if (route == "root"){
      _state = "";
      _currentPage = 2;
    }else {
      if (route == "login"){
        _state = "";
        _currentPage = 4;
      }else
        _state = route;
    }
    setState(() {

    });
  }

  var menu1 = [
    Menu1Data("terms", strings.get(98), Icons.ten_k), // "Terms & Conditions"
    Menu1Data("policy", strings.get(32), Icons.policy), // "Privacy Policy"
    Menu1Data("about", strings.get(96), Icons.account_balance_wallet_outlined), // About us
    Menu1Data("lang", strings.get(95), Icons.language), // Select Language
  ];

  _routeMenu1(String id){
    print("Pressed menu item $id");

    if (id == "logout"){
      logout();
      setState(() {
      });
    }
    if (id == "share")
      return share();

    if (id == "redraw"){
      setState(() {
      });
      return;
    }

    if (id == "terms" || id == "about" || id == "policy")
      _termsBackRoute = "";

    _state = id;
    setState(() {
    });
  }

  _openFilter(){
    _scaffoldKey.currentState!.openEndDrawer();
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _openDialog(Function() _cancel){
    _dialogBody = Column(
      children: [
        Text(strings.get(77), style: TextStyle(color: (darkMode) ? Colors.white : Colors.black),), // Are you sure?
        SizedBox(height: 40,),
        Row(
          children: [
            Flexible(child: button2(strings.get(78), // "Yes",
                barberMainColor, 10,
                    (){
                  _cancel();
                  print("button pressed");
                  setState(() {
                    _show = 0;
                  });
                }, true)),
            SizedBox(width: 10,),
            Flexible(child: button2(strings.get(79), // "No",
                barberMainColor, 10,
                    (){
                  print("button pressed");
                  setState(() {
                    _show = 0;
                  });
                }, true)),
          ],
        )
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _openDialogComplete(String _employeeName, Function(int, String) _complete){
    int _rate = 5;
    _dialogBody = Column(
      children: [
        Text("${strings.get(84)} $_employeeName",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black) ,), // Rate
        SizedBox(height: 20,),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Slider3(callback: (int stars){
                  print("Currents selected: $stars");
                  _rate = stars;
                },
                initStars: 5,
                iconStarsColor: barberMainColor,
                iconSize: 40)),
        SizedBox(height: 20,),
        Container(
          margin: EdgeInsets.only(left: windowWidth*0.02, right: windowWidth*0.02, bottom: 3),
          child: Text(strings.get(85), // "Enter your review",
              style: TextStyle(color: Colors.grey),),),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Edit24(
            hint: "",
            color: Colors.grey,
            radius: 10,
            controller: _controllerReview,
          ),),
        SizedBox(height: 20,),
        Row(
          children: [
            Flexible(child: button2(strings.get(20), // "Send",
                barberCompanionColor, 10,
                    (){
                  _complete(_rate, _controllerReview.text);
                  print("button pressed");
                  setState(() {
                    _show = 0;
                  });
                }, true)),
            SizedBox(width: 10,),
            Flexible(child: button2(strings.get(76), // "Cancel",
                barberMainColor, 10,
                    (){
                  print("button pressed");
                  setState(() {
                    _show = 0;
                  });
                }, true)),
          ],
        )
      ],
    );
    setState(() {
      _show = 1;
    });
  }


}


