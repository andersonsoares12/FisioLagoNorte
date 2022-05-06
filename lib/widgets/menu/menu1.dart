import 'dart:io';

import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/user.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/ui/bugreport.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/widgets/cards/card16.dart';
import 'package:FisioLago/widgets/checkbox/checkbox48.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../main.dart';
import '../../model/pref.dart';

class Menu1Data{
  String id;
  String text;
  IconData icon;
  Menu1Data(this.id, this.text, this.icon);
}

class Menu1 extends StatefulWidget {
  @required final BuildContext context;
  final Function(String) callback;
  final List<Menu1Data> data;
  Menu1({required this.context, required this.data, required this.callback});

  @override
  _Menu1State createState() => _Menu1State();
}


class _Menu1State extends State<Menu1> {

  @override
  void initState() {
    _initBuild();
    super.initState();
  }

  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";

  _initBuild() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {
    });
    log("appName=$appName, packageName=$packageName, version=$version, buildNumber=$buildNumber");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(_header());
    for (var item in widget.data)
      list.add(_menuItem(item.id, item.text, item.icon),);
    //
    // if (salonPhone.isNotEmpty)
    //   list.add(_menuItem("callphone", strings.get(110), Icons.call,)); // "Call to Salon",
    // if (website.isNotEmpty)
    //   list.add(_menuItem("website", strings.get(111), Icons.web,)); // "Open Web Site",
    // if (instagram.isNotEmpty)
    //   list.add(_menuItem("instagram", strings.get(112), Icons.portrait,)); // "Open Instagram page",
    if (Platform.isIOS && appStoreLink.isNotEmpty)
      list.add(_menuItem("share", strings.get(113), Icons.share,)); // "Share This App"
    if (Platform.isAndroid && googlePlayLink.isNotEmpty)
      list.add(_menuItem("share", strings.get(113), Icons.share,)); // "Share This App"
    //
    list.add(SizedBox(height: 8,));
    list.add(_menuItemRadio("black", strings.get(101), // "Black mode",
        Icons.app_blocking));
    //
    list.add(SizedBox(height: 8,));
    list.add(_menuItem("logout", strings.get(37), Icons.logout,)); // "Log Out",
    list.add(SizedBox(height: 8,));
    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: _onBugReport,
        child: Text("ver: $version.$buildNumber",
            style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black )),
      )
    ));

    return Drawer(
        child: Container(
          color: (darkMode) ? Colors.black : Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: list
          ),
        )
    );
  }

  _menuItem(String id, String name, IconData iconData){
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(name, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black, fontWeight: FontWeight.w800 ),),
          leading:  UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Icon(iconData, color: (darkMode) ? Colors.white : Colors.grey,)
              )),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400]!.withAlpha(100),
                onTap: () {
                  Navigator.pop(context);
                  widget.callback(id);
                }, // needed
              )),
        )
      ],
    );
  }

  _menuItemRadio(String id, String name, IconData iconData){
    return Stack(
      children: <Widget>[
        Row(children: [
          SizedBox(width: 15,),
          UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Icon(iconData, color: (darkMode) ? Colors.white : Colors.grey,)
              )),
          SizedBox(width: 33,),
          Expanded(child: Text(name, style: TextStyle(fontSize: 14,
              color: (darkMode) ? Colors.white : Colors.black, fontWeight: FontWeight.w800 ),),),
          CheckBox48(
            enabledTrackColor: barberMainColor,
            onChanged: (bool value) {
              darkMode = value;
              pref.set(Pref.dark, value.toString());
              widget.callback("redraw");
              setState(() {});
              }, value: darkMode,),
        ],),
      ],
    );
  }


  _header() {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        width: double.maxFinite,
        color: barberMainColor,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Card16(image: userAvatar,
                  text1: userName,
                  style1: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  text2: "",
                  style2: TextStyle(fontSize: 12, color: Colors.grey),
                  radius: 60,
                )),
            SizedBox(height: 20,),
          ],
        )
    );
  }

  _onBugReport(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BugReportScreen(),
      ),
    );
  }

}