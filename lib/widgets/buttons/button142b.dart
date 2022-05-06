import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

button142b(String text, TextStyle style,
    String text2, TextStyle style2,
    Color color, String image, double width, double height, double radius, Function _callback){
  return Stack(
    children: <Widget>[

      Container(
          margin: EdgeInsets.all(10),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
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
                    ),),
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
                  Text(text2, style: style2, textAlign: TextAlign.start,),
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
