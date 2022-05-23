import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../logic/map_controller.dart';
import 'data.dart';

class TripPreferences extends ChangeNotifier {
  DateTime departureDateTimePreference =
      DateTime.now().add(const Duration(days: 1));
  int distanceMetersPreference = 2000;
  int costPreference = 2500;
  SortPreference sortPreference = SortPreference.time;

  TripPreferences();

  TripPreferences.full({
    required this.departureDateTimePreference,
    required this.distanceMetersPreference,
    required this.costPreference,
    required this.sortPreference,
  });

  void notifyPreferences() {
    notifyListeners();
  }

  void copyFrom(TripPreferences from) {
    departureDateTimePreference = from.departureDateTimePreference;
    distanceMetersPreference = from.distanceMetersPreference;
    costPreference = from.costPreference;
    sortPreference = from.sortPreference;
  }

  Future<List<Trip>?> applyTripPreferences(
      List<Trip> trips, MapController mapController) async {
    final newTrips = trips;
    final filteredTrips = await filterTrips(newTrips, mapController);
    final sortedTrips = await sortTrips(filteredTrips, mapController);

    return sortedTrips;
  }

  Future<List<Trip>> filterTrips(
      List<Trip> trips, MapController mapController) async {
    var newTrips = trips;
    newTrips = await filterByDistance(newTrips, mapController);
    newTrips = filterByDepartureTime(newTrips);
    newTrips = filterByCost(newTrips);

    return newTrips;
  }

  Future<List<Trip>> sortTrips(
      List<Trip> trips, MapController mapController) async {
    switch (sortPreference) {
      case SortPreference.distance:
        trips = await sortByDistance(trips, mapController);
        break;
      case SortPreference.time:
        sortByDepartureTime(trips);
        break;
      case SortPreference.cost:
        sortByCost(trips);
        break;
    }

    return trips;
  }

  List<Trip> filterByDepartureTime(List<Trip> trips) {
    final newTrips = trips.where((trip) {
      return trip.departureDateTime.compareTo(departureDateTimePreference) != 1;
    }).toList();

    return newTrips;
  }

  Future<List<Trip>> filterByDistance(
      List<Trip> trips, MapController mapController) async {
    final tripsWithDistance = await getTripsDistance(trips, mapController);

    final tripsWithDistanceFiltered = tripsWithDistance
        .where(
            (el) => (el[1] as int) + (el[2] as int) <= distanceMetersPreference)
        .toList();
    final tripsSorted =
        List<Trip>.from(tripsWithDistanceFiltered.map((e) => e.first).toList());

    return tripsSorted;
  }

  List<Trip> filterByCost(List<Trip> trips) {
    final newTrips = trips.where((trip) {
      return trip.cost.compareTo(costPreference) != 1;
    }).toList();

    return newTrips;
  }

  List<Trip> sortByDepartureTime(List<Trip> trips) {
    final newTrips = trips;
    newTrips.sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

    return newTrips;
  }

  Future<List<Trip>> sortByDistance(
    List<Trip> trips,
    MapController mapController,
  ) async {
    final tripsWithDistance = await getTripsDistance(trips, mapController);

    tripsWithDistance.sort((a, b) =>
        ((a[1] as int) + (a[2] as int)) - ((b[1] as int) + (b[2] as int)));
    final tripsSorted =
        List<Trip>.from(tripsWithDistance.map((e) => e.first).toList());

    return tripsSorted;
  }

  Future<List<List<Object>>> getTripsDistance(
      List<Trip> trips, MapController mapController) async {
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

    return tripsWithDistance;
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

  List<Trip> sortByCost(List<Trip> trips) {
    final newTrips = trips;
    newTrips.sort((a, b) => a.cost.compareTo(b.cost));

    return newTrips;
  }
}

enum SortPreference { time, distance, cost }
