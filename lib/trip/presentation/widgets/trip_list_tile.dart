import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import 'widgets.dart';
import '../../data/trip.dart';

class TripListTile extends StatelessWidget {
  const TripListTile(this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                trip.title,
                style: const TextStyle(fontSize: 19),
                overflow: TextOverflow.fade,
              ),
            ),
            DistanceAndAddressesRow(trip: trip),
            TripMainInfoRow(trip: trip),
          ],
        ),
      ),
    );
  }
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

  final distance = const Distance().distance(fromLocation, toLocation).toInt();

  return distance;
}
