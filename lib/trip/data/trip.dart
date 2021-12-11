import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String? creatorId;
  final String title;
  final GeoPoint fromPoint;
  final GeoPoint toPoint;
  final int currentCompanions;
  final int maximumCompanions;
  final int costOverall;
  int get oneUserCost => (costOverall / (currentCompanions + 1)).round();
  final DateTime departureTime;

  DocumentReference? reference;

  Trip({
    required this.creatorId,
    required this.title,
    required this.fromPoint,
    required this.toPoint,
    required this.currentCompanions,
    required this.maximumCompanions,
    required this.costOverall,
    required this.departureTime,
    this.reference,
  });

  factory Trip.fromJson(Map<dynamic, dynamic> json) => Trip(
        creatorId: json['creatorId'] as String,
        title: json['title'] as String,
        fromPoint: json['fromPoint'] as GeoPoint,
        toPoint: json['toPoint'] as GeoPoint,
        currentCompanions: json['currentCompanions'] as int,
        maximumCompanions: json['maximumCompanions'] as int,
        costOverall: json['costOverall'] as int,
        departureTime: (json['departureTime'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'creatorId': creatorId,
        'title': title,
        'fromPoint': fromPoint,
        'toPoint': toPoint,
        'currentCompanions': currentCompanions,
        'maximumCompanions': maximumCompanions,
        'costOverall': costOverall,
        'departureTime': departureTime,
      };

  factory Trip.fromSnapshot(DocumentSnapshot snapshot) {
    final trip = Trip.fromJson(snapshot.data() as Map<String, dynamic>);
    trip.reference = snapshot.reference;

    return trip;
  }
}
