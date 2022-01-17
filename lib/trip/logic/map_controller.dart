import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends ChangeNotifier {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  late String fromPointAddress;
  late LatLng fromPointLatLng;
  late String toPointAddress;
  late LatLng toPointLatLng;
}