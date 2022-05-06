import 'dart:math';
import 'package:FisioLago/model/appointment.dart';
import 'package:FisioLago/model/data.dart';
import 'package:FisioLago/model/paypal/PaypalPayment.dart';
import 'package:FisioLago/model/razorpay.dart';
import 'package:FisioLago/model/stripe.dart';
import 'package:FisioLago/model/user.dart';
import 'package:FisioLago/model/util.dart';
import 'package:FisioLago/ui/main.dart';
import 'package:FisioLago/widgets/checkbox/checkbox43a.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:FisioLago/widgets/appbars/appbar1.dart';
import 'package:FisioLago/widgets/buttons/button2.dart';
import 'package:FisioLago/widgets/cards/card4.dart';
import 'package:FisioLago/widgets/checkbox/checkbox43.dart';
import 'package:FisioLago/widgets/pagin/pagin2.dart';
import '../main.dart';
import 'appointment5.dart';

class BarberAppointment4Screen extends StatefulWidget {
  const BarberAppointment4Screen({Key? key}) : super(key: key);

  @override
  _BarberAppointment4ScreenState createState() => _BarberAppointment4ScreenState();
}

class _BarberAppointment4ScreenState extends State<BarberAppointment4Screen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  // bool _wait = true;
  _waits(bool value){
    // _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return WillPopScope(
        onWillPop: () async {
          return _callBack();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[

                Container(
                  width: windowWidth,
                  height: windowHeight,
                  color: (darkMode) ? Colors.black : Colors.white30,
                ),

                Container (
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    children: _step2(),
                  ),),

                appbar1((darkMode) ? Colors.black : Colors.white,
                    (darkMode) ? Colors.white : Colors.black, strings.get(60), // "Book Appointment",
                    context, () {
                      _callBack();
                    })

              ],
            )

        ));
  }

  _callBack(){
    Navigator.pop(context);
    return false;
  }

  _step2() {
    List<Widget> list = [];

    list.add(Container(
        padding: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15, top: 30, bottom: 30),
        child: pagination2([Icons.home, Icons.stairs, Icons.date_range, Icons.local_offer, Icons.payment, Icons.send],
            4, Color(0xFF225C3C), windowWidth*0.7)),
    );
    list.add(Divider(color: (darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 20,));

    var _prices = "";
    var _time = "";
    appointmentData.services = "";
    for (var item in appointmentData.works) {
      appointmentData.services = "${appointmentData.services}${item.name}\n";
      _prices = "$_prices${getPriceString(item.price2)}\n";
    }
    var _start = DateFormat(getTimeFormat()).format(appointmentData.selectSlot!.timeStart);
    var _end = DateFormat(getTimeFormat()).format(appointmentData.selectSlot!.timeEnd);
    _time = "$_start-$_end";
    var t = DateFormat(dateFormat).format(appointmentData.selectedDay);

    appointmentData.priceWithCoupon = appointmentData.priceAll;

    // offers
    var _text = "";
    if (appointmentData.offer != null) {
      if (appointmentData.offer!.percentage) {
        _text = "-${appointmentData.offer!.discount.toStringAsFixed(0)}%";
        appointmentData.priceWithCoupon = appointmentData.priceAll - (appointmentData.priceAll*appointmentData.offer!.discount/100);
      }else {
        _text = "-${getPriceString(appointmentData.offer!.discount)}";
        appointmentData.priceWithCoupon = appointmentData.priceAll - appointmentData.offer!.discount;
      }
      appointmentData.couponDiscount = _text;
    }
    // points
    if (appointmentData.enablePoints){
      appointmentData.subPoints = userGetPoints(appointmentData.salon!.id);
      if (appointmentData.subPoints > appointmentData.priceWithCoupon)
        appointmentData.subPoints = appointmentData.priceWithCoupon.toInt();
      appointmentData.priceWithCoupon = appointmentData.priceWithCoupon-appointmentData.subPoints;
    }

    String pointText = strings.get(131); // "Your points",
    String point = appointmentData.getPoints();

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: card4(appointmentData.employee!.image, appointmentData.employee!.name, "$_time $t",
            "", "",
            appointmentData.services,
            _prices, windowWidth,
            (appointmentData.offer == null) ? "" : "Coupon",
            _text,
            strings.get(69), // "Total Pay",
            getPriceString(appointmentData.priceWithCoupon),
            // points
            pointText, point,
            appointmentData.subPoints
        )
    ));

    if (userGetPoints(appointmentData.salon!.id) != 0)
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 30, top: 30),
          child: Row(
            children: [
              Expanded(child: Text("${strings.get(132)} ${userGetPoints(appointmentData.salon!.id)} "  // You have - points. Do you want to spend them?",
                  "${strings.get(133)}", style: TextStyle(fontSize: 20, color: Colors.green),),),
              SizedBox(width: 20,),
              checkBox43a(Color(0xFF225C3C), appointmentData.enablePoints, (val) {
                appointmentData.enablePoints = val;
                appointmentData.subPoints = 0;
                _redraw();
              }),
            ],
          )
      ));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: checkBox43(strings.get(70), // "Cash payment",
          Color(0xFF225C3C), "assets/cache.png",
          TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black), _check1, (val) {
            _check1 = val;
            if (_check1){
              _check2 = false;
              _check3 = false;
              _check4 = false;
            }
            _checkConfirmPayment();
          }),
    ));

    if (stripe)
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Stripe", Color(0xFF225C3C), "assets/stripe.png",
            TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black), _check2, (val) {
              _check2 = val;
              if (_check2){
                _check4 = false;
                _check3 = false;
                _check1 = false;
              }
              _checkConfirmPayment();
            }),
      ));

    if (razorpay)
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: checkBox43("Razorpay", Color(0xFF225C3C), "assets/razorpay.png",
              TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black), _check3, (val) {
                _check3 = val;
                if (_check3){
                  _check1 = false;
                  _check2 = false;
                  _check4 = false;
                }
                _checkConfirmPayment();
              })));

    if (paypal)
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: checkBox43("Pay Pal", Color(0xFF225C3C), "assets/paypal.png",
              TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black), _check4, (val) {
                _check4 = val;
                if (_check4){
                  _check1 = false;
                  _check2 = false;
                  _check3 = false;
                }
                _checkConfirmPayment();
              })));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 100),
        child: button2(strings.get(71), // "Confirm Payment",
            Color(0xFF225C3C), 10, _confirm, _buttonConfirmEnable)
    ));

    return list;
  }

  bool _buttonConfirmEnable = true;

  _checkConfirmPayment(){
    if (!_check1 && !_check2 && !_check3 && !_check4)
      _buttonConfirmEnable = false;
    else
      _buttonConfirmEnable = true;
    setState(() {
    });
  }

  var _check1 = true;
  var _check2 = false;
  var _check3 = false;
  var _check4 = false;


  _onError(String err){
    _waits(false);
    if (err == "ERROR: 2")
      return;
    if (err == "cancelled")
      return;
    _errorMsg("${strings.get(72)} $err"); // "Something went wrong. ",
  }

  _errorMsg(String str){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: barberMainColor,
        content: Text(str,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)));
  }

  _confirm(){
    double _total = appointmentData.priceWithCoupon * 100;
    if (_check1)
      _appointment(strings.get(70)); // "Cash payment",
    if (_check2){
      StripeModel _stripe = StripeModel();
      _waits(true);
      _stripe.init(stripePKey);
      var t = _total.toInt();
      try {
        _stripe.openCheckoutCard(t, "", "", razorpayCompanyName, code, stripeSKey, _appointment);
      }catch(ex){
        print(ex.toString());
      }
    }
    if (_check3){
      _waits(true);
      RazorpayModel _razorpayModel = RazorpayModel();
      _razorpayModel.init();

      var t = _total.toInt();
      _razorpayModel.openCheckout(t.toString(), "", "", razorpayCompanyName, code, razorpayKeyId,
          _appointment, _onError
      );
    }
    if (_check4){
      String _total = appointmentData.priceWithCoupon.toStringAsFixed(digitsAfterComma);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaypalPayment(
              currency: code,
              userFirstName: "",
              userLastName: "",
              userEmail: "",
              payAmount: _total,
              secret: payPalSKey,
              clientId: payPalClient,
              sandBoxMode: "false",
              onFinish: (w){
                _appointment("PayPal: $w");
              }
          ),
        ),
      );
    }
  }

  _appointment(String id) async {
    var ret = await appointmentData.finish(id);
    _waits(false);
    if (ret == null)
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarberAppointment5Screen(),
        ),
      );
    messageError(context, ret);
  }
}


