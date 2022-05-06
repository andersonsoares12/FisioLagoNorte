import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button143.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

CategoryData? categoryData;
Salon? categorySalon;
String categoryReturn = "";

class CategoryDetailsScreen extends StatefulWidget {
  final Function(String) callback;
  final String title;
  const CategoryDetailsScreen({Key? key, required this.callback, required this.title}) : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {

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
              (darkMode) ? Colors.white : Colors.black, widget.title, context, () {
              log("CategoryDetails screen categoryReturn=$categoryReturn");
              widget.callback(categoryReturn);
            })

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 50,));

    if (categoryData != null)
      list.add(Hero(
          tag: categoryData!.id,
          child: button143(categoryData!.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
              (darkMode) ? Colors.black : Colors.white, categoryData!.image, windowWidth, windowWidth*0.8, 10, (){
                print("button pressed");
              }, false)
          )
      );

      list.add(SizedBox(height: 20,));
      for (var item in work){
        if (!item.visible)
          continue;
        if (item.categoryId != categoryData!.id)
          continue;
        if (categorySalon != null)
          if (!categorySalon!.works.contains(item.id))
            continue;
        list.add(Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: Text(item.name, style: TextStyle(fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black))),
              Text("${item.duration} ${strings.get(59)}", style: TextStyle(fontWeight: FontWeight.w400, color: barberMainColor)), // min
              SizedBox(width: 20,),
              Text(getPriceString(toDouble(item.price)), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20,
                  color: (darkMode) ? Colors.white : Colors.black)) // min
          ],)));
      }

      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.all(15),
        child: button2(strings.get(60), // "Book Appointment",
            Color(0xFF225C3C), 10, _bookAppoinment, true),
      ));
    // }

    return list;
  }

  _bookAppoinment(){
    widget.callback("appointment1");
  }
}
