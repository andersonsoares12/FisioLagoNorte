import 'package:flutter/material.dart';

appbar30(Color bkgColor, Color color, String text, IconData icon0, IconData icon2, IconData icon3,
    BuildContext context, int _chatCount, Function(int) callback){
  return Container(
    height: 40+MediaQuery.of(context).padding.top,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    color: bkgColor,
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(icon0, color: color,)),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        callback(0);
                      }, // needed
                    )),
              )
            ],
          ),
        ),

        Expanded(
          child: SizedBox.fromSize(),
        ),

        Container(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(child: Icon(icon2 , color: color, size: 25,)
                    )),
                    if (_chatCount != 0)
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(_chatCount.toString(), style: TextStyle(fontSize: 14, color: Colors.white),)
                        )
                    ),
                    Positioned.fill(
                        child: Material(
                            color: Colors.transparent,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.grey[400],
                              onTap: (){
                                callback(2);
                              }, // needed
                            ))),
                  ],
                )
            ),

        Container(
            width: 40,
            height: 40,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(icon3, color: color,)),
                ),
                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.grey[400],
                        onTap: (){
                          callback(3);
                        }, // needed
                      )),
                )
              ],
            )),
        
      ],
    )
  );
}