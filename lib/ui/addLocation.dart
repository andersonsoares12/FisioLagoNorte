import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/edit/edit24.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BarberAddLocationScreen extends StatefulWidget {
  final Function(String)? callback;

  const BarberAddLocationScreen({Key? key, this.callback}) : super(key: key);
  @override
  _BarberAddLocationScreenState createState() => _BarberAddLocationScreenState();
}

class _BarberAddLocationScreenState extends State<BarberAddLocationScreen> {

  var windowWidth;
  var windowHeight;
  var _controllerStreet = TextEditingController();
  var _controllerCity = TextEditingController();
  var _controllerState = TextEditingController();
  var _controllerCountry = TextEditingController();
  GoogleMapController? _controller;
  double _currentZoom = 12;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.846575206328446, 2.302420789679285), zoom: 12,); // paris coordinates

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _controllerStreet.dispose();
    _controllerCity.dispose();
    _controllerState.dispose();
    _controllerCountry.dispose();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );

  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, bottom: 10),
              child: ListView(
                children: _getList(),
              ),),

            appbar1(Colors.white, Colors.black, "Address", context, () {widget.callback!("");})

          ],
        )

    );
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: true, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;

        });
  }

  _getCurrentLocation() async {
    var position = await getCurrentLocation();
    if (position == null)
      return;
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 70,));

    list.add(Container(
      // margin: EdgeInsets,
      width: windowWidth,
      height: windowWidth/2,
      child: _map(),
    ));

    list.add(SizedBox(height: 20,));
    _item(list, "Street", "", _controllerStreet);
    _item(list, "City", "", _controllerCity);
    _item(list, "State", "", _controllerState);
    _item(list, "Country", "", _controllerCountry);

    list.add(SizedBox(height: 20,));
    list.add(button2("Save", Colors.blue, 10, _save, true));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _item(List<Widget> list, String text1, String text2, TextEditingController _controller){
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.02, right: windowWidth*0.02, bottom: 3),
      child: Text(text1, style: TextStyle(color: Colors.grey),),));

    list.add(Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Edit24(
        hint: text2,
        color: Colors.grey,
        radius: 10,
        controller: _controller,
      ),));

    return list;
  }

  _save(){
    widget.callback!("");
  }


}


