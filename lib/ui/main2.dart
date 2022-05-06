import 'dart:math';
import 'package:FisioLago/model/category.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/offers.dart';
import 'package:FisioLago/model/salon.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/ui/gallery.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button170.dart';
import 'package:FisioLago/widgets/offer.dart';
import 'package:FisioLago/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/buttons/button134.dart';
import 'package:FisioLago/widgets/buttons/button142.dart';
import 'package:FisioLago/widgets/buttons/button143.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'catdetails.dart';
import 'details.dart';
import 'main.dart';

class BarberMain2Screen extends StatefulWidget {
  final Function() openFilter;
  final Function() specialist;
  final Salon salon;
  final Function(String, String) callback;
  const BarberMain2Screen({Key? key, required this.callback,
    required this.openFilter, required this.salon, required this.specialist}) : super(key: key);

  @override
  _BarberTermsScreenState createState() => _BarberTermsScreenState();
}

class _BarberTermsScreenState extends State<BarberMain2Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;
  var _controllerSearch = TextEditingController();

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
    //print("build main2 ${employee.length} $this");
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+30),
              child: ListView(
                shrinkWrap: true,
                children: _getList(),
              ),),

            appbar1((darkMode) ? Colors.black : Colors.white,
                (darkMode) ? Colors.white : Colors.black, widget.salon.name, context, () {
                    widget.callback("", "");
                })

          ],
        )

    );
  }

  _getList() {
    List<Widget> list = [];
    if (widget.salon.desc.isNotEmpty){
      list.add(Text(widget.salon.desc,
        style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black),));
      list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));
    }
    _openCloseTime(list);
    list.add(SizedBox(height: 10,));
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));
    _webSitePhoneInsagramm(list);

    list.add(SizedBox(height: 15,));

    list.add(Row(
      children: [
        Expanded(child: Text(strings.get(51), // "Our specialists",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
        button134(strings.get(56), // "View all >>",
            _viewAllBestSpecialistAll, true,
            TextStyle(fontSize: 15,
                fontWeight: FontWeight.w800,
                color: barberMainColor))
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(_horizontalBestSpecialist());
    list.add(SizedBox(height: 10,));

    list.add(button2(strings.get(60), // "Book Appointment",
        Color(0xFF28F189), 10, _bookAppoinment, true));
    list.add(SizedBox(height: 20,));

    if (offers.isNotEmpty) {
      list.add(Text(strings.get(88), // "Special offers",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
      );
      list.add(SizedBox(height: 20,));

      for (var item in offers)
        if (item.salons.contains(widget.salon.id))
          list.add(offerItem(item, windowWidth));
    }

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: Text(strings.get(58), // "Services",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
      ],
    ));

    if (!categoryLoaded){
      list.add(SizedBox(height: 10,));
      for (var i = 0; i < 5; i++) {
        list.add(Container(
          margin: EdgeInsets.only(bottom: 10),
          width: windowWidth,
          height: windowWidth * 0.4,
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
        if (!isServiceNotEmptyForSalon(widget.salon, item))
          continue;
        list.add(Stack(
          children: [
            button143(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                Colors.white, item.image, windowWidth, windowSize/2-20, 10, (){
                  print("button pressed");
                  categorySalon = widget.salon;
                  categoryReturn = "salon";
                  categoryData = item;
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
        )
        );
        list.add(SizedBox(height: 10,));
      }
    }

    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        Expanded(child: Text(strings.get(100), // "Our works",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),)),
      ],
    ));
    list.add(SizedBox(height: 10,));

    List<Widget> list2 = [];
    for (var item in widget.salon.gallery){
      list2.add(UnconstrainedBox(child: Container(
        margin: EdgeInsets.only(bottom: 10),
          width: windowWidth/2-15,
          height: windowWidth/2-15,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(50),
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryScreen(item: item, gallery: widget.salon.gallery,),
                ),
              );
            },
            child: ClipRRect(
            borderRadius: new BorderRadius.all(Radius.circular(5)),
            child: Hero(
              tag: UniqueKey().toString(),
              child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  UnconstrainedBox(child:
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                  )),
              imageUrl: item,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
          ),
      )))))
      );
    }
    list.add(Wrap(
      spacing: 10,
      children: list2,));

    list.add(SizedBox(height: 20,));
    list.add(button2(strings.get(60), // "Book Appointment",
        Color(0xFF225C3C), 10, _bookAppoinment, true));

    list.add(SizedBox(height: 100,));
    return list;
  }

  _webSitePhoneInsagramm(List<Widget> list){
    if (widget.salon.phone.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Text(widget.salon.phone, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black,),
              overflow: TextOverflow.ellipsis,)),
          button170(barberMainColor, Icon(Icons.phone, color: barberMainColor,), 5, 40, (){
            callMobile(widget.salon.phone);
          }, true)
        ],
      ));
    }
    if (widget.salon.website.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Text(widget.salon.website, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black,),
            overflow: TextOverflow.ellipsis,)),
          button170(barberMainColor, Icon(Icons.web, color: barberMainColor,), 5, 40, (){
            openWebSite(widget.salon.website);
          }, true)
        ],
      ));
    }
    if (widget.salon.instagram.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Text(widget.salon.instagram, style: TextStyle(fontSize: 14, color: (darkMode) ? Colors.white : Colors.black,),
            overflow: TextOverflow.ellipsis,)),
          button170(barberMainColor, Icon(Icons.image, color: barberMainColor,), 5, 40, (){
            openInstagram("https://www.instagram.com/fisiolagonorte/");
          }, true)
        ],
      ));
    }

    if (widget.salon.phone.isNotEmpty || widget.salon.website.isNotEmpty || widget.salon.instagram.isNotEmpty) {
      list.add(SizedBox(height: 10,));
      list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));
    }
  }

  _openCloseTime(List<Widget> list){
    // open - close time
    var _now = DateTime.now();
    if (widget.salon.openTime.isNotEmpty && widget.salon.closeTime.isNotEmpty){
      DateTime _tempOpen = new DateFormat("HH:mm").parse(widget.salon.openTime);
      _tempOpen = DateTime(_now.year, _now.month, _now.day, _tempOpen.hour, _tempOpen.minute);
      var _openTime = _tempOpen.difference(DateTime.now());
      log("main2 openTime $_tempOpen difference=${_openTime.inMinutes}");
      bool _close = false;
      if (_openTime.inMinutes < 0)
        _close = true;
      DateTime _tempClose = new DateFormat("HH:mm").parse(widget.salon.closeTime);
      _tempClose = DateTime(_now.year, _now.month, _now.day, _tempClose.hour, _tempClose.minute);
      var _closeTime = DateTime.now().difference(_tempClose);
      log("main2 closeTime $_tempClose difference=${_closeTime.inMinutes}");
      if (_closeTime.inMinutes > 0)
        _close = true;
      log("main2 close=$_close");
      //
      list.add(SizedBox(height: 10,));

      list.add(Row(
        children: [
          Text("${DateFormat(getTimeFormat()).format(_tempOpen)}-${DateFormat(getTimeFormat()).format(_tempClose)}",
            style: TextStyle(fontSize: 16, color: (darkMode) ? Colors.white : Colors.black),),
          SizedBox(width: 20,),
          Expanded(child: Text((_close) ? strings.get(117) : strings.get(117),
            style: TextStyle(fontSize: 20, color: (_close) ? Colors.red : Color(0xFF225C3C)),)) // "NOW OPEN", - "NOW CLOSE",
        ],
      ));
    }
  }

  _horizontalBestSpecialist(){
    List<Widget> list = [];
    //log("_horizontalBestSpecialist ${employee.length} ${widget.salon.employee.length}");
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
        if (!widget.salon.employee.contains(item.id))
          continue;
        list.add(Stack(
          children: [
            button142(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                item.rate, item.rateCount,
                "", TextStyle(),
                Colors.white, item.image, windowWidth*0.35, windowWidth/2-20, 10, (){
                  currentSpecialist = item;
                  salonSpecialist = widget.salon;
                  widget.specialist();
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
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _viewAllBestSpecialistAll(){
    currentSpecialist = null;
    salonSpecialist = widget.salon;
    widget.specialist();
  }

  _bookAppoinment(){
    widget.callback("appointment1", "");
  }
}
