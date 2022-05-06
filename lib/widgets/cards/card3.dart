
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

card3(String image, String title, String text2, String text3,
    String price,
    String date, double width,
    String text4, String text5,
    double stars, int rateCount,
    int rate, String rateText,
    bool _cancel, Function() onCancel, bool _complete, Function() onComplete, ){
  return Container(
    decoration: BoxDecoration(
      color: (darkMode) ? Colors.black.withAlpha(100) : Colors.white,
      borderRadius: new BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              height: width*0.2,
              width: width*0.35,
              margin: EdgeInsets.only(left: 10, top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        UnconstrainedBox(child:
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                        )),
                    imageUrl: image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10,),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                    textAlign: TextAlign.start,),
                  SizedBox(height: 10,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    if (stars >= 1)
                      Icon(Icons.star, color: barberCompanionColor, size: 16,),
                    if (stars < 1)
                      Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                    if (stars >= 2)
                      Icon(Icons.star, color: barberCompanionColor, size: 16,),
                    if (stars < 2)
                      Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                    if (stars >= 3)
                      Icon(Icons.star, color: barberCompanionColor, size: 16,),
                    if (stars < 3)
                      Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                    if (stars >= 4)
                      Icon(Icons.star, color: barberCompanionColor, size: 16,),
                    if (stars < 4)
                      Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                    if (stars >= 5)
                      Icon(Icons.star, color: barberCompanionColor, size: 16,),
                    if (stars < 5)
                      Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                    SizedBox(width: 10,),
                    if (rateCount != 0)
                      Text("$rateCount", style: TextStyle(fontSize: 13, color: (darkMode) ? Colors.white : Colors.black),)
                  ]
                  ),
                  SizedBox(height: 10,),
                  // if (_cancel)
                  //   Container(
                  //       margin: EdgeInsets.only(left: 20, right: 20),
                  //       child: button2(strings.get(76), // "Cancel",
                  //           Colors.orange, 10, onCancel, true)
                  // )
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(price, style: TextStyle(fontSize: 13, color: (darkMode) ? Colors.white : Colors.black), textAlign: TextAlign.end,),
                  )


                ],
              ),
            )
          ],
        ),

        SizedBox(height: 20,),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text3, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                    color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                SizedBox(width: 10),
                Text(date, style: TextStyle(color: (darkMode) ? Colors.white : Colors.black),)
              ],
            )
        ),
        SizedBox(height: 15,),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text4, style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                Text(text5, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: barberMainColor), maxLines: 3,),
              ],
            ),
        ),

        SizedBox(height: 10,),
        Container(height: 0.5, color: Colors.grey.withAlpha(100),),
        SizedBox(height: 10,),

        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                if (!_cancel)
                  Expanded(child: Container()),
                if (_cancel)
                  Expanded(child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: button2(strings.get(76), // "Cancel",
                          barberMainColor, 10, onCancel, true)
                  ),),
                if (!_complete)
                  Expanded(child: Container()),
                if (_complete)
                  Expanded(child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: button2(strings.get(83), // "Complete",
                          barberCompanionColor, 10, onComplete, true)
                  ),),
              ],)),

        if (!_complete)
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(strings.get(86)), // You rate
                      SizedBox(width: 20,),
                      Row(children: [
                        if (rate >= 1)
                          Icon(Icons.star, color: barberCompanionColor, size: 16,),
                        if (rate < 1)
                          Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                        if (rate >= 2)
                          Icon(Icons.star, color: barberCompanionColor, size: 16,),
                        if (rate < 2)
                          Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                        if (rate >= 3)
                          Icon(Icons.star, color: barberCompanionColor, size: 16,),
                        if (rate < 3)
                          Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                        if (rate >= 4)
                          Icon(Icons.star, color: barberCompanionColor, size: 16,),
                        if (rate < 4)
                          Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                        if (rate >= 5)
                          Icon(Icons.star, color: barberCompanionColor, size: 16,),
                        if (rate < 5)
                          Icon(Icons.star_border, color: barberCompanionColor, size: 16,),
                        SizedBox(width: 10,),
                      ]
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(rateText, )
                ],
              ))

        //double rate, String rateText,


      ],
    ),

  );
}
