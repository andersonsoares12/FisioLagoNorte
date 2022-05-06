
import 'package:flutter/material.dart';

card2(String image, String title, String text2, String text3, String date, double width){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
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
              width: width*0.4,
              margin: EdgeInsets.only(left: 0, top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover
                      ),
                    ),
                  )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                  SizedBox(height: 10,),
                  Text(text2)
                ],
              ),
            )
          ],
        ),

        SizedBox(height: 20,),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text3, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800), maxLines: 3,)),
                SizedBox(width: 10),
                Text(date)
              ],
            )

        )


      ],
    ),

  );
}
