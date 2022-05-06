
import 'package:FisioLago/model/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

card4(String image, String title, String text2,
    String text6, String text7,
    String text3,
    String _prices, double width,
    String coupon, String coupon2,
    String text4, String text5,
    String pointsText, String points,
    int pointsPayment
    ){
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: width*0.2,
              width: width*0.3,
              margin: EdgeInsets.only(left: 10, top: 10, right: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
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
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),),
                  SizedBox(height: 10,),
                  Text(text2, style: TextStyle(color: (darkMode) ? Colors.white : Colors.black),)
                ],
              ),
            )
          ],
        ),

        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          height: 0.5, width: double.maxFinite, color: Colors.grey,),

        // Container(
        //   margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        //   child: Text(text6),),

        // Container(
        //   margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        //   child: Row(
        //     children: [
        //       Icon(Icons.account_circle_rounded, color: Colors.grey,),
        //       SizedBox(width: 10,),
        //       Text(text7)
        //     ],
        //   ),),

        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text3, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                    color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                SizedBox(width: 10),
                Text(_prices, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                    color: (darkMode) ? Colors.white : Colors.black))
              ],
            )
        ),

        if (coupon.isNotEmpty)
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(coupon, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                      color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                  SizedBox(width: 10),
                  Text(coupon2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                      color: (darkMode) ? Colors.white : Colors.black))
                ],
              )
          ),
        if (pointsPayment != 0)
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(strings.get(134), // "Payment by points",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                      color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                  SizedBox(width: 10),
                  Text("-$pointsPayment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                      color: Colors.red))
                ],
              )
          ),

        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          height: 0.5, width: double.maxFinite, color: Colors.grey,),

        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text4, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                    color: (darkMode) ? Colors.white : Colors.black), maxLines: 3,)),
                Text(text5, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF225C3C)), maxLines: 3,),
              ],
            ),
        ),

        if (points.isNotEmpty)
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(pointsText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                      color: Colors.green), maxLines: 3,)),
                  SizedBox(width: 10),
                  Text("+$points", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                      color: Colors.green))
                ],
              )
          ),



      ],
    ),

  );
}
