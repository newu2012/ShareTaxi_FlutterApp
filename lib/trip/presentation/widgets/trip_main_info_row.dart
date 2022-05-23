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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DepartureDateTimeRow(trip: trip),
        CurrentCompanionsRow(trip: trip),
        CostRow(trip: trip),
      ],
    );
  }
}

class DepartureDateTimeRow extends StatelessWidget {
  final Trip trip;

  const DepartureDateTimeRow({Key? key, required Trip this.trip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 4,
        ),
        Text('${DateFormat('dd.MM HH:mm').format(trip.departureDateTime)}'),
      ],
    );
  }
}

class CurrentCompanionsRow extends StatelessWidget {
  final Trip trip;

  const CurrentCompanionsRow({Key? key, required Trip this.trip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
      ],
    );
  }
}

class CostRow extends StatelessWidget {
  final Trip trip;

  const CostRow({Key? key, required Trip this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cost = trip.cost >= 1000
        ? '${(trip.cost / 1000).toStringAsFixed(1)}к руб.'
        : '${trip.cost} руб.';

    return Row(
      children: [
        Icon(
          Icons.payments,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(cost),
      ],
    );
  }
}
