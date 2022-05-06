import 'dart:math';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/offers.dart';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/buttons/button142a.dart';
import 'package:FisioLago/widgets/edit/edit26a.dart';
import 'package:FisioLago/widgets/image/image5.dart';
import 'package:FisioLago/widgets/offer.dart';
import 'package:FisioLago/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/buttons/button134.dart';
import 'package:FisioLago/widgets/buttons/button142.dart';
import 'package:FisioLago/widgets/buttons/button143.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import '../main.dart';
import 'catdetails.dart';
import 'details.dart';
import 'gallery.dart';
import 'main.dart';

class BarberHomeScreen extends StatefulWidget {
  final Function() openFilter;
  final Function(double) redrawAppBar;
  final Function(Salon) openSalon;
  final Function() specialist;
  final Function(String, String) callback;
  const BarberHomeScreen({Key? key, required this.callback, required this.openSalon,
    required this.openFilter, required this.specialist, required this.redrawAppBar}) : super(key: key);

  @override
  _BarberTermsScreenState createState() => _BarberTermsScreenState();
}

class _BarberTermsScreenState extends State<BarberHomeScreen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  var _controllerSearch = TextEditingController();
  String _searchText = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    widget.redrawAppBar(_scrollController.position.pixels);
  }

  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    //log("build home ${employee.length} $this");
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white30,
        body: Stack(
          children: <Widget>[

            Container (
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                children: _getList(),
              ),),

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];

    // list.add(Container(
    //     width: windowWidth,
    //     height: windowWidth*1.1,
    //     child: Stack(
    //       children: [
    //       // Container(
    //       //   width: windowWidth,
    //       //   height: windowWidth*0.9,
    //       //   child: image5(Image.asset("assets/img1.jpg", fit: BoxFit.scaleDown), 20)),
    //       //   Container(
    //       //     alignment: Alignment.bottomCenter,
    //       //     margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
    //       //     child: Edit26a(
    //       //             hint: strings.get(53), // "Search",
    //       //             color: Colors.black,
    //       //             radius: 10,
    //       //             icon: Icons.search,
    //       //             controller: _controllerSearch,
    //       //             onChangeText: (String value){
    //       //               _searchText = value.toUpperCase();
    //       //               setState(() {
    //       //               });
    //       //             }
    //       //         )
    //       //     ),
    //       ],
    //     )));

    list.add(SizedBox(height: 30,));
// pesquisa
//     list.add(Container(
//         margin: EdgeInsets.only(left: 10, right: 10, top: 20),
//         child: Row(
//           children: [
//             Expanded(child: Text("Clinica", // "Salons",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),),
//             PopupMenuButton(
//               onSelected: (int code) async {
//                 await setSalonSort(code);
//                 setState(() {});
//               },
//                 icon: Icon(Icons.filter_alt_outlined, color: (darkMode) ? Colors.white : Colors.black),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                     child: Text(strings.get(123)), // "No sort"
//                     value: 1,
//                   ),
//                   PopupMenuItem(
//                     child: Text(strings.get(124)), // By name A-Z
//                     value: 2,
//                   ),
//                   PopupMenuItem(
//                     child: Text(strings.get(125)), // "By name Z-A"
//                     value: 3,
//                   ),
//                   PopupMenuItem(
//                     child: Text(strings.get(126)), // "Near me"
//                     value: 4,
//                   ),
//                 ]
//             )
//           ],
//         )));
    list.add(SizedBox(height: 10,));

    for (var item in salons){
      if (_searchText.isNotEmpty)
        if (!item.name.toUpperCase().contains(_searchText))
          continue;
      var distance = "";
      if (item.distance != 0)
        distance = getDistanceStringFromDouble(item.distance);
      //log("Salon add in Home Screen: ${item.name} image=${item.image} imageUrl=${item.imageUrl}");
      list.add(button142(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
          0, 0,
          item.address, TextStyle(fontSize: 13, color: (darkMode) ? Colors.white : Colors.black),
          Colors.white, item.imageUrl, windowWidth, windowWidth*0.5, 10, (){
            widget.openSalon(item);
            print("button pressed");
          }, distance));
      if (item.gallery.isNotEmpty){
        list.add(Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("${item.name} ${strings.get(115)}", // "gallery",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)));
        list.add(_horizontalGallery(item.gallery));
      }
    }
/// agendar consulta
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button2(strings.get(60), // "Book Appointment",
            Color(0xFF225C3C), 10, _bookAppoinment, true)));
    list.add(SizedBox(height: 20,));

    //lista de funcionarios
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
      children: [
        Expanded(child: Text(strings.get(51), // "Our specialists",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
        button134(strings.get(56), // "View all >>",
            _viewAllBestSpecialist, true,
            TextStyle(fontSize: 15,
                fontWeight: FontWeight.w800,
                color: barberMainColor),),
      ],
    ),),);

    list.add(SizedBox(height: 10,));
    list.add(_horizontalBestSpecialist());
    list.add(SizedBox(height: 10,));

    if (offers.isNotEmpty) {
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(strings.get(88), // "Special offers",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
      ));
      list.add(SizedBox(height: 20,));
      for (var item in offers)
        list.add(Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: offerItem(item, windowWidth)));
    }
/// SERVIÇOS
    list.add(SizedBox(height: 10,));
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
      children: [
        Expanded(child: Text(strings.get(58), // "Services",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
      ],
    )));

    if (!categoryLoaded){
      list.add(SizedBox(height: 10,));
      for (var i = 0; i < 5; i++) {
        list.add(Container(
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          width: windowWidth,
          height: windowWidth,
          child: Shimmer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ));
        list.add(SizedBox(width: 10,));
      }
    }else{
      for (var item in category){
        if (!item.visible)
          continue;
        if (_searchText.isNotEmpty)
          if (!item.name.toUpperCase().contains(_searchText))
            continue;
        list.add(Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Stack(
          children: [
            button143(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                Colors.white, item.image, windowWidth, windowSize/2-20, 10, (){
                  print("button pressed");
                  categoryData = item;
                  categorySalon = null;
                  categoryReturn = "";
                  widget.callback("cat_details", "");
                }, true),

            if (item.board.isNotEmpty)
              Container(
                  width: windowWidth,
                  height: windowWidth/2-20,
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Align(
                    alignment: Alignment.topRight,
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
        )));
        list.add(SizedBox(height: 10,));
      }
    }

    list.add(SizedBox(height: 20,));
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button2(strings.get(60), // "Book Appointment",
            Color(0xFF225C3C), 10, _bookAppoinment, true)));

    list.add(SizedBox(height: 100,));
    return list;
  }

  _horizontalGallery(List<String> gallery){
    List<Widget> list = [];
    //log("_horizontalGallery gallery.length=${gallery.length}");
    for (var item in gallery){
      list.add(button142a(item, windowWidth*0.35, windowWidth*0.35*0.75, 10, () {
        log("button pressed. Open gallery screen item.length=${item.length}");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GalleryScreen(item: item, gallery: gallery,),
            )
        );
      }));
      list.add(SizedBox(width: 10,));
    }
    return Container(
      height: windowWidth*0.35*0.75+40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _horizontalBestSpecialist(){
    List<Widget> list = [];
    //log("_horizontalBestSpecialist ${employee.length}");
    if (!employeeLoaded) {
      for (var i = 0; i < 5; i++) {
        list.add(Container(
          margin: EdgeInsets.all(10),
          width: 160.0,
          height: 160.0,
          child: Shimmer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ));
        list.add(SizedBox(width: 10,));
      }
    }else{
      for (var item in employee){
        if (_searchText.isNotEmpty)
          if (!item.name.toUpperCase().contains(_searchText))
            continue;
        list.add(Stack(
          children: [
            button142(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                item.rate, item.rateCount,
                "", TextStyle(),
                Colors.white, item.image, windowWidth*0.35, windowWidth/2-20, 10, (){
                  currentSpecialist = item;
                  salonSpecialist = null;
                  widget.specialist();
                  // widget.callback("details", strings.get(57), // "Best Specialist"
                  // );
                  print("button pressed");
                }, ""),
            if (item.board.isNotEmpty)
              Container(
                  width: windowWidth*0.35,
                  height: windowWidth/2-20,
                  padding: EdgeInsets.only(top: 20, right: 0, left: 10),
                  child: Align(
                    alignment: Alignment.topRight,
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
        ));
        list.add(SizedBox(width: 10,));
      }
    }
    return Container(
      height: (list.isEmpty) ? 20 : 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _viewAllBestSpecialist(){
    currentSpecialist = null;
    salonSpecialist = null;
    widget.specialist();
  }

  _bookAppoinment(){
    widget.callback("appointment1", "");
  }

}
