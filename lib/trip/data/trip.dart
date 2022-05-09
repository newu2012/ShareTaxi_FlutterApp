import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/data/fire_user_dao.dart';

class Trip {
  String? creatorId;
  String title;
  String fromPointAddress;
  LatLng fromPointLatLng;
  String toPointAddress;
  LatLng toPointLatLng;
  List<Companion> currentCompanions;
  int maximumCompanions;
  int costOverall;

  int get oneUserCost => (costOverall /
          (currentCompanions
                  .map((e) => e.userId)
                  .contains(FireUserDao().userId())
              ? currentCompanions.length
              : min(currentCompanions.length + 1, maximumCompanions)))
      .round();
  final DateTime departureTime;

  DocumentReference? reference;

  Trip({
    required this.creatorId,
    required this.title,
    required this.fromPointAddress,
    required this.fromPointLatLng,
    required this.toPointAddress,
    required this.toPointLatLng,
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
    LatLng? fromPointLatLng,
    String? toPointAddress,
    LatLng? toPointLatLng,
    List<Companion>? currentCompanions,
    int? maximumCompanions,
    int? costOverall,
    DateTime? departureTime,
    DocumentReference? reference,
  })  : creatorId = creatorId ?? trip.creatorId,
        title = title ?? trip.title,
        fromPointAddress = fromPointAddress ?? trip.fromPointAddress,
        fromPointLatLng = fromPointLatLng ?? trip.fromPointLatLng,
        toPointAddress = toPointAddress ?? trip.toPointAddress,
        toPointLatLng = toPointLatLng ?? trip.toPointLatLng,
        currentCompanions = currentCompanions ?? trip.currentCompanions,
        maximumCompanions = maximumCompanions ?? trip.maximumCompanions,
        costOverall = costOverall ?? trip.costOverall,
        departureTime = departureTime ?? trip.departureTime,
        reference = reference ?? trip.reference;

  factory Trip.fromJson(Map<dynamic, dynamic> json) => Trip(
        creatorId: json['creatorId'] as String,
        title: json['title'] as String,
        fromPointAddress: json['fromPointAddress'] as String,
        fromPointLatLng: LatLng(
          (json['fromPointLatLng'] as GeoPoint).latitude,
          (json['fromPointLatLng'] as GeoPoint).longitude,
        ),
        toPointAddress: json['toPointAddress'] as String,
        toPointLatLng: LatLng(
          (json['toPointLatLng'] as GeoPoint).latitude,
          (json['toPointLatLng'] as GeoPoint).longitude,
        ),
        currentCompanions: CompanionsFromJson(json),
        maximumCompanions: json['maximumCompanions'] as int,
        costOverall: json['costOverall'] as int,
        departureTime: (json['departureTime'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'creatorId': creatorId,
        'title': title,
        'fromPointAddress': fromPointAddress,
        'fromPointLatLng':
            GeoPoint(fromPointLatLng.latitude, fromPointLatLng.longitude),
        'toPointAddress': toPointAddress,
        'toPointLatLng':
            GeoPoint(toPointLatLng.latitude, toPointLatLng.longitude),
        'currentCompanions': CompanionsToJson(),
        'maximumCompanions': maximumCompanions,
        'costOverall': costOverall,
        'departureTime': departureTime,
      };

  static List<Companion> CompanionsFromJson(json) {
    final companionsList = List.from(json['currentCompanions'])
        .map((e) => Companion(
              userId: e['userId'],
              companionType: CompanionType.values.byName(e['companionType']),
            ))
        .toList();

    return companionsList;
  }

  List<Map<String, String>> CompanionsToJson() {
    final companionsList = currentCompanions
        .map(
          (e) => <String, String>{
            'userId': e.userId,
            'companionType': e.companionType.name,
          },
        )
        .toList();

    return companionsList;
  }

  factory Trip.fromSnapshot(DocumentSnapshot snapshot) {
    final trip = Trip.fromJson(snapshot.data() as Map<String, dynamic>);
    trip.reference = snapshot.reference;

    return trip;
  }
}

class Companion {
  late String userId;
  late CompanionType companionType;

  Companion({
    required String this.userId,
    required CompanionType this.companionType,
  });
}

enum CompanionType { driver, passenger }
