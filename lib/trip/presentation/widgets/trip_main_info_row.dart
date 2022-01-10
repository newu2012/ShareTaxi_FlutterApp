import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/trip.dart';

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
