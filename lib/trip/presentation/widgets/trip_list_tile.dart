import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../logic/map_controller.dart';

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
            Text(
              trip.title,
              style: const TextStyle(fontSize: 19),
            ),
            DistanceAndAddresses(trip: trip),
            TripMainInfoRow(trip: trip),
          ],
        ),
      ),
    );
  }
}

class TripMainInfoRow extends StatelessWidget {
  const TripMainInfoRow({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final costOverall = trip.costOverall >= 1000
        ? '${(trip.costOverall / 1000).toStringAsFixed(1)} к'
        : '${trip.costOverall}';
    final costOneUser = trip.oneUserCost >= 1000
        ? '${(trip.oneUserCost / 1000).toStringAsFixed(1)} к'
        : '${trip.oneUserCost}';
    final costText = costOverall.endsWith('к') && costOneUser.endsWith('к')
        ? Text('$costOverall/$costOneUser')
        : Text('$costOverall/$costOneUser руб.');

    return Row(
      children: [
        Icon(
          Icons.schedule,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 4,
        ),
        Text('${DateFormat('HH:mm').format(trip.departureTime)} выезд'),
        const SizedBox(
          width: 12,
        ),
        Icon(
          Icons.people,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${trip.currentCompanions.length}/${trip.maximumCompanions}',
        ),
        const SizedBox(
          width: 12,
        ),
        Icon(
          Icons.payments,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 4,
        ),
        costText,
      ],
    );
  }
}

class DistanceAndAddresses extends StatelessWidget {
  const DistanceAndAddresses({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DistanceBetweenPoints(
              fromPoint: Provider.of<MapController>(context, listen: false)
                  .fromPointAddress,
              toPoint: trip.fromPointAddress,
              fromUser: true,
            ),
            DistanceBetweenPoints(
              fromPoint: Provider.of<MapController>(context, listen: false)
                  .toPointAddress,
              toPoint: trip.toPointAddress,
              fromUser: false,
            ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip.fromPointAddress),
            const SizedBox(
              height: 8,
            ),
            Text(trip.toPointAddress),
          ],
        ),
      ],
    );
  }
}

class DistanceBetweenPoints extends StatelessWidget {
  final String fromPoint;
  final String toPoint;
  final bool fromUser;

  const DistanceBetweenPoints({
    Key? key,
    required this.fromPoint,
    required this.toPoint,
    required this.fromUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = fromUser
        ? Icon(
            MdiIcons.carArrowLeft,
            color: Theme.of(context).primaryColor,
          )
        : const Icon(
            MdiIcons.carArrowRight,
            color: Color.fromRGBO(255, 174, 3, 100),
          );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          width: 4,
        ),
        FutureBuilder(
          future: getDistance(fromPoint, toPoint),
          builder: (_, snapshot) {
            if (!snapshot.hasData) return const Text('...');
            final distance = snapshot.data as int;

            return distance > 1000
                ? Text('${(distance / 1000).toStringAsFixed(1)} км.')
                : Text('${distance} м.');
          },
        ),
      ],
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
