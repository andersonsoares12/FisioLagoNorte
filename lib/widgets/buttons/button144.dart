import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

button144(String text, TextStyle style,
    double stars, int rateCount,
    String desc, TextStyle style3,
    Color color, String image, double width, double height, double radius, Function _callback){
  return Stack(
    children: <Widget>[

      Container(
        margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
             boxShadow: [
               BoxShadow(
                 color: Colors.white.withOpacity(0.3),
                 spreadRadius: 3,
                 blurRadius: 5,
                 offset: Offset(3, 3),
               ),
             ],
          ),
          child: Column(
          children: [
            Container(
              height: height,
              width: width,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: new BorderRadius.only(topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius)),
                      child: Container(
                        width: width*0.3,
                        height: height,
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
                        ),
                      )),
                  SizedBox(width: 10,),
                  Expanded(child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Text(text, style: style, textAlign: TextAlign.start,),
                          SizedBox(height: 5,),
                          Row(children: [
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
                          SizedBox(height: 5,),
                        ],
                      ))),
                  SizedBox(height: 2,),
                ],
              ),
            ),
          SizedBox(height: 10,),
          Text(desc, style: style3,),
        ],
      )),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius)),
              child: InkWell(
                splashColor: Colors.greenAccent.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )

    ],
  );
}
