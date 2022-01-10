import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Trip {
  final String? creatorId;
  final String title;
  final String fromPointAddress;
  final String toPointAddress;
  final List<String> currentCompanions;
  final int maximumCompanions;
  final int costOverall;
  int get oneUserCost =>
      (costOverall / min((currentCompanions.length + 1), maximumCompanions))
          .round();
  final DateTime departureTime;

  DocumentReference? reference;

  Trip({
    required this.creatorId,
    required this.title,
    required this.fromPointAddress,
    required this.toPointAddress,
    required this.currentCompanions,
    required this.maximumCompanions,
    required this.costOverall,
    required this.departureTime,
    this.reference,
  });

  Trip.fromTrip({
    required Trip trip,
    String? creatorId,
    String? title,
    String? fromPointAddress,
    String? toPointAddress,
    List<String>? currentCompanions,
    int? maximumCompanions,
    int? costOverall,
    DateTime? departureTime,
    DocumentReference? reference,
  })  : creatorId = creatorId ?? trip.creatorId,
        title = title ?? trip.title,
        fromPointAddress = fromPointAddress ?? trip.fromPointAddress,
        toPointAddress = toPointAddress ?? trip.toPointAddress,
        currentCompanions = currentCompanions ?? trip.currentCompanions,
        maximumCompanions = maximumCompanions ?? trip.maximumCompanions,
        costOverall = costOverall ?? trip.costOverall,
        departureTime = departureTime ?? trip.departureTime,
        reference = reference ?? trip.reference;

  factory Trip.fromJson(Map<dynamic, dynamic> json) => Trip(
        creatorId: json['creatorId'] as String,
        title: json['title'] as String,
        fromPointAddress: json['fromPointAddress'] as String,
        toPointAddress: json['toPointAddress'] as String,
        currentCompanions: List.from(json['currentCompanions']),
        maximumCompanions: json['maximumCompanions'] as int,
        costOverall: json['costOverall'] as int,
        departureTime: (json['departureTime'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'creatorId': creatorId,
        'title': title,
        'fromPointAddress': fromPointAddress,
        'toPointAddress': toPointAddress,
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
