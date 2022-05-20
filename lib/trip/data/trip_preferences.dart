import 'package:flutter/material.dart';

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
}
