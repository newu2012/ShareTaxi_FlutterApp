import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/trip.dart';

class TripListTile extends StatelessWidget {
  const TripListTile(Trip this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.title,
            style: const TextStyle(fontSize: 19),
          ),
          Row(
            children: [
              const Icon(Icons.people),
              Text('${trip.currentCompanions}/${trip.maximumCompanions}'),
              const SizedBox(
                width: 16,
              ),
              const Icon(Icons.paid),
              Text('${trip.costOverall}/${trip.oneUserCost}'),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.schedule),
              Text(DateFormat('HH:mm').format(trip.departureTime)),
            ],
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
