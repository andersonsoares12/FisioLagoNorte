import 'package:cloud_firestore/cloud_firestore.dart';

List<OffersData> offers = [];

class OffersData{
  OffersData(this.id, this.name, this.minAmount,
      this.dateStart, this.dateEnd, this.percentage, this.discount, this.salons);
  final String id;
  final String name;
  final double? minAmount;
  final DateTime dateStart;
  final DateTime dateEnd;
  final bool percentage;
  final double discount;
  final List<String> salons;
  bool select = false;
}

loadOffers(Function() callback, Function() callbackError){
  FirebaseFirestore.instance.collection("offers").get().then((querySnapshot) async {
    offers = [];
    for (var result in querySnapshot.docs){
      var t = result.data();
      List<String> _salons = [];
      if (t["salons"] != null)
        for (dynamic key in t['salons'])
          _salons.add(key);

      offers.add(OffersData(result.id, t["name"], t["minAmount"]?.toDouble(),
          DateTime.fromMillisecondsSinceEpoch(t["dateStart"]),
          DateTime.fromMillisecondsSinceEpoch(t["dateEnd"]),
          t["percentage"], t["discount"].toDouble(), _salons));
    }
  }).catchError((ex){
    print(ex.toString());
    callbackError();
  });
}
