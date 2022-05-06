import 'dart:math';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/pagin/pagin1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  final String item;
  final List<String> gallery;

  const GalleryScreen({Key? key, required this.item, required this.gallery}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {

  var windowWidth;
  var windowHeight;
  double? windowSize;
  TabController? _tabController;
  var _index = 0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.gallery.length);
    _tabController!.addListener((){
      _index = _tabController!.index;
      setState(() {});
    });
    _tabController!.animateTo(widget.gallery.indexOf(widget.item));
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

        Container(
          //margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Container(
              height: windowHeight,
              width: windowWidth,
              child: TabBarView(
                controller: _tabController,
                children: widget.gallery.map((item) {
                  return Container(
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
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            errorWidget: (context,url,error) => new Icon(Icons.error),
                          ),
                        ),
                      ));
                }).toList()
              ),
            ),
        ),

        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 20),
          child: pagination1(_tabController!.length, _index, barberMainColor),
        ),

        appbar1(Colors.transparent, barberMainColor, "", context, () {Navigator.pop(context);})

    ]));
  }
}


