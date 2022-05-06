import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

button142(String text, TextStyle style,
    double stars, int rateCount,
    String address, TextStyle addressStyle,
    Color color, String image, double width, double height, double radius, Function _callback,
    String distance
    ){
  return Stack(
    children: <Widget>[

      Container(
          margin: EdgeInsets.all(10),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: (darkMode) ? Colors.black.withAlpha(100) : Colors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                child: Container(
                  width: width,
                    height: height,
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
                      ),
                ),
              )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                  width: width-20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6,),
                  Text(text, style: style, textAlign: TextAlign.start,),
                  SizedBox(height: 4,),

                  if (address.isNotEmpty)
                    Row(
                      children: [
                        Expanded(child: Text(address, style: addressStyle, textAlign: TextAlign.start,)),
                        SizedBox(width: 10,),
                        if (distance != "")
                          Text(distance.toString(), style: addressStyle, textAlign: TextAlign.end,),
                        SizedBox(width: 10,),
                      ],
                    ),
                  if (address.isEmpty)
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
                  SizedBox(height: 6,),
                ],
              ))

            ],
          )
      ),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )

    ],
  );
}
