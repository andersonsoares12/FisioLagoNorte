import 'dart:typed_data';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/buttons/button142b.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../main.dart';
import '../model/pref.dart';

class BarberMapScreen extends StatefulWidget {
  final Function(String) callback;

  const BarberMapScreen({Key? key, required this.callback}) : super(key: key);
  @override
  _BarberMapScreenState createState() => _BarberMapScreenState();
}

class _BarberMapScreenState extends State<BarberMapScreen> {

  var windowWidth;
  var windowHeight;

  GoogleMapController? _controller;
  double _currentZoom = 17;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.855988794731125, 2.3372043112653516), zoom: 17,); // paris coordinates
  String? _mapStyle;

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    var _lat = toDouble(pref.get(Pref.mainMapLat));
    var _lng = toDouble(pref.get(Pref.mainMapLng));
    var _zoom = toDouble(pref.get(Pref.mainMapZoom));
    if (_zoom != 0) {
      _currentZoom = _zoom;
      _kGooglePlex = CameraPosition(target: LatLng(_lat, _lng), zoom: _zoom,);
    }
    _initIcons();
    super.initState();
  }

  var _iconBarber;
  Set<Marker> markers = {};

  _initIcons() async {
    final Uint8List markerIcon = await ((darkMode) ? getBytesFromAsset('assets/barber/barber2.png', 100)
        : getBytesFromAsset('assets/barber/barber.png', 100));
    _iconBarber = BitmapDescriptor.fromBytes(markerIcon);

    for (var item in salons)
      if (item.lat != 0 && item.lng != 0)
        item.marker = _addMarker(item.id, LatLng(item.lat, item.lng), item.name);
    setState(() {
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Stack(
          children: <Widget>[

            Container(
              width: windowWidth,
              height: windowHeight,
              child: _map(),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buttonPlus(_onMapPlus),
                      buttonMinus(_onMapMinus),
                      _buttonMyLocation(_getCurrentLocation),
                    ],
                  )
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 50),
              child: _horizontalSalons(),
            )

          ],
        )

    );
  }

  _horizontalSalons(){
    List<Widget> list = [];
      for (var item in salons){
        log("_horizontalSalons add ${item.name}");
        list.add(Stack(
          children: [
            button142b(item.name, TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black),
                item.address, TextStyle(fontSize: 13, color: (darkMode) ? Colors.white : Colors.black),
                (darkMode) ? Colors.black : Colors.white, item.imageUrl, windowWidth*0.55, windowWidth*0.55*0.7, 10, (){

                _controller!.animateCamera(
                  CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(item.lat, item.lng),
                    zoom: _currentZoom,
                  ),
                ),);
                  log("_horizontalSalons goto position ${item.lat} ${item.lng}");
                  _controller!.showMarkerInfoWindow(MarkerId(item.id));
                }),
            if (item.board.isNotEmpty)
              Container(
                  width: windowWidth*0.35,
                  height: windowWidth/2-20,
                  padding: EdgeInsets.only(top: 20, right: 0, left: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(item.board, style: TextStyle(color: Colors.white),),
                    ),
                  )
              )
          ],
        ));
        list.add(SizedBox(width: 10,));
    }
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _onMapPlus(){
    _controller?.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  _onMapMinus(){
    _controller?.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        // myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        // myLocationButtonEnabled: true, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.from(markers),
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
          pref.set(Pref.mainMapLat, cameraPosition.target.latitude.toString());
          pref.set(Pref.mainMapLng, cameraPosition.target.longitude.toString());
          pref.set(Pref.mainMapZoom, cameraPosition.zoom.toString());
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (darkMode)
            controller.setMapStyle(_mapStyle);
        });
  }

  _buttonMyLocation(Function _getCurrentLocation){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: (darkMode) ? Colors.white : Colors.black.withOpacity(0.5),),
          color: (darkMode) ? Colors.black : Colors.white,),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _getCurrentLocation();
                }, // needed
              )),
        )
      ],
    );
  }

  Future<Position> getCurrent() async {
    var _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .timeout(Duration(seconds: 10));
    print("MyLocation::_currentPosition $_currentPosition");
    return _currentPosition;
  }

  _getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return;
    }
    var position = await getCurrent();
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }


  _addMarker(String id, LatLng latlng, String title){
    var _lastMarkerId2 = MarkerId(id);
    final marker = Marker(
        markerId: _lastMarkerId2,
        position: latlng,
        infoWindow: InfoWindow(
          title: title,
          onTap: () {
            print("tap on marker");
          },
        ),
        onTap: () {

        },
        icon: _iconBarber

    );
    markers.add(marker);
    return marker;
  }

  buttonPlus(Function() callback){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.add, size: 30, color: (darkMode) ? Colors.white : Colors.black.withOpacity(0.5),),
              color: (darkMode) ? Colors.black : Colors.white,),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: callback,
              )),
        )
      ],
    );
  }

  buttonMinus(Function() _onMapMinus){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: (darkMode) ? Colors.white : Colors.black.withOpacity(0.5),),
              color: (darkMode) ? Colors.black : Colors.white,),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: _onMapMinus,
              )),
        )
      ],
    );
  }
}

class IBoxCircle extends StatelessWidget {
  final Widget child;
  final Color color;
  IBoxCircle({this.color = Colors.white, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(40),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
            child: Container(
//              margin: EdgeInsets.only(left: 10),
                child: child)
        ),
      );
  }
}