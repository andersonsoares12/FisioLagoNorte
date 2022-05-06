import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

button145(String text, TextStyle style,
    Color color, String image, double width, double height, double radius, Function _callback){
  return Stack(
    children: <Widget>[

      Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: new BorderRadius.all(Radius.circular(radius)),
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

              SizedBox(height: 10,),
              Text(text, style: style, textAlign: TextAlign.center,),
              SizedBox(height: 10,),
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
