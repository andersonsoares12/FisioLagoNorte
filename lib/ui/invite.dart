import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';

class InviteScreen extends StatefulWidget {
  final Function(String) callback;
  const InviteScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {

  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1(Colors.white, Colors.black, "Invite a friends", context, () {
              widget.callback("");
            })

          ],
        )

    );
  }


  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: windowHeight*0.1,));

    list.add(Container(
      width: windowWidth,
      height: windowHeight*0.4,
      child: Image.asset("assets/barber/3.jpg",
                  fit: BoxFit.contain
              ),
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.25, right: windowWidth*0.25, ),
      child: Text("Invite friend or coworker and get a discount", textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),)
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.2, right: windowWidth*0.2, ),
        child: button2("Share Your Code", Color(0xFF225C3C), 10, _invite, true)))
    ;

    return list;
  }

  _invite()async {
    //final RenderObject? box = context.findRenderObject();
    await Share.share("CODE12312",
        subject: "Share CODE",
        sharePositionOrigin: null);//box!.localToGlobal(Offset.zero) & box.size);
  }

}


