import 'dart:io';
import 'dart:math';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/edit/edit23.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../main.dart';

class BugReportScreen extends StatefulWidget {
  @override
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  var _controllerEmail = TextEditingController();
  var _controllerComment = TextEditingController();
  var _controllerLog = TextEditingController();

  @override
  void initState() {
    _controllerEmail.text = "valera_letun@mail.ru";
    _controllerLog.text = bugLog.toString();
    _initPlatformState();
    super.initState();
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<void> _initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    log(deviceData.toString());
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerComment.dispose();
    _controllerLog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

        Align(
        alignment: Alignment.center,
          child: Container (
            width: windowSize,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, left: 20, right: 20),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _getList(),
              ),)),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, "", context, () {Navigator.pop(context);})

          ],
        )
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 30,));
    list.add(Text(strings.get(127), // "Send Bug Report"
      textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: (darkMode) ? Colors.white : Colors.black),));

    list.add(SizedBox(height: 40,));

    list.add(Container(
      child: Edit24(
        hint: "",
        color: Colors.grey,
        radius: 10,
        controller: _controllerEmail,
      ),));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      child: Edit24(
        hint: strings.get(128), // "Comment"
        color: Colors.grey,
        radius: 10,
        controller: _controllerComment,
      ),));

    list.add(SizedBox(height: 20,));

    list.add(Container(
        height: 200,
        child: edit23(_controllerLog, "", 10, Colors.grey)));

    list.add(SizedBox(height: 20,));

    list.add(button2(strings.get(130), // "Send Email",
        Color(0xFF225C3C), 10, _send, true));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _send() async {
    final Email email = Email(
      body: _controllerComment.text + "\n" + bugLog.toString(),
      subject: strings.get(129), // "Bug Report",
      recipients: [_controllerEmail.text],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}


