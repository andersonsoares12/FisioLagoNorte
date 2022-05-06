import 'package:FisioLago/model/data.dart';
import 'package:flutter/material.dart';
import 'package:FisioLago/widgets/buttons/button98.dart';
import 'package:FisioLago/widgets/image/image17.dart';

card22(Color colorAvatar, Color barberMainColor, Function() callback, String avatar){
  return Container(
    margin: EdgeInsets.only(left: 5, right: 5),
    height: 100,
    decoration: BoxDecoration(
      color: (darkMode) ? Colors.black : Colors.white,
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
    child: Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (avatar.isEmpty)
              image17(Image.asset("assets/avatar.png",
                  fit: BoxFit.cover
              ), 75, colorAvatar),
            if (avatar.isNotEmpty)
              Container(
                  height: 90,
                  width: 90,
                  padding: EdgeInsets.all(3),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          avatar,
                          height: 40,
                          fit: BoxFit.cover))
            ),


            SizedBox(width: 20,),
            button98(barberMainColor, "assets/icons/058-photo camera.png", (){callback();}, true),
          ],
        )),
  );
}