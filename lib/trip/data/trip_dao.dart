import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../chat/data/message.dart';
import '../../chat/data/message_dao.dart';
import '../../common/data/fire_user_dao.dart';
import 'trip.dart';

class TripDao extends ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('trip');

  Future<String> saveTrip(Trip trip) async {
    final tripId = (await collection.add(trip.toJson())).id;
    MessageDao().saveMessage(Message(
      text: 'создал(а) поездку',
      date: DateTime.now(),
      tripId: tripId,
      isSystem: true,
      messageType: 'createTrip',
      args: [
        FireUserDao().userId()!,
      ],
    ));

    return tripId;
  }

  void updateTrip({required String id, required Trip trip}) async {
    await collection.doc(id).update({
      'currentCompanions': trip.currentCompanions,
    });
  }

  Stream<QuerySnapshot> getTripStream() {
    return collection
        .where('departureTime', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
  }

  Stream<DocumentSnapshot<Object?>> getTripStreamById(String id) {
    return collection.doc(id).snapshots();
  }

  Stream<QuerySnapshot> getTripsByUserId(String userId) {
    return collection.where('currentCompanions', arrayContainsAny: [
      {
        'userId': userId,
        'companionType': 'driver',
      },
      {
        'userId': userId,
        'companionType': 'passenger',
      },
    ]).snapshots();
  }
}
