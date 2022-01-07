import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../logic/map_controller.dart';

import '../../data/trip.dart';

class TripListTile extends StatelessWidget {
  const TripListTile(Trip this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.title,
            style: const TextStyle(fontSize: 19),
          ),
          DistanceAndAddresses(trip: trip),
          Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(
                width: 4,
              ),
              Text('${DateFormat('HH:mm').format(trip.departureTime)} выезд'),
              const SizedBox(
                width: 12,
              ),
              const Icon(Icons.people),
              const SizedBox(
                width: 4,
              ),
              Text('${trip.currentCompanions}/${trip.maximumCompanions}'),
              const SizedBox(
                width: 12,
              ),
              const Icon(Icons.payments),
              const SizedBox(
                width: 4,
              ),
              Text('${trip.costOverall}/${trip.oneUserCost} руб.'),
            ],
          ),
        ],
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

  final distance = (_calculateMeterDistance(fromLocation, toLocation)).toInt();

  return distance;
}

double _calculateMeterDistance(LatLng p1, LatLng p2) {
  const distance = Distance();

  return distance(p1, p2);
}

class DistanceAndAddresses extends StatelessWidget {
  const DistanceAndAddresses({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DistanceFromPoint(
              fromPoint: Provider.of<MapController>(context, listen: false)
                  .fromPointAddress,
              toPoint: trip.fromPointAddress,
            ),
            Text(trip.fromPointAddress),
          ],
        ),
        Row(
          children: [
            DistanceToPoint(
              fromPoint: Provider.of<MapController>(context, listen: false)
                  .toPointAddress,
              toPoint: trip.toPointAddress,
            ),
            Text(trip.toPointAddress),
          ],
        ),
      ],
    );
  }
}

//  TODO Сделать общий класс вместо Distance...
class DistanceFromPoint extends StatelessWidget {
  final String fromPoint;
  final String toPoint;

  const DistanceFromPoint({
    Key? key,
    required this.fromPoint,
    required this.toPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(MdiIcons.carArrowLeft),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 60,
          child: FutureBuilder(
            future: getDistance(fromPoint, toPoint),
            builder: (_, snapshot) => Text('${snapshot.data} м.'),
          ),
        ),
      ],
    );
  }
}

class DistanceToPoint extends StatelessWidget {
  final String fromPoint;
  final String toPoint;

  const DistanceToPoint({
    Key? key,
    required this.fromPoint,
    required this.toPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(MdiIcons.carArrowLeft),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 60,
          child: FutureBuilder(
            future: getDistance(fromPoint, toPoint),
            builder: (_, snapshot) => Text('${snapshot.data} м.'),
          ),
        ),
      ],
    );
  }
}
