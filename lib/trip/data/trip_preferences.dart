import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../logic/map_controller.dart';
import 'data.dart';

class TripPreferences extends ChangeNotifier {
  var departureDateTimePreference =
      DateTime.now().add(const Duration(hours: 2));
  var distanceMetersPreference = 2000;
  var costRubPreference = null;

  TripPreferences();

  TripPreferences.full({
    required this.departureDateTimePreference,
    required this.distanceMetersPreference,
    required this.costRubPreference,
  });

  void copyFrom(TripPreferences from) {
    departureDateTimePreference = from.departureDateTimePreference;
    distanceMetersPreference = from.distanceMetersPreference;
    costRubPreference = from.costRubPreference;
  }

  Future<List<Trip>> applyTripPreferences(
      List<Trip> trips, MapController mapController) async {
    var newTrips = trips;
    newTrips = filterTrips(newTrips);
    newTrips = sortTrips(newTrips);
    return newTrips;
  }

  List<Trip> filterTrips(List<Trip> trips) {
    var newTrips = trips.where((trip) {
      print(trip.departureTime);
      print(departureDateTimePreference);
      print(trip.departureTime.compareTo(departureDateTimePreference));
      return trip.departureTime.compareTo(departureDateTimePreference) == -1;
    }).toList();

    return newTrips;
  }

  List<Trip> sortTrips(List<Trip> trips) {
    return trips;
  }

  Future<List<Trip>> _sortTripsByDistance(
    List<Trip> trips,
    MapController mapController,
  ) async {
    final tripsWithDistance = await Future.wait(trips.map((e) async {
      return [
        e,
        await getDistance(
          mapController.toPointAddress!,
          e.toPointAddress,
        ),
        await getDistance(
          mapController.fromPointAddress!,
          e.fromPointAddress,
        ),
      ];
    }));

    tripsWithDistance.sort((a, b) {
      return ((a[1] as int) + (a[2] as int)) - ((b[1] as int) + (b[2] as int));
    });
    final tripsSorted =
        List<Trip>.from(tripsWithDistance.map((e) => e.first).toList());

    return tripsSorted;
  }

  Future<int> getDistance(String fromAddress, String toAddress) async {
    final fromLocation =
        (await GeocodingPlatform.instance.locationFromAddress(fromAddress))
            .map((e) => LatLng(e.latitude, e.longitude))
            .first;
    final toLocation =
        (await GeocodingPlatform.instance.locationFromAddress(toAddress))
            .map((e) => LatLng(e.latitude, e.longitude))
            .first;

    final distance =
        const Distance().distance(fromLocation, toLocation).toInt();

    return distance;
  }
}
