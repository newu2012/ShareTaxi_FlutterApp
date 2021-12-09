import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'trip.dart';

class TripDao extends ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('trip');

  Future<String> saveTrip(Trip trip) async {
    return (await collection.add(trip.toJson())).id;
  }

  Stream<QuerySnapshot> getTripStream() {
    return collection
        .where('departureTime', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
  }
}
