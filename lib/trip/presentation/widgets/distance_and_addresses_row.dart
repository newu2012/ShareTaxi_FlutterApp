import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/trip.dart';
import '../../logic/map_controller.dart';
import 'widgets.dart';

class DistanceAndAddressesRow extends StatelessWidget {
  const DistanceAndAddressesRow({
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
            DistanceBetweenPointsRow(
              fromPoint: Provider.of<MapController>(context, listen: false)
                  .fromPointAddress,
              toPoint: trip.fromPointAddress,
              fromUser: true,
            ),
            DistanceBetweenPointsRow(
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
