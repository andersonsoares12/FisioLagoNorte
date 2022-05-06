import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button144.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

EmployeeData? currentSpecialist;
Salon? salonSpecialist;

class BarberDetailsScreen extends StatefulWidget {
  final Function(String)? callback;
  const BarberDetailsScreen({Key? key, this.callback}) : super(key: key);

  @override
  _BarberDetailsScreenState createState() => _BarberDetailsScreenState();
}

class _BarberDetailsScreenState extends State<BarberDetailsScreen> {

  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.all(5),
              child: ListView(
                shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1((darkMode) ? Colors.black : Colors.white,
                (darkMode) ? Colors.white : Colors.black, strings.get(57), context, () {  // "Our Specialist"
              if (salonSpecialist == null)
                widget.callback!("");
              else
                widget.callback!("salon");
            })

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 50,));

    for (var item in employee){
      if (currentSpecialist != null && currentSpecialist!.id != item.id)
        continue;
      list.add(Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (darkMode) ? Colors.black.withAlpha(100) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ],
          ),
        child: Stack(
          children: [
            button144(item.name, TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                item.rate, item.rateCount,
                item.desc, TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black),
                (darkMode) ? Colors.white : Colors.black, item.image, windowWidth-20, 80, 10, (){print("button pressed");}),
            if (item.board.isNotEmpty)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: item.boardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(item.board, style: TextStyle(color: Colors.white),),
                  ),
                )
              )
          ],
        ),
      ));
      list.add(SizedBox(height: 10,));
    }

    return list;
  }
}
